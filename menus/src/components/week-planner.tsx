"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { Beef, Leaf, Plus, Trash2, UtensilsCrossed } from "lucide-react";

import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/client";
import type { Day, Recipe, WeeklyMenuRecipe } from "@/lib/types/database";
import { DAYS } from "@/lib/types/database";
import { cn, formatDuration } from "@/lib/utils";

export type MenuEntry = WeeklyMenuRecipe & { recipes: Recipe | null };

type Props = {
  entries: MenuEntry[];
  /** 5 à 6 repas visés sur la semaine. */
  target?: number;
};

export function WeekPlanner({ entries, target = 6 }: Props) {
  const router = useRouter();
  const [rows, setRows] = useState(entries);

  async function toggleVeg(entry: MenuEntry) {
    const next = !entry.is_kid_friendly_veg;
    setRows((current) =>
      current.map((row) =>
        row.id === entry.id ? { ...row, is_kid_friendly_veg: next } : row,
      ),
    );
    const supabase = createClient();
    await supabase
      .from("weekly_menu_recipes")
      .update({ is_kid_friendly_veg: next })
      .eq("id", entry.id);
    router.refresh();
  }

  async function setDay(entry: MenuEntry, day: Day | null) {
    setRows((current) =>
      current.map((row) =>
        row.id === entry.id ? { ...row, day_assigned: day } : row,
      ),
    );
    const supabase = createClient();
    await supabase
      .from("weekly_menu_recipes")
      .update({ day_assigned: day })
      .eq("id", entry.id);
    router.refresh();
  }

  async function remove(entry: MenuEntry) {
    setRows((current) => current.filter((row) => row.id !== entry.id));
    const supabase = createClient();
    await supabase.from("weekly_menu_recipes").delete().eq("id", entry.id);
    router.refresh();
  }

  const vegCount = rows.filter((row) => row.is_kid_friendly_veg).length;

  return (
    <div className="space-y-4 p-4">
      <div className="rounded-xl border bg-card p-4">
        <div className="flex items-baseline justify-between">
          <p className="text-sm text-muted-foreground">Repas planifiés</p>
          <p className="text-2xl font-bold">
            {rows.length}
            <span className="text-base font-normal text-muted-foreground">
              /{target}
            </span>
          </p>
        </div>
        <div className="mt-2 flex gap-1">
          {Array.from({ length: Math.max(target, rows.length) }).map((_, index) => (
            <span
              key={index}
              className={cn(
                "h-1.5 flex-1 rounded-full",
                index < rows.length ? "bg-primary" : "bg-muted",
              )}
            />
          ))}
        </div>
        {rows.length > 0 && (
          <p className="mt-3 flex items-center gap-1.5 text-xs text-muted-foreground">
            <Leaf className="h-3.5 w-3.5 text-emerald-600" aria-hidden />
            {vegCount} repas 100% végétal sur {rows.length}
          </p>
        )}
      </div>

      {rows.length === 0 ? (
        <div className="rounded-xl border border-dashed p-8 text-center">
          <UtensilsCrossed
            className="mx-auto mb-3 h-8 w-8 text-muted-foreground"
            aria-hidden
          />
          <p className="text-sm text-muted-foreground">
            Aucun repas prévu cette semaine.
          </p>
          <Button asChild className="mt-4">
            <Link href="/recettes">
              <Plus className="h-4 w-4" />
              Choisir des recettes
            </Link>
          </Button>
        </div>
      ) : (
        <ul className="space-y-3">
          {rows.map((entry) => (
            <li key={entry.id} className="rounded-xl border bg-card p-3">
              <div className="flex items-start gap-3">
                <div className="min-w-0 flex-1">
                  <Link
                    href={`/recettes/${entry.recipe_id}`}
                    className="font-semibold leading-snug"
                  >
                    {entry.recipes?.title ?? "Recette supprimée"}
                  </Link>
                  {entry.recipes && (
                    <p className="mt-0.5 text-xs text-muted-foreground">
                      {formatDuration(
                        (entry.recipes.prep_time ?? 0) +
                          (entry.recipes.cook_time ?? 0),
                      ) ?? "Durée non renseignée"}
                    </p>
                  )}
                </div>
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={() => remove(entry)}
                  aria-label="Retirer du menu"
                >
                  <Trash2 className="h-4 w-4 text-muted-foreground" />
                </Button>
              </div>

              <div className="mt-3 flex gap-1 overflow-x-auto">
                {DAYS.map((day) => {
                  const active = entry.day_assigned === day;
                  return (
                    <button
                      key={day}
                      type="button"
                      onClick={() => setDay(entry, active ? null : day)}
                      className={cn(
                        "shrink-0 rounded-lg px-2.5 py-1.5 text-xs font-medium capitalize",
                        active
                          ? "bg-primary text-primary-foreground"
                          : "border text-muted-foreground",
                      )}
                    >
                      {day.slice(0, 3)}
                    </button>
                  );
                })}
              </div>

              <button
                type="button"
                onClick={() => toggleVeg(entry)}
                aria-pressed={entry.is_kid_friendly_veg}
                className={cn(
                  "mt-3 flex w-full items-center gap-2 rounded-lg px-3 py-2 text-sm font-medium transition-colors",
                  entry.is_kid_friendly_veg
                    ? "bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300"
                    : "bg-rose-100 text-rose-800 dark:bg-rose-950 dark:text-rose-300",
                )}
              >
                {entry.is_kid_friendly_veg ? (
                  <>
                    <Leaf className="h-4 w-4" aria-hidden />
                    100% végétal — ok pour le petit
                  </>
                ) : (
                  <>
                    <Beef className="h-4 w-4" aria-hidden />
                    Contient des protéines animales
                  </>
                )}
              </button>
            </li>
          ))}
        </ul>
      )}

      {rows.length > 0 && (
        <Button asChild variant="outline" className="w-full">
          <Link href="/recettes">
            <Plus className="h-4 w-4" />
            Ajouter une recette
          </Link>
        </Button>
      )}
    </div>
  );
}
