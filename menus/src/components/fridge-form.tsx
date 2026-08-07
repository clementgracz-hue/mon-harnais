"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { Refrigerator, Snowflake } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { AISLE_EMOJI } from "@/lib/aisles";
import { suggestDays } from "@/lib/planning";
import { formatExpiry, shelfLifeDays, suggestExpiry } from "@/lib/shelf-life";
import { createClient } from "@/lib/supabase/client";
import type { ShoppingRunItem } from "@/lib/types/database";
import { cn } from "@/lib/utils";

type Draft = {
  item: ShoppingRunItem;
  /** Vide = produit non périssable, on ne le range pas au frigo. */
  expiresOn: string;
  keep: boolean;
};

/**
 * Rangement d'une livraison : les denrées les plus fragiles en tête, avec une
 * date proposée d'après leur nature. C'est cette date qui ordonnera ensuite
 * les repas de la semaine.
 */
export function FridgeForm({
  runId,
  items,
  alreadyStored,
}: {
  runId: string;
  items: ShoppingRunItem[];
  alreadyStored: number;
}) {
  const router = useRouter();
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [drafts, setDrafts] = useState<Draft[]>(() =>
    [...items]
      // Le plus périssable d'abord : c'est ce qu'on veut dater en priorité.
      .sort(
        (a, b) =>
          shelfLifeDays(a.name, a.aisle_category) -
            shelfLifeDays(b.name, b.aisle_category) ||
          a.name.localeCompare(b.name, "fr"),
      )
      .map((item) => {
        const days = shelfLifeDays(item.name, item.aisle_category);
        return {
          item,
          expiresOn: suggestExpiry(item.name, item.aisle_category),
          // Au-delà d'un mois, le suivi n'apporte rien : décoché par défaut.
          keep: days <= 30,
        };
      }),
  );

  async function save() {
    setPending(true);
    setError(null);

    const rows = drafts
      .filter((draft) => draft.keep && draft.expiresOn)
      .map((draft) => ({
        name: draft.item.name,
        aisle_category: draft.item.aisle_category,
        amount: draft.item.amount,
        expires_on: draft.expiresOn,
        run_id: runId,
      }));

    if (rows.length === 0) {
      setError("Aucun produit sélectionné.");
      setPending(false);
      return;
    }

    const supabase = createClient();
    const { error } = await supabase.from("pantry_items").insert(rows);

    if (error) {
      setError(error.message);
      setPending(false);
      return;
    }

    await reorderMeals(supabase);

    setPending(false);
    router.push("/");
    router.refresh();
  }

  /**
   * Les DLC viennent d'être saisies : les repas de cette commande sont
   * replacés dans leur ordre, le plus urgent en premier. Les jours restent
   * modifiables à la main ensuite.
   */
  async function reorderMeals(supabase: ReturnType<typeof createClient>) {
    const [{ data: mealRows }, { data: pantry }] = await Promise.all([
      supabase
        .from("shopping_run_recipes")
        .select("id, recipe_id, title, recipes(recipe_ingredients(name))")
        .eq("run_id", runId),
      supabase
        .from("pantry_items")
        .select("id, name, expires_on, is_used")
        .eq("is_used", false)
        .not("expires_on", "is", null),
    ]);

    if (!mealRows?.length || !pantry?.length) return;

    type Row = {
      id: string;
      recipe_id: string | null;
      title: string;
      recipes: { recipe_ingredients: { name: string }[] } | null;
    };

    const rows = mealRows as unknown as Row[];
    const planned = rows
      .filter((row) => row.recipe_id && row.recipes)
      .map((row) => ({
        id: row.recipe_id!,
        title: row.title,
        ingredients: row.recipes!.recipe_ingredients.map((i) => i.name),
      }));

    const plan = suggestDays(planned, pantry);

    await Promise.all(
      plan.map((item) => {
        const row = rows.find((entry) => entry.recipe_id === item.recipeId);
        return row
          ? supabase
              .from("shopping_run_recipes")
              .update({ day_assigned: item.day })
              .eq("id", row.id)
          : Promise.resolve();
      }),
    );
  }

  const kept = drafts.filter((draft) => draft.keep).length;

  return (
    <div className="space-y-4">
      {alreadyStored > 0 && (
        <p className="rounded-xl bg-muted px-4 py-3 text-sm text-muted-foreground">
          {alreadyStored} produit{alreadyStored > 1 ? "s" : ""} de cette livraison
          {alreadyStored > 1 ? " ont" : " a"} déjà été rangé. Enregistrer à nouveau
          créera des doublons.
        </p>
      )}

      <ul className="divide-y rounded-xl border">
        {drafts.map((draft, index) => {
          const days = shelfLifeDays(draft.item.name, draft.item.aisle_category);
          return (
            <li key={draft.item.id} className="flex items-center gap-3 px-3 py-3">
              <button
                type="button"
                onClick={() =>
                  setDrafts((current) =>
                    current.map((row, i) =>
                      i === index ? { ...row, keep: !row.keep } : row,
                    ),
                  )
                }
                aria-pressed={draft.keep}
                aria-label={`Suivre ${draft.item.name}`}
                className={cn(
                  "flex h-9 w-9 shrink-0 items-center justify-center rounded-full border-2",
                  draft.keep
                    ? "border-primary bg-primary text-primary-foreground"
                    : "border-dashed text-muted-foreground",
                )}
              >
                {days <= 3 ? (
                  <Snowflake className="h-4 w-4" />
                ) : (
                  <Refrigerator className="h-4 w-4" />
                )}
              </button>

              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-medium">{draft.item.name}</p>
                <p className="truncate text-xs text-muted-foreground">
                  {AISLE_EMOJI[draft.item.aisle_category]}{" "}
                  {draft.item.amount ?? draft.item.aisle_category}
                  {draft.keep && draft.expiresOn && ` · ${formatExpiry(draft.expiresOn)}`}
                </p>
              </div>

              <Input
                type="date"
                aria-label={`Date de péremption de ${draft.item.name}`}
                value={draft.expiresOn}
                disabled={!draft.keep}
                onChange={(event) =>
                  setDrafts((current) =>
                    current.map((row, i) =>
                      i === index ? { ...row, expiresOn: event.target.value } : row,
                    ),
                  )
                }
                className="h-10 w-[9.5rem] shrink-0 text-sm disabled:opacity-40"
              />
            </li>
          );
        })}
      </ul>

      {error && (
        <p role="alert" className="text-sm text-destructive">
          {error}
        </p>
      )}

      <Button
        size="lg"
        className="w-full"
        onClick={save}
        disabled={pending || kept === 0}
      >
        {pending
          ? "Enregistrement…"
          : `Ranger ${kept} produit${kept > 1 ? "s" : ""} au frigo`}
      </Button>
    </div>
  );
}
