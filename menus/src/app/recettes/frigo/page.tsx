import type { Metadata } from "next";
import Link from "next/link";
import { Refrigerator } from "lucide-react";

import { FridgeSuggestions, type SuggestionCard } from "@/components/fridge-suggestions";
import { PageHeader } from "@/components/page-header";
import { PhotoSuggest } from "@/components/photo-suggest";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/server";
import { suggestFromPantry } from "@/lib/suggest";
import type { PantryItem, Recipe, RecipeIngredient } from "@/lib/types/database";
import { getIsoWeek } from "@/lib/utils";
import { deriveVeg } from "@/lib/veg";

export const metadata: Metadata = { title: "Cuisiner le frigo" };
export const dynamic = "force-dynamic";

type Row = Recipe & {
  recipe_ingredients: Pick<RecipeIngredient, "name" | "aisle_category">[];
};

export default async function FridgePage() {
  const supabase = await createClient();
  const { week, year } = getIsoWeek();

  const [{ data: pantry }, { data: recipeRows }, { data: menu }] = await Promise.all([
    supabase.from("pantry_items").select("*").eq("is_used", false).order("expires_on"),
    supabase.from("recipes").select("*, recipe_ingredients(name, aisle_category)"),
    supabase
      .from("weekly_menu")
      .select("id")
      .eq("week_number", week)
      .eq("year", year)
      .maybeSingle(),
  ]);

  const { data: entries } = menu
    ? await supabase.from("weekly_menu_recipes").select("recipe_id").eq("menu_id", menu.id)
    : { data: [] };

  const fridge = (pantry ?? []) as PantryItem[];
  const rows = (recipeRows ?? []) as Row[];

  const suggestions = suggestFromPantry(
    rows.map((recipe) => ({
      id: recipe.id,
      title: recipe.title,
      ingredients: recipe.recipe_ingredients.map((item) => item.name),
    })),
    fridge,
  ).slice(0, 12);

  const byId = new Map(rows.map((row) => [row.id, row]));

  const cards: SuggestionCard[] = suggestions.flatMap((suggestion) => {
    const row = byId.get(suggestion.recipe.id);
    if (!row) return [];
    const { recipe_ingredients, ...recipe } = row;
    return [
      {
        ...suggestion,
        card: {
          ...recipe,
          veg: recipe_ingredients.length > 0 && deriveVeg(recipe_ingredients).isVeg,
        },
      },
    ];
  });

  return (
    <main className="pb-nav">
      <PageHeader
        title="Cuisiner le frigo"
        subtitle={
          fridge.length > 0
            ? `${fridge.length} produit${fridge.length > 1 ? "s" : ""} rangé${fridge.length > 1 ? "s" : ""}`
            : "Frigo vide"
        }
        backHref="/recettes"
      />

      <div className="space-y-4 p-4">
        <PhotoSuggest
          // La clé reste côté serveur : sans elle, le bloc photo n'apparaît pas.
          enabled={Boolean(process.env.ANTHROPIC_API_KEY)}
          recipes={rows.map((recipe) => ({
            id: recipe.id,
            title: recipe.title,
            ingredients: recipe.recipe_ingredients.map((item) => item.name),
          }))}
          selectedIds={(entries ?? []).map((entry) => entry.recipe_id)}
          cards={rows.map(({ recipe_ingredients, ...recipe }) => ({
            ...recipe,
            veg: recipe_ingredients.length > 0 && deriveVeg(recipe_ingredients).isVeg,
          }))}
        />

        {fridge.length === 0 ? (
          <div className="py-8 text-center">
            <Refrigerator
              className="mx-auto mb-3 h-8 w-8 text-muted-foreground"
              aria-hidden
            />
            <p className="text-sm text-muted-foreground">
              Rien au frigo pour l&apos;instant. Range une livraison depuis
              l&apos;historique des courses, ou photographie ton frigo ci-dessus.
            </p>
            <Button asChild variant="outline" className="mt-4">
              <Link href="/courses/historique">Ranger une livraison</Link>
            </Button>
          </div>
        ) : (
          <FridgeSuggestions
            suggestions={cards}
            selectedIds={(entries ?? []).map((entry) => entry.recipe_id)}
            empty="Aucune recette ne reprend ce qu'il y a au frigo. Essaie la photo ci-dessus."
          />
        )}
      </div>
    </main>
  );
}
