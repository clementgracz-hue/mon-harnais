import Link from "next/link";
import { LogOut, ShoppingCart } from "lucide-react";

import { ExpiryAlerts } from "@/components/expiry-alerts";
import { PageHeader } from "@/components/page-header";
import { WeekPlanner, type MenuEntry } from "@/components/week-planner";
import { WeekSettings } from "@/components/week-settings";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/server";
import type { PantryItem, RecipeIngredient } from "@/lib/types/database";
import { displayName } from "@/lib/user";
import { getIsoWeek } from "@/lib/utils";

export const dynamic = "force-dynamic";

type EntryRow = MenuEntry & {
  recipes: (MenuEntry["recipes"] & {
    recipe_ingredients: Pick<RecipeIngredient, "name">[];
  }) | null;
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

  // Ce que le frigo impose : chaque repas avec la liste de ses ingrédients.
  const plannedRecipes = rows
    .filter((row) => row.recipes)
    .map((row) => ({
      id: row.recipe_id,
      title: row.recipes!.title,
      ingredients: (row.recipes!.recipe_ingredients ?? []).map((i) => i.name),
    }));

  return (
    <main className="pb-nav">
      <PageHeader
        title={`Semaine ${week}`}
        subtitle={`Nos repas · connecté en ${displayName(user)}`}
        action={
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
        }
      />

      <div className="space-y-4 p-4">
        <WeekSettings
          week={week}
          year={year}
          targetRecipes={menu?.target_recipes ?? 6}
          servings={menu?.servings ?? 2}
          planned={rows.length}
        />

        <ExpiryAlerts
          pantry={(pantry ?? []) as PantryItem[]}
          recipes={plannedRecipes}
          entries={rows.map((row) => ({ id: row.id, recipe_id: row.recipe_id }))}
        />
      </div>

      <WeekPlanner entries={rows as unknown as MenuEntry[]} />

      <div className="px-4 pb-4">
        <Button asChild size="lg" className="w-full">
          <Link href="/courses">
            <ShoppingCart className="h-5 w-5" aria-hidden />
            Générer la liste de courses
          </Link>
        </Button>
      </div>
    </main>
  );
}
