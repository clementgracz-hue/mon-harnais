import Link from "next/link";
import { History, LogOut } from "lucide-react";

import { ExpiryAlerts } from "@/components/expiry-alerts";
import { PageHeader } from "@/components/page-header";
import { WeekPlanner, type MenuEntry } from "@/components/week-planner";
import { Button } from "@/components/ui/button";
import { urgencyOf } from "@/lib/planning";
import { createClient } from "@/lib/supabase/server";
import type { PantryItem, RecipeIngredient } from "@/lib/types/database";
import { displayName } from "@/lib/user";
import { getIsoWeek } from "@/lib/utils";

export const dynamic = "force-dynamic";

type EntryRow = MenuEntry & {
  recipes:
    | (MenuEntry["recipes"] & {
        recipe_ingredients: Pick<RecipeIngredient, "name">[];
      })
    | null;
};

export default async function HomePage() {
  const supabase = await createClient();
  const { week, year } = getIsoWeek();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: menu } = await supabase
    .from("weekly_menu")
    .select("*")
    .eq("week_number", week)
    .eq("year", year)
    .maybeSingle();

  const [{ data: entries }, { data: pantry }] = await Promise.all([
    menu
      ? supabase
          .from("weekly_menu_recipes")
          .select("*, recipes(*, recipe_ingredients(name))")
          .eq("menu_id", menu.id)
          .order("created_at")
      : Promise.resolve({ data: [] as EntryRow[] }),
    supabase
      .from("pantry_items")
      .select("*")
      .eq("is_used", false)
      .not("expires_on", "is", null)
      .order("expires_on"),
  ]);

  const rows = (entries ?? []) as unknown as EntryRow[];
  const fridge = (pantry ?? []) as PantryItem[];

  // Ce que le frigo impose : chaque repas avec la liste de ses ingrédients.
  const plannedRecipes = rows
    .filter((row) => row.recipes)
    .map((row) => ({
      id: row.recipe_id,
      title: row.recipes!.title,
      ingredients: (row.recipes!.recipe_ingredients ?? []).map((i) => i.name),
    }));

  const urgency = Object.fromEntries(
    urgencyOf(plannedRecipes, fridge).map((entry) => [
      entry.recipeId,
      { expiresOn: entry.expiresOn, because: entry.because },
    ]),
  );

  return (
    <main className="pb-nav">
      <PageHeader
        title={`Semaine ${week}`}
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

      <div className="space-y-4 p-4 pb-0">
        <ExpiryAlerts
          pantry={fridge}
          recipes={plannedRecipes}
          entries={rows.map((row) => ({ id: row.id, recipe_id: row.recipe_id }))}
        />
      </div>

      <WeekPlanner
        entries={rows as unknown as MenuEntry[]}
        urgency={urgency}
        author={displayName(user)}
      />
    </main>
  );
}
