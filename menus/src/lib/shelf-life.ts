import type { Aisle } from "@/lib/types/database";

/**
 * Durée de conservation indicative, en jours après l'achat.
 *
 * Ce n'est pas la DLC imprimée sur l'emballage : c'est une valeur de départ
 * pour préremplir la saisie au retour du Drive, toujours corrigeable. Les
 * valeurs sont volontairement prudentes.
 */
const BY_AISLE: Record<Aisle, number> = {
  "Fruits & Légumes": 6,
  "Boucherie & Volaille": 3,
  Poissonnerie: 2,
  Crémerie: 12,
  "Traiteur & Charcuterie": 5,
  Surgelés: 180,
  "Épicerie salée": 365,
  "Épicerie sucrée": 365,
  "Pain & Pâtisserie": 4,
  Boissons: 180,
  Bébé: 180,
  "Hygiène & Beauté": 730,
  "Entretien & Maison": 730,
  Animalerie: 180,
  Autres: 30,
};

/** Produits dont la tenue s'écarte nettement de leur rayon. */
const BY_KEYWORD: Array<[number, string[]]> = [
  [1, ["salade en sachet", "poisson cru", "tartare"]],
  [2, ["viande hachee", "steak hache", "crevette", "moule", "saumon", "cabillaud", "colin", "truite", "framboise", "fraise"]],
  [3, ["poulet", "dinde", "veau", "porc", "agneau", "salade", "epinard", "champignon", "basilic", "coriandre", "menthe", "persil", "avocat", "banane"]],
  [5, ["lardon", "jambon", "chorizo", "bacon", "creme fraiche", "pain", "brioche", "galette", "tomate cerise", "concombre", "courgette", "poivron", "brocoli"]],
  [8, ["tomate", "aubergine", "poireau", "chou", "haricot vert", "citron", "orange", "clementine", "poire", "pomme", "raisin", "kiwi"]],
  [15, ["yaourt", "mozzarella", "feta", "ricotta", "chevre", "lait", "beurre", "creme liquide"]],
  [21, ["oeuf", "œuf", "fromage rape", "comte", "gruyere", "parmesan"]],
  [30, ["carotte", "oignon", "echalote", "ail", "pomme de terre", "patate", "courge", "potiron", "navet"]],
];

function fold(value: string) {
  return value
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "");
}

/** Nombre de jours de conservation estimé pour un produit. */
export function shelfLifeDays(name: string, aisle: Aisle): number {
  const haystack = fold(name);

  // Le mot-clé le plus court l'emporte : mieux vaut sous-estimer.
  for (const [days, words] of BY_KEYWORD) {
    if (words.some((word) => haystack.includes(fold(word)))) return days;
  }
  return BY_AISLE[aisle];
}

/** Date de péremption proposée, au format `YYYY-MM-DD`. */
export function suggestExpiry(name: string, aisle: Aisle, from = new Date()) {
  const date = new Date(from);
  date.setDate(date.getDate() + shelfLifeDays(name, aisle));
  return toDateInput(date);
}

/** `YYYY-MM-DD` en heure locale — `toISOString()` décalerait d'un jour. */
export function toDateInput(date: Date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

/** Nombre de jours entiers entre aujourd'hui et une date (négatif = dépassée). */
export function daysUntil(date: string, from = new Date()) {
  const target = new Date(`${date}T00:00:00`);
  const start = new Date(from.getFullYear(), from.getMonth(), from.getDate());
  return Math.round((target.getTime() - start.getTime()) / 86_400_000);
}

/** « périmé », « aujourd'hui », « dans 3 jours ». */
export function formatExpiry(date: string, from = new Date()) {
  const days = daysUntil(date, from);
  if (days < 0) return days === -1 ? "périmé d'hier" : `périmé depuis ${-days} jours`;
  if (days === 0) return "à consommer aujourd'hui";
  if (days === 1) return "à consommer demain";
  return `dans ${days} jours`;
}
