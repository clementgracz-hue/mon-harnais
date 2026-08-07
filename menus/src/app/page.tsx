import Link from "next/link";
import { History, LogOut, ShoppingBasket } from "lucide-react";

import { ExpiryAlerts } from "@/components/expiry-alerts";
import { PageHeader } from "@/components/page-header";
import { RunPlanner, type RunMeal } from "@/components/run-planner";
import { Button } from "@/components/ui/button";
import { urgencyOf } from "@/lib/planning";
import { createClient } from "@/lib/supabase/server";
import type { PantryItem, ShoppingRun } from "@/lib/types/database";
import { displayName } from "@/lib/user";

export const dynamic = "force-dynamic";

type RunRow = ShoppingRun & {
  shopping_run_recipes: Array<
    RunMeal & { recipes: (RunMeal["recipes"] & { recipe_ingredients: { name: string }[] }) | null }
  >;
};

export default async function HomePage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  // La semaine que l'on mange est celle de la dernière commande clôturée —
  // pas le panier en cours de composition dans l'onglet Recettes.
  const { data } = await supabase
    .from("shopping_runs")
    .select(
      "*, shopping_run_recipes(*, recipes(title, rating, prep_time, cook_time, recipe_ingredients(name)))",
    )
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  const run = data as RunRow | null;

  const { data: pantry } = await supabase
    .from("pantry_items")
    .select("*")
    .eq("is_used", false)
    .not("expires_on", "is", null)
    .order("expires_on");

  const fridge = (pantry ?? []) as PantryItem[];
  const meals = run?.shopping_run_recipes ?? [];

  const plannedRecipes = meals
    .filter((meal) => meal.recipe_id && meal.recipes)
    .map((meal) => ({
      id: meal.recipe_id!,
      title: meal.title,
      ingredients: (meal.recipes!.recipe_ingredients ?? []).map((i) => i.name),
    }));

  const urgency = Object.fromEntries(
    urgencyOf(plannedRecipes, fridge).map((entry) => [
      entry.recipeId,
      { expiresOn: entry.expiresOn, because: entry.because },
    ]),
  );

  const orderedOn = run
    ? new Date(run.created_at).toLocaleDateString("fr-FR", {
        day: "numeric",
        month: "long",
      })
    : null;

  return (
    <main className="pb-nav">
      <PageHeader
        title={run ? `Semaine ${run.week_number}` : "Semaine"}
        subtitle={`Nos repas · connecté en ${displayName(user)}`}
        action={
          <div className="flex items-center">
            <Button
              asChild
              variant="ghost"
              size="icon"
              aria-label="Historique des courses"
            >
              <Link href="/courses/historique">
                <History className="h-5 w-5 text-muted-foreground" />
              </Link>
            </Button>
            <form action="/auth/signout" method="post">
              <Button
                type="submit"
                variant="ghost"
                size="icon"
                aria-label="Se déconnecter"
              >
                <LogOut className="h-5 w-5 text-muted-foreground" />
              </Button>
            </form>
          </div>
        }
      />

      {!run ? (
        <div className="p-8 text-center">
          <ShoppingBasket
            className="mx-auto mb-3 h-8 w-8 text-muted-foreground"
            aria-hidden
          />
          <p className="text-sm text-muted-foreground">
            Aucune commande passée. Choisis tes recettes dans l&apos;onglet
            Recettes, puis clôture tes courses&nbsp;: les repas s&apos;afficheront
            ici.
          </p>
          <Button asChild className="mt-4">
            <Link href="/recettes">Choisir des recettes</Link>
          </Button>
        </div>
      ) : (
        <div className="space-y-4 p-4">
          {/* La commande dont les repas s'affichent en dessous. */}
          <Link
            href={`/courses/historique/${run.id}`}
            className="flex items-center justify-between gap-3 rounded-xl border bg-card px-4 py-3"
          >
            <span className="min-w-0">
              <span className="block font-semibold">
                Commande du {orderedOn}
              </span>
              <span className="block text-xs text-muted-foreground">
                Semaine {run.week_number} · {run.item_count} articles ·{" "}
                {meals.length} repas
                {run.closed_by && ` · ${run.closed_by}`}
              </span>
            </span>
            <span className="shrink-0 text-sm font-medium text-primary">
              Voir →
            </span>
          </Link>

          <ExpiryAlerts
            pantry={fridge}
            recipes={plannedRecipes}
            meals={meals.map((meal) => ({
              id: meal.id,
              recipe_id: meal.recipe_id,
            }))}
          />

          <RunPlanner
            meals={meals as RunMeal[]}
            urgency={urgency}
            author={displayName(user)}
          />
        </div>
      )}
    </main>
  );
}
