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
 *
 * L'ordre compte : le premier rayon qui matche gagne. Les rayons non
 * alimentaires et les libellés composés passent en premier pour que
 * « jus d'orange » aille en Boissons plutôt qu'en Fruits & Légumes, et
 * « lait de coco » en Épicerie salée plutôt qu'en Crémerie.
 */
const KEYWORDS: Array<[Aisle, string[]]> = [
  ["Bébé", ["couche", "lingette", "petit pot", "lait infantile", "bébé"]],
  ["Animalerie", ["litière", "croquette", "pâtée", "chat", "chien"]],
  [
    "Hygiène & Beauté",
    ["dentifrice", "shampoing", "savon", "gel douche", "déodorant", "rasoir", "coton tige", "brosse à dents"],
  ],
  [
    "Entretien & Maison",
    ["lessive", "liquide vaisselle", "éponge", "papier toilette", "essuie-tout", "sac poubelle", "nettoyant", "sopalin", "adoucissant", "papier cuisson"],
  ],
  ["Boissons", ["jus", "eau", "soda", "bière", "vin", "sirop", "limonade", "cola"]],
  ["Surgelés", ["surgelé", "glace", "poêlée surgelée"]],
  [
    "Poissonnerie",
    ["saumon", "cabillaud", "poisson", "crevette", "moule", "colin", "truite", "lieu noir", "saint-jacques", "noix de saint-jacques"],
  ],
  [
    "Épicerie salée",
    [
      "pâtes", "spaghetti", "riz", "farine", "huile", "vinaigre", "sel", "poivre",
      "épice", "curry", "cumin", "paprika", "conserve", "tomate pelée", "concentré",
      "lentille", "pois chiche", "quinoa", "semoule", "couscous", "thon", "moutarde",
      "bouillon", "coulis", "lait de coco", "crème de coco", "sauce soja", "boulgour",
      "haricot rouge", "polenta", "pesto", "béchamel", "orzo", "blé", "mélange céréales",
      "olive", "tomate séchée", "houmous", "ketchup", "sauce tomate", "marron",
      "châtaigne", "chips de légumes", "chips de tortillas", "tortilla", "vin blanc",
      "graines de sésame", "graines de chia", "pignon de pin", "vinaigre", "crème de balsamique",
    ],
  ],
  [
    "Épicerie sucrée",
    [
      "sucre", "chocolat", "café", "thé", "confiture", "miel", "céréales", "biscuit",
      "levure", "vanille", "compote", "pâte à tartiner", "cacao", "noisette", "noix",
      "amande", "pistache", "avoine", "corn flakes", "sirop d'érable", "muscade",
      "cannelle", "flocons",
    ],
  ],
  [
    "Pain & Pâtisserie",
    [
      "pain", "baguette", "brioche", "pâte feuilletée", "pâte brisée", "wrap",
      "biscotte", "croissant", "feuille de brick", "pain burger", "pain de mie",
      "pain de campagne",
    ],
  ],
  [
    "Boucherie & Volaille",
    [
      "poulet", "boeuf", "bœuf", "steak", "veau", "porc", "agneau", "dinde",
      "escalope", "saucisse", "merguez", "haché", "rôti", "chipolata",
      "filet mignon", "chair à saucisse",
    ],
  ],
  [
    "Traiteur & Charcuterie",
    ["jambon", "lardon", "chorizo", "pâté", "rillettes", "bacon", "terrine", "saucisson", "lard", "mortadelle", "allumette", "prosciutto", "tzatziki"],
  ],
  [
    "Crémerie",
    [
      "lait", "beurre", "crème", "yaourt", "fromage", "comté", "gruyère",
      "mozzarella", "feta", "parmesan", "œuf", "oeuf", "ricotta", "chèvre", "skyr",
      "burrata", "brie", "reblochon", "raclette", "mont d'or", "rocamadour",
      "cheddar", "mascarpone", "crottin", "râpé végétal", "ravioles", "ravioli",
      "crozets", "lasagnes", "galette bretonne", "boisson végétale",
    ],
  ],
  [
    "Fruits & Légumes",
    [
      "tomate", "salade", "carotte", "courgette", "poivron", "oignon", "ail",
      "échalote", "pomme de terre", "patate", "pomme", "poire", "banane",
      "citron", "orange", "fraise", "champignon", "brocoli", "chou", "chou-fleur",
      "épinard", "haricot", "haricot vert", "petit pois", "concombre", "avocat",
      "persil", "coriandre", "basilic", "aubergine", "potiron", "courge",
      "poireau", "navet", "radis", "melon", "raisin", "kiwi", "clémentine",
      "endive", "panais", "patate douce", "potimarron", "butternut", "céleri",
      "abricot", "nectarine", "pamplemousse", "framboise", "cerise", "rhubarbe",
      "chou blanc", "chou-fleur", "gingembre", "menthe", "ciboulette", "estragon",
      "origan", "thym", "herbes de provence", "laitue", "mâche", "roquette",
    ],
  ],
];

function fold(value: string) {
  return value
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "");
}

/**
 * Mot entier, pluriel tol\u00e9r\u00e9 sur chaque mot du libell\u00e9 (\u00ab petits pois \u00bb
 * matche \u00ab petit pois \u00bb). La recherche par simple sous-cha\u00eene classait
 * \u00ab Couches taille 4 \u00bb en Fruits & L\u00e9gumes : \u00ab ail \u00bb est contenu dans
 * \u00ab taille \u00bb.
 */
function toWordRegex(words: string[]) {
  const alternatives = words
    .map((word) => {
      const parts = fold(word)
        .split(/\s+/)
        .map((part) => part.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"));
      const head = parts.slice(0, -1).map((part) => `${part}s?`);
      return [...head, parts[parts.length - 1]].join("\\s+");
    })
    .join("|");
  return new RegExp(`(?<!\\p{L})(?:${alternatives})(?:s|es|x)?(?!\\p{L})`, "u");
}

const AISLE_MATCHERS: Array<[Aisle, RegExp]> = KEYWORDS.map(([aisle, words]) => [
  aisle,
  toWordRegex(words),
]);

export function guessAisle(name: string): Aisle {
  const haystack = fold(name);

  for (const [aisle, matcher] of AISLE_MATCHERS) {
    if (matcher.test(haystack)) return aisle;
  }
  return "Autres";
}
