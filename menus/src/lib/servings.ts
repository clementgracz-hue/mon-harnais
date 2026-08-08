/** Unités dénombrables : on n'achète pas 1,5 œuf. */
const COUNTABLE = ["pièce", "pièces", "piece", "tranche", "tranches", "gousse", "gousses", "sachet", "sachets", "boîte", "boîtes", "pincée", "pincées", "bouquet"];

/**
 * Met une quantité à l'échelle du nombre de convives.
 *
 * Les quantités d'une recette sont écrites pour `base` parts (2 chez Jow) ;
 * le panier est généré pour `target` convives. Les unités dénombrables sont
 * arrondies au supérieur, les autres au dixième.
 */
export function scaleQuantity(
  quantity: number | null,
  unit: string | null,
  base: number,
  target: number,
): number | null {
  if (quantity == null) return null;
  if (!base || base <= 0 || base === target) return quantity;

  const scaled = (quantity * target) / base;
  const isCountable = COUNTABLE.includes((unit ?? "").trim().toLowerCase());

  return isCountable
    ? Math.max(1, Math.ceil(scaled))
    : Math.round(scaled * 10) / 10;
}

/**
 * Quantité à acheter pour un ingrédient de recette.
 *
 * Un plat entier (quiche, cake, tarte) se fait en entier : ses quantités ne
 * bougent pas, quel que soit le nombre de convives. Sinon, on met à l'échelle.
 */
export function shoppingQuantity(
  quantity: number | null,
  unit: string | null,
  recipe: { servings: number; is_batch: boolean },
  people: number,
): number | null {
  if (recipe.is_batch) return quantity;
  return scaleQuantity(quantity, unit, recipe.servings, people);
}
