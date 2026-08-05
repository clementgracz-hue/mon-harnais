import type { Aisle, RecipeIngredient } from "@/lib/types/database";

/** Rayons dont tout produit exclut un repas « 100% végétal ». */
const ANIMAL_AISLES: Aisle[] = [
  "Boucherie & Volaille",
  "Poissonnerie",
  "Traiteur & Charcuterie",
  "Crémerie",
];

/**
 * Produits d'origine animale rangés ailleurs (thon en conserve, miel en
 * épicerie sucrée, gélatine…) ou alternatives végétales rangées en crémerie.
 */
const ANIMAL_WORDS = [
  "thon", "anchois", "sardine", "saumon", "crevette", "jambon", "lardon",
  "chorizo", "bacon", "gelatine", "miel", "bouillon de volaille",
  "bouillon de boeuf", "sauce nuoc", "worcestershire", "parmesan", "beurre",
  "creme", "lait", "fromage", "oeuf", "yaourt", "mozzarella", "feta", "ricotta",
];

const PLANT_WORDS = [
  "vegetal", "vegan", "soja", "avoine", "amande", "coco", "riz", "epeautre",
];

function fold(value: string) {
  return value
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "");
}

export type VegVerdict = {
  isVeg: boolean;
  /** Ingrédients qui empêchent le classement « 100% végétal ». */
  blockers: string[];
};

/**
 * Déduit si une recette est 100% végétale à partir du rayon et du nom de ses
 * ingrédients. C'est une suggestion : le drapeau reste modifiable à la main sur
 * chaque repas de la semaine.
 */
export function deriveVeg(
  ingredients: Pick<RecipeIngredient, "name" | "aisle_category">[],
): VegVerdict {
  const blockers = ingredients
    .filter((ingredient) => {
      const name = fold(ingredient.name);
      // « Lait de coco », « crème de soja »… restent végétaux.
      if (PLANT_WORDS.some((word) => name.includes(word))) return false;
      if (ANIMAL_AISLES.includes(ingredient.aisle_category)) return true;
      return ANIMAL_WORDS.some((word) => name.includes(word));
    })
    .map((ingredient) => ingredient.name);

  return { isVeg: blockers.length === 0, blockers };
}
