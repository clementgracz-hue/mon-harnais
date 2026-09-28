import { AISLE_EMOJI, aisleRank } from "@/lib/aisles";
import type { Aisle } from "@/lib/types/database";

export type ShoppingSource = "recette" | "pense-bête" | "récurrent";

export type RawItem = {
  name: string;
  quantity: number | null;
  unit: string | null;
  aisle: Aisle;
  source: ShoppingSource;
  /** Titre de la recette / origine, pour l'affichage détaillé. */
  from?: string;
};

export type ShoppingLine = {
  key: string;
  name: string;
  /** Quantités consolidées, une par dimension (ex: "300 g", "2 pièces"). */
  amounts: string[];
  aisle: Aisle;
  sources: ShoppingSource[];
  from: string[];
};

export type ShoppingSection = {
  aisle: Aisle;
  items: ShoppingLine[];
};

// ---------------------------------------------------------------------------
//  Unités : conversion vers une unité de base par dimension
// ---------------------------------------------------------------------------

type Dimension = "masse" | "volume" | "unité" | "cuillère" | "autre";

const UNIT_TABLE: Record<
  string,
  { dimension: Dimension; base: string; factor: number }
> = {
  // masse (base : gramme)
  g: { dimension: "masse", base: "g", factor: 1 },
  gr: { dimension: "masse", base: "g", factor: 1 },
  gramme: { dimension: "masse", base: "g", factor: 1 },
  grammes: { dimension: "masse", base: "g", factor: 1 },
  kg: { dimension: "masse", base: "g", factor: 1000 },
  // volume (base : millilitre)
  ml: { dimension: "volume", base: "ml", factor: 1 },
  cl: { dimension: "volume", base: "ml", factor: 10 },
  dl: { dimension: "volume", base: "ml", factor: 100 },
  l: { dimension: "volume", base: "ml", factor: 1000 },
  litre: { dimension: "volume", base: "ml", factor: 1000 },
  litres: { dimension: "volume", base: "ml", factor: 1000 },
  // dénombrable (base : pièce)
  "": { dimension: "unité", base: "pièce", factor: 1 },
  piece: { dimension: "unité", base: "pièce", factor: 1 },
  pièce: { dimension: "unité", base: "pièce", factor: 1 },
  pièces: { dimension: "unité", base: "pièce", factor: 1 },
  unité: { dimension: "unité", base: "pièce", factor: 1 },
  tranche: { dimension: "unité", base: "tranche", factor: 1 },
  tranches: { dimension: "unité", base: "tranche", factor: 1 },
  pincée: { dimension: "unité", base: "pincée", factor: 1 },
  pincées: { dimension: "unité", base: "pincée", factor: 1 },
  gousse: { dimension: "unité", base: "gousse", factor: 1 },
  gousses: { dimension: "unité", base: "gousse", factor: 1 },
  sachet: { dimension: "unité", base: "sachet", factor: 1 },
  sachets: { dimension: "unité", base: "sachet", factor: 1 },
  boîte: { dimension: "unité", base: "boîte", factor: 1 },
  boîtes: { dimension: "unité", base: "boîte", factor: 1 },
  // cuillères (base : cuillère à café)
  "c. à c.": { dimension: "cuillère", base: "c. à c.", factor: 1 },
  cac: { dimension: "cuillère", base: "c. à c.", factor: 1 },
  "c. à s.": { dimension: "cuillère", base: "c. à c.", factor: 3 },
  cas: { dimension: "cuillère", base: "c. à c.", factor: 3 },
};

function normalizeUnit(unit: string | null | undefined) {
  const raw = (unit ?? "").trim().toLowerCase();
  return (
    UNIT_TABLE[raw] ?? {
      dimension: "autre" as Dimension,
      base: raw,
      factor: 1,
    }
  );
}

/** Clé de regroupement : nom insensible à la casse, aux accents et au pluriel. */
export function normalizeName(name: string) {
  return name
    .trim()
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/\s+/g, " ")
    .replace(/s$/, "");
}

function round(value: number) {
  return Math.round(value * 100) / 100;
}

/** 1200 g → "1,2 kg" ; 300 g → "300 g" ; 1500 ml → "1,5 L". */
function formatAmount(total: number, base: string) {
  let value = total;
  let unit = base;

  if (base === "g" && total >= 1000) {
    value = total / 1000;
    unit = "kg";
  } else if (base === "ml" && total >= 1000) {
    value = total / 1000;
    unit = "L";
  } else if (base === "c. à c." && total >= 3 && total % 3 === 0) {
    // 12 cuillères à café se lisent mieux en 4 cuillères à soupe.
    value = total / 3;
    unit = "c. à s.";
  }

  const rounded = round(value);
  const printed = Number.isInteger(rounded)
    ? String(rounded)
    : rounded.toFixed(2).replace(/0$/, "").replace(".", ",");

  // Unités dénombrables : accord au pluriel ("2 gousses", "3 sachets").
  const COUNTABLE = ["pièce", "gousse", "sachet", "boîte", "tranche", "pincée"];
  if (COUNTABLE.includes(unit) && rounded > 1) unit = `${unit}s`;

  return unit ? `${printed} ${unit}` : printed;
}

// ---------------------------------------------------------------------------
//  Consolidation
// ---------------------------------------------------------------------------

/**
 * Fusionne les doublons (200 g de beurre + 100 g de beurre = 300 g de beurre)
 * et regroupe le résultat par rayon du Drive.
 *
 * Deux quantités ne sont additionnées que si leurs unités partagent la même
 * dimension : "2 gousses d'ail" et "1 kg d'ail" restent deux quantités
 * distinctes sur la même ligne.
 */
export function consolidate(items: RawItem[]): ShoppingSection[] {
  const lines = new Map<
    string,
    {
      name: string;
      aisle: Aisle;
      totals: Map<string, number>;
      hasUnknownQuantity: boolean;
      sources: Set<ShoppingSource>;
      from: Set<string>;
    }
  >();

  for (const item of items) {
    const key = normalizeName(item.name);
    if (!key) continue;

    const line =
      lines.get(key) ??
      {
        name: item.name.trim(),
        aisle: item.aisle,
        totals: new Map<string, number>(),
        hasUnknownQuantity: false,
        sources: new Set<ShoppingSource>(),
        from: new Set<string>(),
      };

    // Un rayon explicite (≠ "Autres") l'emporte sur un défaut.
    if (line.aisle === "Autres" && item.aisle !== "Autres") line.aisle = item.aisle;

    line.sources.add(item.source);
    if (item.from) line.from.add(item.from);

    if (item.quantity == null || Number.isNaN(item.quantity)) {
      line.hasUnknownQuantity = true;
    } else {
      const { base, factor } = normalizeUnit(item.unit);
      line.totals.set(base, (line.totals.get(base) ?? 0) + item.quantity * factor);
    }

    lines.set(key, line);
  }

  const sections = new Map<Aisle, ShoppingLine[]>();

  for (const [key, line] of lines) {
    const amounts = [...line.totals.entries()]
      .filter(([, total]) => total > 0)
      .map(([base, total]) => formatAmount(total, base));

    if (amounts.length === 0 && line.hasUnknownQuantity) amounts.push("");

    const list = sections.get(line.aisle) ?? [];
    list.push({
      key,
      name: line.name,
      amounts: amounts.filter((a) => a !== ""),
      aisle: line.aisle,
      sources: [...line.sources],
      from: [...line.from],
    });
    sections.set(line.aisle, list);
  }

  return [...sections.entries()]
    .map(([aisle, items]) => ({
      aisle,
      items: items.sort((a, b) => a.name.localeCompare(b.name, "fr")),
    }))
    .sort((a, b) => aisleRank(a.aisle) - aisleRank(b.aisle));
}

// ---------------------------------------------------------------------------
//  Export texte pour Leclerc Drive
// ---------------------------------------------------------------------------

/**
 * Trois façons de sortir la liste, parce que le Drive ne se remplit pas
 * toujours de la même manière :
 *
 * - `rayons` : groupée, avec les quantités — pour lire en saisissant à la main ;
 * - `noms`   : un nom nu par ligne, sans quantité ni ponctuation — c'est ce
 *   qu'attendent les champs d'ajout en masse, qui cherchent le libellé exact
 *   et ne trouvent rien si la ligne porte un tiret, un emoji ou « 500 g » ;
 * - `assistant` : une consigne suivie des quantités, pour un assistant à qui
 *   on parle en français.
 */
export const COPY_FORMATS = ["rayons", "noms", "assistant", "cowork"] as const;

export type CopyFormat = (typeof COPY_FORMATS)[number];

export const COPY_FORMAT_LABELS: Record<CopyFormat, string> = {
  rayons: "Par rayon",
  noms: "Noms seuls",
  assistant: "Pour l'assistant",
  cowork: "Pour Cowork",
};

export const COPY_FORMAT_HINTS: Record<CopyFormat, string> = {
  rayons: "Groupée avec les quantités, pour saisir article par article.",
  noms: "Un nom par ligne, rien d'autre : pour l'ajout en masse du Drive.",
  assistant: "Une phrase et les quantités, pour Hopla ou un chatbot du Drive.",
  cowork: "La consigne complète : quoi acheter, quoi proposer, quoi valider.",
};

/** Libellé tel qu'on le taperait dans une barre de recherche. */
function plainName(name: string) {
  return name
    .replace(/[()[\]]/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

/**
 * Texte brut épuré : un article par ligne, prêt à être collé / recherché
 * article par article dans la barre de recherche du Drive.
 */
export function toDriveText(
  sections: ShoppingSection[],
  options: {
    withAisles?: boolean;
    skip?: Set<string>;
    note?: string;
    format?: CopyFormat;
  } = {},
) {
  const { skip, note, format = "rayons" } = options;
  const withAisles = options.withAisles ?? format === "rayons";
  const blocks: string[] = [];

  const kept = sections
    .map((section) => ({
      aisle: section.aisle,
      items: section.items.filter((item) => !skip?.has(item.key)),
    }))
    .filter((section) => section.items.length > 0);

  // Les champs d'ajout en masse cherchent un libellé : tout le reste — tiret,
  // quantité, titre de rayon — fait échouer la correspondance. Les
  // parenthèses aussi : « Bœuf (haché surgelé) » ne ressort pas, « Bœuf haché
  // surgelé » si.
  if (format === "noms") {
    return kept
      .flatMap((section) => section.items.map((item) => plainName(item.name)))
      .join("\n");
  }

  // L'en-tête part en tête du presse-papier : c'est la consigne qu'on relit
  // en choisissant les produits sur le Drive.
  if (format === "assistant") {
    const consigne = note?.trim()
      ? `Ajoute ces produits à mon panier (${note.trim().replace(/^Préférences\s*:\s*/, "")}) :`
      : "Ajoute ces produits à mon panier :";

    return [
      consigne,
      ...kept.flatMap((section) =>
        section.items.map((item) => {
          const amount = item.amounts.join(" + ");
          return amount ? `${item.name} — ${amount}` : item.name;
        }),
      ),
    ].join("\n");
  }

  if (note?.trim()) blocks.push(note.trim());

  for (const section of kept) {
    const lines = section.items.map((item) => {
      const amount = item.amounts.join(" + ");
      return amount ? `- ${item.name} — ${amount}` : `- ${item.name}`;
    });

    blocks.push(
      withAisles
        ? `${AISLE_EMOJI[section.aisle]} ${section.aisle.toUpperCase()}\n${lines.join("\n")}`
        : lines.join("\n"),
    );
  }

  return blocks.join("\n\n");
}

/**
 * Ce qu'on veut au moment de choisir les produits sur le Drive. Les trois
 * ne s'excluent pas : bio sur le frais et premiers prix sur l'épicerie est un
 * arbitrage courant.
 */
export const PREFERENCES = ["bio", "marques", "économique"] as const;

export type Preference = (typeof PREFERENCES)[number];

export const PREFERENCE_LABELS: Record<Preference, string> = {
  bio: "Bio",
  marques: "Marques",
  économique: "Économique",
};

const PREFERENCE_NOTES: Record<Preference, string> = {
  bio: "bio de préférence",
  marques: "marques connues",
  économique: "premiers prix",
};

/** En-tête de la liste copiée. Vide si rien n'est coché. */
export function preferenceNote(preferences: Iterable<Preference>) {
  const chosen = new Set(preferences);
  const notes = PREFERENCES.filter((preference) => chosen.has(preference)).map(
    (preference) => PREFERENCE_NOTES[preference],
  );

  return notes.length === 0 ? "" : `Préférences : ${notes.join(" · ")}`;
}

/** Mots significatifs d'un libellé, au singulier, parenthèses ouvertes. */
export function keywords(value: string) {
  return normalizeName(value)
    .replace(/[()[\]]/g, " ")
    .split(/[\s,'’-]+/)
    .map((word) => word.replace(/s$/, ""))
    .filter((word) => word.length > 2);
}

/**
 * Deux libellés désignent-ils le même produit ? Tous les mots du plus court
 * doivent se retrouver dans l'autre, et les deux doivent commencer par le
 * même mot : « Feta » reconnaît « Feta AOP grecque », mais « Pommes de terre »
 * ne se confond pas avec des « Chips pommes de terre », dont le nom dit bien
 * qu'il s'agit d'autre chose. En français le produit se nomme en premier, le
 * reste le précise.
 */
export function sameProduct(a: string, b: string) {
  const left = keywords(a);
  const right = keywords(b);
  if (left.length === 0 || right.length === 0) return false;
  if (left[0] !== right[0]) return false;

  const [short, long] = left.length <= right.length ? [left, right] : [right, left];
  return short.every((word) => long.includes(word));
}

export function countItems(sections: ShoppingSection[]) {
  return sections.reduce((total, section) => total + section.items.length, 0);
}

/**
 * Consigne complète pour un agent qui pilote le Drive dans le navigateur.
 *
 * Elle porte quatre choses que la seule liste ne dit pas : ce qu'il peut
 * ajouter seul et ce qu'il doit faire valider, les habitués à proposer parce
 * qu'on les oublie, le style à suivre quand un produit n'est pas précisé, et
 * le compte rendu attendu à la fin — substitutions et manquants.
 */
export function toCoworkBrief(
  sections: ShoppingSection[],
  options: {
    skip?: Set<string>;
    note?: string;
    /** Les récurrents, tous : ceux du panier et ceux laissés de côté. */
    habits?: string[];
  } = {},
) {
  const { skip, note, habits = [] } = options;

  const wanted = sections.flatMap((section) =>
    section.items.filter((item) => !skip?.has(item.key)),
  );

  const lines = wanted.map((item) => {
    const amount = item.amounts.join(" + ");
    return amount ? `${item.name} — ${amount}` : item.name;
  });

  // Un habitué se range dans l'une des deux colonnes : soit la liste le
  // demande déjà et il dit quelle référence prendre, soit il est absent et
  // vaut la peine d'être proposé.
  const known = new Map<string, string>();
  const toSuggest: string[] = [];

  for (const habit of habits) {
    const line = sections
      .flatMap((section) => section.items)
      .find((item) => sameProduct(item.name, habit));

    if (!line) toSuggest.push(habit);
    else if (normalizeName(line.name) !== normalizeName(habit)) {
      known.set(line.name, habit);
    }
  }

  // Sans habitués, la section « À me proposer » n'existe pas : ne pas y
  // renvoyer, sous peine d'envoyer l'agent chercher une liste absente.
  const scope = toSuggest.length
    ? "- n'ajoute rien qui ne soit ni dans « À acheter » ni dans « À me proposer »."
    : "- n'ajoute rien qui ne soit pas dans « À acheter ».";

  const blocks: string[] = [
    "Je suis déjà connecté à mon Drive dans le navigateur. Remplis mon panier " +
      "avec la liste « À acheter » ci-dessous, en respectant les quantités. " +
      "Ne valide pas la commande et ne choisis pas de créneau : je relis avant.",
    [
      "Ce que tu peux faire seul, et ce que tu dois me demander :",
      "- correspondance évidente : ajoute sans me déranger ;",
      "- produit introuvable à l'identique, grammage différent, lot, ou prix qui te",
      "  semble anormal : propose-moi le produit et attends que je valide ;",
      scope,
    ].join("\n"),
  ];

  if (note?.trim()) {
    blocks.push(
      `Mes préférences : ${note.trim().replace(/^Préférences\s*:\s*/, "")}.`,
    );
  }

  blocks.push(
    [
      "Le Drive garde lui aussi mes habitudes — « mes favoris », « déjà",
      "commandés », mes commandes précédentes. Parcours-les et signale-moi ce",
      "que j'y rachète souvent et qui ne figure nulle part ci-dessous ; propose",
      "chacun avant de l'ajouter.",
    ].join("\n"),
  );

  blocks.push(
    [
      "Préviens-moi dès que le panier est complet, et donne-moi alors :",
      "- ce que tu as remplacé, et par quoi ;",
      "- ce que tu n'as pas trouvé ;",
      "- la liste des habitués repérés sur le Drive, un par ligne et sans",
      "  quantité, pour que je la garde dans mon application.",
    ].join("\n"),
  );

  blocks.push(
    `À acheter (${lines.length} article${lines.length > 1 ? "s" : ""}) :\n${lines.join("\n")}`,
  );

  if (known.size > 0) {
    blocks.push(
      "Pour ces lignes, prends la référence que j'achète d'habitude :\n" +
        [...known].map(([line, habit]) => `${line} → ${habit}`).join("\n"),
    );
  }

  if (toSuggest.length > 0) {
    blocks.push(
      "À me proposer, un par un, au cas où je les aurais oubliés — n'ajoute que " +
        `ceux que j'accepte :\n${toSuggest.join("\n")}`,
    );
  }

  return blocks.join("\n\n");
}
