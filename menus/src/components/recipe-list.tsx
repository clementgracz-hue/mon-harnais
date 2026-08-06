"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useMemo, useState } from "react";
import { Check, Loader2, Plus, Search } from "lucide-react";

import { RecipeCard, type RecipeCardData } from "@/components/recipe-card";
import { Input } from "@/components/ui/input";
import { getOrCreateMenu } from "@/lib/menu";
import { createClient } from "@/lib/supabase/client";
import { cn, getIsoWeek } from "@/lib/utils";

type Props = {
  recipes: RecipeCardData[];
  /** Recettes déjà au menu de la semaine en cours. */
  selectedIds: string[];
};

export function RecipeList({ recipes, selectedIds }: Props) {
  const router = useRouter();
  const [query, setQuery] = useState("");
  const [activeTag, setActiveTag] = useState<string | null>(null);
  const [selected, setSelected] = useState(() => new Set(selectedIds));
  const [pending, setPending] = useState<string | null>(null);

  const tags = useMemo(
    () => [...new Set(recipes.flatMap((recipe) => recipe.tags))].sort(),
    [recipes],
  );

  const visible = useMemo(() => {
    const needle = query.trim().toLowerCase();
    return recipes.filter((recipe) => {
      const matchesQuery = !needle || recipe.title.toLowerCase().includes(needle);
      const matchesTag = !activeTag || recipe.tags.includes(activeTag);
      return matchesQuery && matchesTag;
    });
  }, [recipes, query, activeTag]);

  /** Ajoute ou retire la recette du menu de la semaine, en un geste. */
  async function toggleWeek(recipe: RecipeCardData) {
    if (pending) return;
    setPending(recipe.id);

    const isSelected = selected.has(recipe.id);
    setSelected((current) => {
      const next = new Set(current);
      if (isSelected) next.delete(recipe.id);
      else next.add(recipe.id);
      return next;
    });

    try {
      const supabase = createClient();
      const { week, year } = getIsoWeek();
      const menu = await getOrCreateMenu(supabase, week, year);

      if (isSelected) {
        await supabase
          .from("weekly_menu_recipes")
          .delete()
          .eq("menu_id", menu.id)
          .eq("recipe_id", recipe.id);
      } else {
        await supabase.from("weekly_menu_recipes").insert({
          menu_id: menu.id,
          recipe_id: recipe.id,
          is_kid_friendly_veg: recipe.veg ?? false,
        });
      }
      router.refresh();
    } catch {
      // Échec réseau : on rend l'état d'origine plutôt que de mentir.
      setSelected((current) => {
        const next = new Set(current);
        if (isSelected) next.add(recipe.id);
        else next.delete(recipe.id);
        return next;
      });
    } finally {
      setPending(null);
    }
  }

  return (
    <div className="space-y-4 p-4">
      <div className="relative">
        <Search
          className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground"
          aria-hidden
        />
        <Input
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          placeholder="Chercher une recette"
          aria-label="Chercher une recette"
          className="pl-9"
        />
      </div>

      {tags.length > 0 && (
        <div className="-mx-4 flex gap-2 overflow-x-auto px-4 pb-1">
          {tags.map((tag) => {
            const active = activeTag === tag;
            return (
              <button
                key={tag}
                type="button"
                onClick={() => setActiveTag(active ? null : tag)}
                className={
                  active
                    ? "shrink-0 rounded-full bg-primary px-3 py-1.5 text-xs font-medium text-primary-foreground"
                    : "shrink-0 rounded-full border px-3 py-1.5 text-xs font-medium text-muted-foreground"
                }
              >
                {tag}
              </button>
            );
          })}
        </div>
      )}

      {selected.size > 0 && (
        <Link
          href="/"
          className="flex items-center justify-between rounded-xl border bg-card px-4 py-3 text-sm"
        >
          <span>
            <strong>{selected.size}</strong> repas au menu cette semaine
          </span>
          <span className="font-medium text-primary">Voir la semaine →</span>
        </Link>
      )}

      {visible.length === 0 ? (
        <p className="py-12 text-center text-sm text-muted-foreground">
          {recipes.length === 0
            ? "Aucune recette pour l'instant. Ajoute la première !"
            : "Aucune recette ne correspond."}
        </p>
      ) : (
        <ul className="space-y-3">
          {visible.map((recipe) => {
            const isSelected = selected.has(recipe.id);
            const isPending = pending === recipe.id;

            return (
              <li key={recipe.id}>
                <RecipeCard
                  recipe={recipe}
                  action={
                    <button
                      type="button"
                      onClick={(event) => {
                        event.preventDefault();
                        void toggleWeek(recipe);
                      }}
                      disabled={isPending}
                      aria-pressed={isSelected}
                      aria-label={
                        isSelected
                          ? `Retirer ${recipe.title} de la semaine`
                          : `Ajouter ${recipe.title} à la semaine`
                      }
                      className={cn(
                        "flex h-12 w-12 items-center justify-center rounded-full border-2 transition-colors active:scale-95",
                        isSelected
                          ? "border-primary bg-primary text-primary-foreground"
                          : "border-dashed border-input bg-background text-muted-foreground",
                      )}
                    >
                      {isPending ? (
                        <Loader2 className="h-5 w-5 animate-spin" aria-hidden />
                      ) : isSelected ? (
                        <Check className="h-6 w-6" strokeWidth={3} aria-hidden />
                      ) : (
                        <Plus className="h-6 w-6" strokeWidth={3} aria-hidden />
                      )}
                    </button>
                  }
                />
              </li>
            );
          })}
        </ul>
      )}
    </div>
  );
}
