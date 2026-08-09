import { normalizeName } from "@/lib/shopping";
import { slotsFrom } from "@/lib/schedule";
import { daysUntil } from "@/lib/shelf-life";
import type { Day } from "@/lib/types/database";

export type PantryEntry = {
  id: string;
  name: string;
  expires_on: string | null;
  is_used: boolean;
};

export type PlannedRecipe = {
  id: string;
  title: string;
  ingredients: string[];
};

export type RecipeUrgency = {
  recipeId: string;
  title: string;
  /** DLC la plus proche parmi les ingrédients présents au frigo. */
  expiresOn: string | null;
  /** Produit du frigo qui impose cette date. */
  because: string | null;
};

/** Mots significatifs d'un libellé, au singulier, parenthèses ouvertes. */
function keywords(value: string) {
  return normalizeName(value)
    .replace(/[()[\]]/g, " ")
    .split(/[\s,'’-]+/)
    .map((word) => word.replace(/s$/, ""))
    .filter((word) => word.length > 2);
}

/**
 * Un ingrédient est présent au frigo si tous les mots du libellé le plus
 * court se retrouvent dans l'autre : « Pavé de saumon » reconnaît « Pavés de
 * saumon frais », et « Courgette » reconnaît « Courgettes ». L'égalité est
 * exigée mot à mot — comparer des sous-chaînes ferait passer « Pâtes » pour
 * de la « Patate douce ».
 */
function matches(ingredient: string, pantryName: string) {
  const a = keywords(ingredient);
  const b = keywords(pantryName);
  if (a.length === 0 || b.length === 0) return false;

  const [short, long] = a.length <= b.length ? [a, b] : [b, a];
  return short.every((word) => long.includes(word));
}

/**
 * Les produits du frigo qu'une recette consomme. Sert à les solder quand le
 * repas est validé : ce qui a été cuisiné n'est plus au frigo.
 */
export function pantryUsedBy(
  ingredients: string[],
  pantry: PantryEntry[],
): PantryEntry[] {
  return pantry.filter(
    (item) =>
      !item.is_used &&
      ingredients.some((ingredient) => matches(ingredient, item.name)),
  );
}

/** Pour chaque recette, la DLC la plus proche parmi ses ingrédients. */
export function urgencyOf(
  recipes: PlannedRecipe[],
  pantry: PantryEntry[],
): RecipeUrgency[] {
  const available = pantry.filter((item) => !item.is_used && item.expires_on);

  return recipes.map((recipe) => {
    let expiresOn: string | null = null;
    let because: string | null = null;

    for (const ingredient of recipe.ingredients) {
      for (const item of available) {
        if (!matches(ingredient, item.name)) continue;
        if (expiresOn === null || item.expires_on! < expiresOn) {
          expiresOn = item.expires_on;
          because = item.name;
        }
      }
    }

    return { recipeId: recipe.id, title: recipe.title, expiresOn, because };
  });
}

/**
 * Ordonne les repas par urgence et leur attribue un créneau, à partir
 * d'aujourd'hui. Une recette sans produit périssable identifié passe en
 * dernier — rien ne presse. Au-delà des créneaux restants (un par jour, deux
 * le week-end), le repas revient « à placer » plutôt que d'écraser un autre.
 */
export function suggestDays(
  recipes: PlannedRecipe[],
  pantry: PantryEntry[],
  from = new Date(),
): Array<RecipeUrgency & { day: Day | null }> {
  const ranked = [...urgencyOf(recipes, pantry)].sort((a, b) => {
    if (a.expiresOn && b.expiresOn) return a.expiresOn.localeCompare(b.expiresOn);
    if (a.expiresOn) return -1;
    if (b.expiresOn) return 1;
    return a.title.localeCompare(b.title, "fr");
  });

  const slots = slotsFrom(from);

  return ranked.map((recipe, position) => ({
    ...recipe,
    day: slots[position] ?? null,
  }));
}

export type ExpiryAlert = {
  item: PantryEntry;
  days: number;
  /** true si aucun repas de la semaine n'utilise ce produit. */
  unplanned: boolean;
};

/** Produits à consommer sous `within` jours, les plus urgents d'abord. */
export function expiringSoon(
  pantry: PantryEntry[],
  recipes: PlannedRecipe[],
  within = 3,
  from = new Date(),
): ExpiryAlert[] {
  return pantry
    .filter((item) => !item.is_used && item.expires_on)
    .map((item) => ({
      item,
      days: daysUntil(item.expires_on!, from),
      unplanned: !recipes.some((recipe) =>
        recipe.ingredients.some((ingredient) => matches(ingredient, item.name)),
      ),
    }))
    .filter((alert) => alert.days <= within)
    .sort((a, b) => a.days - b.days);
}
