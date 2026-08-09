import type { Metadata } from "next";
import Link from "next/link";
import { Plus, Refrigerator, ShoppingCart } from "lucide-react";

import { AddRecipeDialog } from "@/components/add-recipe-dialog";
import { PageHeader } from "@/components/page-header";
import type { RecipeCardData } from "@/components/recipe-card";
import { RecipeList } from "@/components/recipe-list";
import { ServingsSetting } from "@/components/servings-setting";
import { Button } from "@/components/ui/button";
import { WEEK_CAPACITY } from "@/lib/schedule";
import { createClient } from "@/lib/supabase/server";
import type { Recipe, RecipeIngredient } from "@/lib/types/database";
import { cn, getIsoWeek } from "@/lib/utils";
import { deriveVeg } from "@/lib/veg";

export const metadata: Metadata = { title: "Recettes" };
export const dynamic = "force-dynamic";

type Row = Recipe & {
  recipe_ingredients: Pick<RecipeIngredient, "name" | "aisle_category">[];
};

export default async function RecipesPage() {
  const supabase = await createClient();
  const { week, year } = getIsoWeek();

  const { data: menu } = await supabase
    .from("weekly_menu")
    .select("id, servings")
    .eq("week_number", week)
    .eq("year", year)
    .maybeSingle();

  // Recettes déjà au menu : le bouton d'ajout doit refléter leur état.
  const { data: entries } = menu
    ? await supabase
        .from("weekly_menu_recipes")
        .select("recipe_id")
        .eq("menu_id", menu.id)
    : { data: [] };

  const { data } = await supabase
    .from("recipes")
    // Les ingrédients servent uniquement à calculer le badge « 100% végétal ».
    .select("*, recipe_ingredients(name, aisle_category)")
    .order("created_at", { ascending: false });

  const recipes: RecipeCardData[] = ((data ?? []) as Row[]).map(
    ({ recipe_ingredients, ...recipe }) => ({
      ...recipe,
      veg:
        recipe_ingredients.length > 0 && deriveVeg(recipe_ingredients).isVeg,
    }),
  );

  const count = recipes.length;
  // La semaine tient 9 repas : un par jour, deux le samedi et le dimanche.
  const selected = (entries ?? []).length;

  return (
    <main className="pb-nav">
      <PageHeader
        title="Recettes"
        subtitle={count > 0 ? `${count} recette${count > 1 ? "s" : ""}` : undefined}
        action={
          <AddRecipeDialog
            trigger={
              <Button size="sm" aria-label="Créer une recette">
                <Plus className="h-4 w-4" aria-hidden />
                Créer
              </Button>
            }
          />
        }
      />
      <div className="space-y-3 px-4 pt-4">
        <ServingsSetting week={week} year={year} servings={menu?.servings ?? 2} />

        <p
          className={cn(
            "text-center text-xs",
            selected > WEEK_CAPACITY
              ? "font-medium text-amber-700 dark:text-amber-400"
              : "text-muted-foreground",
          )}
        >
          {selected} repas au menu sur {WEEK_CAPACITY} créneaux
          {selected > WEEK_CAPACITY &&
            ` — ${selected - WEEK_CAPACITY} resteront à placer`}
        </p>

        <Button asChild size="lg" className="w-full">
          <Link href="/courses">
            <ShoppingCart className="h-5 w-5" aria-hidden />
            Générer la liste de courses
          </Link>
        </Button>

        <Button asChild variant="outline" size="lg" className="w-full">
          <Link href="/recettes/frigo">
            <Refrigerator className="h-5 w-5" aria-hidden />
            Cuisiner le frigo
          </Link>
        </Button>
      </div>

      <RecipeList
        recipes={recipes}
        selectedIds={(entries ?? []).map((entry) => entry.recipe_id)}
      />
    </main>
  );
}
