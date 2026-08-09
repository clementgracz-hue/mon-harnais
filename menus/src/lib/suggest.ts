import { pantryUsedBy, type PantryEntry, type PlannedRecipe } from "@/lib/planning";
import { daysUntil } from "@/lib/shelf-life";

/**
 * Choisir quoi cuisiner à partir de ce qui reste au frigo. Deux critères,
 * dans cet ordre : ce qui périme bientôt d'abord, puis les recettes qui
 * utilisent le plus de ce qu'on a déjà — celles qui demandent le moins de
 * courses.
 */

export type Suggestion = {
  recipe: PlannedRecipe;
  /** Produits du frigo que la recette consomme. */
  uses: string[];
  /** Ingrédients qu'il faudra acheter. */
  missing: string[];
  /** Jours avant la DLC la plus proche parmi les produits utilisés. */
  urgencyDays: number | null;
  score: number;
};

/** Ce qui presse vaut plus qu'un ingrédient de plus en commun. */
function urgencyBonus(days: number | null) {
  if (days === null) return 0;
  if (days <= 0) return 60; // dépassé ou aujourd'hui
  if (days <= 2) return 40;
  if (days <= 4) return 20;
  if (days <= 7) return 8;
  return 0;
}

export function suggestFromPantry(
  recipes: PlannedRecipe[],
  pantry: PantryEntry[],
  from = new Date(),
): Suggestion[] {
  const available = pantry.filter((item) => !item.is_used);

  return recipes
    .map((recipe) => {
      const used = pantryUsedBy(recipe.ingredients, available);

      // Un ingrédient est « couvert » dès qu'un produit du frigo le satisfait.
      const missing = recipe.ingredients.filter(
        (ingredient) => pantryUsedBy([ingredient], used).length === 0,
      );

      const urgencyDays = used.reduce<number | null>((soonest, item) => {
        if (!item.expires_on) return soonest;
        const days = daysUntil(item.expires_on, from);
        return soonest === null || days < soonest ? days : soonest;
      }, null);

      const total = recipe.ingredients.length || 1;
      const coverage = used.length / total;

      return {
        recipe,
        uses: used.map((item) => item.name),
        missing,
        urgencyDays,
        score:
          used.length * 10 + Math.round(coverage * 20) + urgencyBonus(urgencyDays),
      };
    })
    .filter((suggestion) => suggestion.uses.length > 0)
    .sort(
      (a, b) =>
        b.score - a.score ||
        a.missing.length - b.missing.length ||
        a.recipe.title.localeCompare(b.recipe.title, "fr"),
    );
}

/**
 * Recettes qui collent à une liste d'ingrédients nommés — ce qu'on a vu sur
 * une photo du frigo, par exemple. Même classement, sans les dates.
 */
export function suggestFromNames(
  recipes: PlannedRecipe[],
  names: string[],
  from = new Date(),
): Suggestion[] {
  const pantry: PantryEntry[] = names.map((name, index) => ({
    id: `photo-${index}`,
    name,
    expires_on: null,
    is_used: false,
  }));

  return suggestFromPantry(recipes, pantry, from);
}
