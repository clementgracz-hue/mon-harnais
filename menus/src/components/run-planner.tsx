"use client";

import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useMemo, useState } from "react";
import { Beef, CalendarClock, Leaf, UtensilsCrossed } from "lucide-react";

import { StarRating } from "@/components/star-rating";
import { DAY_CAPACITY, hasRoom, placeMeals } from "@/lib/schedule";
import { formatExpiry } from "@/lib/shelf-life";
import { createClient } from "@/lib/supabase/client";
import { DAYS, type Day, type ShoppingRunRecipe } from "@/lib/types/database";
import { cn, formatDuration } from "@/lib/utils";

export type RunMeal = ShoppingRunRecipe & {
  recipes: {
    title: string;
    image_url: string | null;
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
 * Le planning de la commande en cours de consommation : un repas par jour,
 * deux le week-end. Le jour et le drapeau végétal sont portés par la commande,
 * pas par la recette — la même recette peut revenir un autre jour la semaine
 * suivante.
 */
export function RunPlanner({ meals, urgency, author }: Props) {
  const router = useRouter();
  const [rows, setRows] = useState(meals);

  const { byDay, unplaced } = useMemo(() => placeMeals(rows), [rows]);

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

  function card(meal: RunMeal) {
    return (
      <MealCard
        key={meal.id}
        meal={meal}
        meals={rows}
        urgency={meal.recipe_id ? urgency[meal.recipe_id] : undefined}
        onDay={(day) => setDay(meal, day)}
        onVeg={() => toggleVeg(meal)}
        onRate={(rating) => rate(meal, rating)}
      />
    );
  }

  return (
    <div className="space-y-5">
      {DAYS.map((day) => {
        const placed = byDay.get(day) ?? [];
        const free = DAY_CAPACITY[day] - placed.length;

        return (
          <section key={day} className="space-y-2">
            <h2 className="flex items-baseline justify-between px-0.5">
              <span className="font-semibold capitalize">{day}</span>
              <span className="text-xs text-muted-foreground">
                {placed.length}/{DAY_CAPACITY[day]} repas
              </span>
            </h2>

            {placed.map(card)}

            {Array.from({ length: free }, (_, index) => (
              <p
                key={index}
                className="rounded-xl border border-dashed px-3 py-4 text-center text-sm text-muted-foreground"
              >
                Libre
              </p>
            ))}
          </section>
        );
      })}

      {unplaced.length > 0 && (
        <section className="space-y-2">
          <h2 className="flex items-baseline justify-between px-0.5">
            <span className="font-semibold">À placer</span>
            <span className="text-xs text-muted-foreground">
              {unplaced.length} repas
            </span>
          </h2>
          {unplaced.map(card)}
        </section>
      )}
    </div>
  );
}

function MealCard({
  meal,
  meals,
  urgency,
  onDay,
  onVeg,
  onRate,
}: {
  meal: RunMeal;
  meals: RunMeal[];
  urgency?: { expiresOn: string | null; because: string | null };
  onDay: (day: Day | null) => void;
  onVeg: () => void;
  onRate: (rating: number) => void;
}) {
  const duration = meal.recipes
    ? formatDuration((meal.recipes.prep_time ?? 0) + (meal.recipes.cook_time ?? 0))
    : null;

  return (
    <article className="overflow-hidden rounded-xl border bg-card">
      <div className="flex gap-3 p-3">
        <Thumbnail
          src={meal.recipes?.image_url ?? null}
          href={meal.recipe_id ? `/recettes/${meal.recipe_id}` : null}
        />

        <div className="min-w-0 flex-1">
          {meal.recipe_id ? (
            <Link
              href={`/recettes/${meal.recipe_id}`}
              className="line-clamp-2 font-semibold leading-snug"
            >
              {meal.title}
            </Link>
          ) : (
            <span className="line-clamp-2 font-semibold leading-snug text-muted-foreground">
              {meal.title}
            </span>
          )}

          {meal.recipes && (
            <p className="mt-0.5 text-xs text-muted-foreground">
              {duration ?? "Durée non renseignée"}
            </p>
          )}

          {urgency?.expiresOn && (
            <p className="mt-1 flex items-center gap-1 text-xs font-medium text-amber-700 dark:text-amber-400">
              <CalendarClock className="h-3.5 w-3.5 shrink-0" aria-hidden />
              <span className="truncate">
                {urgency.because} — {formatExpiry(urgency.expiresOn)}
              </span>
            </p>
          )}

          {meal.recipe_id && (
            <StarRating
              value={meal.recipes?.rating ?? 0}
              onChange={onRate}
              size="sm"
              className="mt-1.5"
            />
          )}
        </div>
      </div>

      <div className="flex gap-1 overflow-x-auto px-3">
        {DAYS.map((day) => {
          const active = meal.day_assigned === day;
          const full = !active && !hasRoom(meals, day, meal.id);

          return (
            <button
              key={day}
              type="button"
              disabled={full}
              onClick={() => onDay(active ? null : day)}
              aria-label={`${meal.title} — ${day}${full ? " (complet)" : ""}`}
              className={cn(
                "shrink-0 rounded-lg px-2.5 py-1.5 text-xs font-medium capitalize",
                active && "bg-primary text-primary-foreground",
                !active && !full && "border text-muted-foreground",
                full && "border border-dashed text-muted-foreground/40",
              )}
            >
              {day.slice(0, 3)}
            </button>
          );
        })}
      </div>

      <button
        type="button"
        onClick={onVeg}
        aria-pressed={meal.is_kid_friendly_veg}
        className={cn(
          "mt-3 flex w-full items-center gap-2 px-3 py-2 text-sm font-medium transition-colors",
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
    </article>
  );
}

function Thumbnail({ src, href }: { src: string | null; href: string | null }) {
  const image = (
    <div className="relative h-20 w-20 shrink-0 overflow-hidden rounded-lg bg-muted">
      {src ? (
        <Image src={src} alt="" fill sizes="80px" className="object-cover" />
      ) : (
        <div className="flex h-full items-center justify-center text-muted-foreground">
          <UtensilsCrossed className="h-6 w-6" aria-hidden />
        </div>
      )}
    </div>
  );

  return href ? <Link href={href}>{image}</Link> : image;
}
