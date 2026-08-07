"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { AlertTriangle, CalendarClock, Check } from "lucide-react";

import { Button } from "@/components/ui/button";
import { suggestDays, type PantryEntry, type PlannedRecipe } from "@/lib/planning";
import { expiringSoon } from "@/lib/planning";
import { formatExpiry } from "@/lib/shelf-life";
import { createClient } from "@/lib/supabase/client";
import { cn } from "@/lib/utils";

type Props = {
  pantry: PantryEntry[];
  recipes: PlannedRecipe[];
  /** Repas de la commande, pour y écrire le jour suggéré. */
  meals: Array<{ id: string; recipe_id: string | null }>;
};

/**
 * Ce qui périme bientôt, et le bouton qui replace les repas de la semaine
 * dans l'ordre des DLC.
 */
export function ExpiryAlerts({ pantry, recipes, meals }: Props) {
  const router = useRouter();
  const alerts = expiringSoon(pantry, recipes);

  async function applySuggestion() {
    const plan = suggestDays(recipes, pantry);
    const supabase = createClient();

    await Promise.all(
      plan.map((item) => {
        const meal = meals.find((row) => row.recipe_id === item.recipeId);
        if (!meal) return Promise.resolve();
        return supabase
          .from("shopping_run_recipes")
          .update({ day_assigned: item.day })
          .eq("id", meal.id);
      }),
    );

    router.refresh();
  }

  async function markUsed(id: string) {
    const supabase = createClient();
    await supabase.from("pantry_items").update({ is_used: true }).eq("id", id);
    router.refresh();
  }

  if (pantry.length === 0) return null;

  return (
    <div className="space-y-3">
      {alerts.length > 0 && (
        <section className="space-y-2 rounded-xl border border-amber-300 bg-amber-50 p-3 dark:border-amber-900 dark:bg-amber-950/40">
          <h2 className="flex items-center gap-1.5 text-sm font-semibold text-amber-900 dark:text-amber-200">
            <AlertTriangle className="h-4 w-4" aria-hidden />À consommer vite
          </h2>
          <ul className="space-y-1.5">
            {alerts.map((alert) => (
              <li
                key={alert.item.id}
                className="flex items-center gap-2 text-sm text-amber-900 dark:text-amber-200"
              >
                <span className="min-w-0 flex-1">
                  <span className="font-medium">{alert.item.name}</span>{" "}
                  <span
                    className={cn(
                      "text-xs",
                      alert.days < 0 ? "font-semibold" : "opacity-80",
                    )}
                  >
                    — {formatExpiry(alert.item.expires_on!)}
                  </span>
                  {alert.unplanned && (
                    <span className="block text-xs opacity-80">
                      aucun repas prévu ne l&apos;utilise
                    </span>
                  )}
                </span>
                <button
                  type="button"
                  onClick={() => markUsed(alert.item.id)}
                  aria-label={`Marquer ${alert.item.name} comme consommé`}
                  className="shrink-0 rounded-full border border-amber-300 p-1.5 dark:border-amber-800"
                >
                  <Check className="h-4 w-4" />
                </button>
              </li>
            ))}
          </ul>
        </section>
      )}

      {recipes.length > 1 && (
        <Button variant="outline" className="w-full" onClick={applySuggestion}>
          <CalendarClock className="h-4 w-4" aria-hidden />
          Réordonner selon les DLC
        </Button>
      )}

      <p className="text-center text-xs text-muted-foreground">
        <Link href="/courses/historique" className="underline">
          Ranger une livraison au frigo
        </Link>
      </p>
    </div>
  );
}
