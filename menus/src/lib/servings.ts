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
