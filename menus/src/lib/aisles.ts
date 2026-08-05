import { AISLES, type Aisle } from "@/lib/types/database";

export { AISLES };
export type { Aisle };

/** Emoji par rayon — repère visuel dans les listes groupées. */
export const AISLE_EMOJI: Record<Aisle, string> = {
  "Fruits & Légumes": "🥕",
  "Boucherie & Volaille": "🥩",
  Poissonnerie: "🐟",
  Crémerie: "🧀",
  "Traiteur & Charcuterie": "🥓",
  Surgelés: "🧊",
  "Épicerie salée": "🍝",
  "Épicerie sucrée": "🍫",
  "Pain & Pâtisserie": "🥖",
  Boissons: "🥤",
  Bébé: "🍼",
  "Hygiène & Beauté": "🧴",
  "Entretien & Maison": "🧽",
  Animalerie: "🐾",
  Autres: "🛒",
};

/** Ordre de parcours du Drive : sert au tri des sections de la liste. */
export function aisleRank(aisle: Aisle) {
  const index = AISLES.indexOf(aisle);
  return index === -1 ? AISLES.length : index;
}

/**
 * Devine le rayon à partir du nom d'un produit.
 * Utilisé pour pré-remplir le champ à la saisie — toujours modifiable.
 */
const KEYWORDS: Array<[Aisle, string[]]> = [
  [
    "Fruits & Légumes",
    [
      "tomate", "salade", "carotte", "courgette", "poivron", "oignon", "ail",
      "échalote", "pomme de terre", "patate", "pomme", "poire", "banane",
      "citron", "orange", "fraise", "champignon", "brocoli", "chou", "épinard",
      "haricot vert", "concombre", "avocat", "persil", "coriandre", "basilic",
      "aubergine", "potiron", "courge", "poireau", "navet", "radis", "melon",
    ],
  ],
  [
    "Boucherie & Volaille",
    ["poulet", "boeuf", "bœuf", "steak", "veau", "porc", "agneau", "dinde", "escalope", "saucisse", "merguez", "haché"],
  ],
  ["Poissonnerie", ["saumon", "cabillaud", "poisson", "crevette", "thon frais", "moule", "colin", "truite"]],
  [
    "Crémerie",
    ["lait", "beurre", "crème", "yaourt", "fromage", "comté", "gruyère", "mozzarella", "feta", "parmesan", "œuf", "oeuf", "ricotta", "chèvre"],
  ],
  ["Traiteur & Charcuterie", ["jambon", "lardon", "chorizo", "pâté", "rillettes", "bacon"]],
  ["Surgelés", ["surgelé", "glace", "petits pois surgelés", "poêlée surgelée"]],
  [
    "Épicerie salée",
    [
      "pâtes", "spaghetti", "riz", "farine", "huile", "vinaigre", "sel", "poivre",
      "épice", "curry", "cumin", "paprika", "conserve", "tomate pelée", "concentré",
      "lentille", "pois chiche", "quinoa", "semoule", "couscous", "thon", "moutarde",
      "bouillon", "coulis", "lait de coco", "sauce soja", "boulgour",
    ],
  ],
  ["Épicerie sucrée", ["sucre", "chocolat", "café", "thé", "confiture", "miel", "céréales", "biscuit", "levure", "vanille", "compote"]],
  ["Pain & Pâtisserie", ["pain", "baguette", "brioche", "pâte feuilletée", "pâte brisée", "wrap", "tortilla"]],
  ["Boissons", ["jus", "eau", "soda", "bière", "vin", "sirop", "limonade"]],
  ["Bébé", ["couche", "lingette", "petit pot", "lait infantile", "bébé"]],
  ["Hygiène & Beauté", ["dentifrice", "shampoing", "savon", "gel douche", "déodorant", "rasoir", "coton"]],
  ["Entretien & Maison", ["lessive", "liquide vaisselle", "éponge", "papier toilette", "essuie-tout", "sac poubelle", "nettoyant", "sopalin"]],
  ["Animalerie", ["litière", "croquette", "chat", "chien", "pâtée"]],
];

export function guessAisle(name: string): Aisle {
  const haystack = name
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "");

  for (const [aisle, words] of KEYWORDS) {
    for (const word of words) {
      const needle = word
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "");
      if (haystack.includes(needle)) return aisle;
    }
  }
  return "Autres";
}
