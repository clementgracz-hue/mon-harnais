import type { Metadata } from "next";

import { PageHeader } from "@/components/page-header";
import type { RecipeCardData } from "@/components/recipe-card";
import { RecipeList } from "@/components/recipe-list";
import { createClient } from "@/lib/supabase/server";
import type { Recipe, RecipeIngredient } from "@/lib/types/database";
import { deriveVeg } from "@/lib/veg";

export const metadata: Metadata = { title: "Recettes" };
export const dynamic = "force-dynamic";

type Row = Recipe & {
  recipe_ingredients: Pick<RecipeIngredient, "name" | "aisle_category">[];
};

export default async function RecipesPage() {
  const supabase = await createClient();
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

  return (
    <main className="pb-nav">
      <PageHeader
        title="Recettes"
        subtitle={count > 0 ? `${count} recette${count > 1 ? "s" : ""}` : undefined}
      />
      <RecipeList recipes={recipes} />
    </main>
  );
}
