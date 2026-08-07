"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { Beef, CalendarClock, Leaf } from "lucide-react";

import { StarRating } from "@/components/star-rating";
import { formatExpiry } from "@/lib/shelf-life";
import { createClient } from "@/lib/supabase/client";
import { DAYS, type Day, type ShoppingRunRecipe } from "@/lib/types/database";
import { cn, formatDuration } from "@/lib/utils";

export type RunMeal = ShoppingRunRecipe & {
  recipes: {
    title: string;
    rating: number | null;
    prep_time: number | null;
    cook_time: number | null;
  } | null;
};

type Props = {
  meals: RunMeal[];
  /** DLC la plus proche par recette, et le produit qui l'impose. */
  urgency: Record<string, { expiresOn: string | null; because: string | null }>;
  author: string;
};

/**
 * Les repas de la commande en cours de consommation. Le jour et le drapeau
 * végétal sont portés par la commande, pas par la recette : la même recette
 * peut revenir un autre jour la semaine suivante.
 */
export function RunPlanner({ meals, urgency, author }: Props) {
  const router = useRouter();
  const [rows, setRows] = useState(meals);

  async function setDay(meal: RunMeal, day: Day | null) {
    setRows((current) =>
      current.map((row) => (row.id === meal.id ? { ...row, day_assigned: day } : row)),
    );
    const supabase = createClient();
    await supabase
      .from("shopping_run_recipes")
      .update({ day_assigned: day })
      .eq("id", meal.id);
    router.refresh();
  }

  async function toggleVeg(meal: RunMeal) {
    const next = !meal.is_kid_friendly_veg;
    setRows((current) =>
      current.map((row) =>
        row.id === meal.id ? { ...row, is_kid_friendly_veg: next } : row,
      ),
    );
    const supabase = createClient();
    await supabase
      .from("shopping_run_recipes")
      .update({ is_kid_friendly_veg: next })
      .eq("id", meal.id);
    router.refresh();
  }

  /** Une note vaut un avis : la moyenne de la recette est recalculée en base. */
  async function rate(meal: RunMeal, rating: number) {
    if (!meal.recipe_id) return;
    setRows((current) =>
      current.map((row) =>
        row.id === meal.id && row.recipes
          ? { ...row, recipes: { ...row.recipes, rating } }
          : row,
      ),
    );
    const supabase = createClient();
    await supabase
      .from("recipe_comments")
      .insert({ recipe_id: meal.recipe_id, author, rating });
    router.refresh();
  }

  return (
    <ul className="space-y-3">
      {rows.map((meal) => (
        <li key={meal.id} className="rounded-xl border bg-card p-3">
          <div className="min-w-0">
            {meal.recipe_id ? (
              <Link
                href={`/recettes/${meal.recipe_id}`}
                className="font-semibold leading-snug"
              >
                {meal.title}
              </Link>
            ) : (
              <span className="font-semibold leading-snug text-muted-foreground">
                {meal.title}
              </span>
            )}

            {meal.recipes && (
              <p className="mt-0.5 text-xs text-muted-foreground">
                {formatDuration(
                  (meal.recipes.prep_time ?? 0) + (meal.recipes.cook_time ?? 0),
                ) ?? "Durée non renseignée"}
              </p>
            )}

            {meal.recipe_id && urgency[meal.recipe_id]?.expiresOn && (
              <p className="mt-1 flex items-center gap-1 text-xs font-medium text-amber-700 dark:text-amber-400">
                <CalendarClock className="h-3.5 w-3.5 shrink-0" aria-hidden />
                <span className="truncate">
                  {urgency[meal.recipe_id].because} —{" "}
                  {formatExpiry(urgency[meal.recipe_id].expiresOn!)}
                </span>
              </p>
            )}

            {meal.recipe_id && (
              <StarRating
                value={meal.recipes?.rating ?? 0}
                onChange={(rating) => rate(meal, rating)}
                size="sm"
                className="mt-1.5"
              />
            )}
          </div>

          <div className="mt-3 flex gap-1 overflow-x-auto">
            {DAYS.map((day) => {
              const active = meal.day_assigned === day;
              return (
                <button
                  key={day}
                  type="button"
                  onClick={() => setDay(meal, active ? null : day)}
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
            onClick={() => toggleVeg(meal)}
            aria-pressed={meal.is_kid_friendly_veg}
            className={cn(
              "mt-3 flex w-full items-center gap-2 rounded-lg px-3 py-2 text-sm font-medium transition-colors",
              meal.is_kid_friendly_veg
                ? "bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300"
                : "bg-rose-100 text-rose-800 dark:bg-rose-950 dark:text-rose-300",
            )}
          >
            {meal.is_kid_friendly_veg ? (
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
  );
}
