import { normalizeName } from "@/lib/shopping";
import { toDateInput } from "@/lib/shelf-life";
import { DAYS } from "@/lib/types/database";

/**
 * Correction de DLC dictée en une phrase : « saumon vendredi, yaourts le 15,
 * poulet dans trois jours ». Les dates proposées par l'app sont déjà justes
 * la plupart du temps — on ne vient corriger que celles qui ne vont pas.
 *
 * L'analyse est locale et déterministe : pas d'appel réseau, donc rien à
 * attendre au milieu du rangement des courses, et un comportement testable.
 */

export type Correction = {
  /** Le produit tel qu'il a été prononcé. */
  query: string;
  /** `YYYY-MM-DD`. */
  date: string;
};

export type Dictation = {
  corrections: Correction[];
  /** Morceaux sans date reconnaissable, à signaler plutôt qu'à ignorer. */
  unmatched: string[];
};

const NUMBERS: Record<string, number> = {
  un: 1,
  une: 1,
  deux: 2,
  trois: 3,
  quatre: 4,
  cinq: 5,
  six: 6,
  sept: 7,
  huit: 8,
  neuf: 9,
  dix: 10,
  onze: 11,
  douze: 12,
  quinze: 15,
};

const MONTHS = [
  "janvier",
  "fevrier",
  "mars",
  "avril",
  "mai",
  "juin",
  "juillet",
  "aout",
  "septembre",
  "octobre",
  "novembre",
  "decembre",
];

/** Minuscules sans accents, apostrophes uniformisées. */
function fold(value: string) {
  return value
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[\u2019`]/g, "'")
    .replace(/\s+/g, " ")
    .trim();
}

const DAY_NAMES = DAYS.map(fold);

const NUMBER_WORDS = Object.keys(NUMBERS).join("|");
const MONTH_NAMES = MONTHS.join("|");

/**
 * Les formes de date reconnues, dans l'ordre où on les essaie. La plus
 * spécifique d'abord : « dans deux semaines » avant « deux ».
 */
const DATE_PATTERN = new RegExp(
  [
    `dans (?:\\d+|${NUMBER_WORDS}) (?:jours?|semaines?)`,
    `(?:apres[- ]demain|avant[- ]hier)`,
    `aujourd'hui|ce soir|demain|hier`,
    `(?:${DAY_NAMES.join("|")})(?: prochain)?`,
    `le (\\d{1,2})(?:er)? (?:${MONTH_NAMES})`,
    `(\\d{1,2})(?:er)? (?:${MONTH_NAMES})`,
    `le (\\d{1,2})(?:er)?(?![\\d/-])`,
    `\\d{1,2}[/-]\\d{1,2}(?:[/-]\\d{2,4})?`,
  ].join("|"),
  "g",
);

function startOfDay(date: Date) {
  const copy = new Date(date);
  copy.setHours(12, 0, 0, 0);
  return copy;
}

function addDays(date: Date, days: number) {
  const copy = startOfDay(date);
  copy.setDate(copy.getDate() + days);
  return copy;
}

/** Prochaine occurrence de ce jour de la semaine, aujourd'hui compris. */
function nextWeekday(from: Date, weekday: number, strictlyAfter: boolean) {
  const current = (startOfDay(from).getDay() + 6) % 7;
  let delta = (weekday - current + 7) % 7;
  if (delta === 0 && strictlyAfter) delta = 7;
  return addDays(from, delta);
}

/** Prochaine occurrence de ce quantième, ce mois-ci ou le suivant. */
function nextDayOfMonth(from: Date, day: number, month?: number) {
  const base = startOfDay(from);
  const candidate = new Date(base);
  candidate.setDate(1);
  if (month !== undefined) candidate.setMonth(month);
  candidate.setDate(day);

  if (candidate < base) {
    candidate.setMonth(candidate.getMonth() + (month === undefined ? 1 : 12));
  }
  return candidate;
}

/** Traduit une expression déjà repérée en date absolue. */
function toDate(expression: string, from: Date): Date | null {
  const text = fold(expression);

  if (text === "aujourd'hui" || text === "ce soir") return startOfDay(from);
  if (text === "demain") return addDays(from, 1);
  if (text === "hier") return addDays(from, -1);
  if (/^apres[- ]demain$/.test(text)) return addDays(from, 2);
  if (/^avant[- ]hier$/.test(text)) return addDays(from, -2);

  const relative = text.match(/^dans (\d+|[a-z]+) (jours?|semaines?)$/);
  if (relative) {
    const count = Number(relative[1]) || NUMBERS[relative[1]];
    if (!count) return null;
    return addDays(from, relative[2].startsWith("semaine") ? count * 7 : count);
  }

  const weekday = text.match(/^([a-z]+)(?: (prochain))?$/);
  if (weekday && DAY_NAMES.includes(weekday[1])) {
    return nextWeekday(from, DAY_NAMES.indexOf(weekday[1]), Boolean(weekday[2]));
  }

  const withMonth = text.match(/^(?:le )?(\d{1,2})(?:er)? ([a-z]+)$/);
  if (withMonth && MONTHS.includes(withMonth[2])) {
    return nextDayOfMonth(from, Number(withMonth[1]), MONTHS.indexOf(withMonth[2]));
  }

  const dayOnly = text.match(/^le (\d{1,2})(?:er)?$/);
  if (dayOnly) return nextDayOfMonth(from, Number(dayOnly[1]));

  const numeric = text.match(/^(\d{1,2})[/-](\d{1,2})(?:[/-](\d{2,4}))?$/);
  if (numeric) {
    const day = Number(numeric[1]);
    const month = Number(numeric[2]) - 1;
    if (numeric[3]) {
      const year = Number(numeric[3]);
      const date = startOfDay(from);
      date.setFullYear(year < 100 ? 2000 + year : year, month, day);
      return date;
    }
    return nextDayOfMonth(from, day, month);
  }

  return null;
}

/** Mots de liaison qui traînent autour du produit une fois la date isolée. */
const FILLER =
  /^(?:et|puis|alors|aussi|le|la|les|l'|un|une|des|du|de|d'|pour|a|au|aux|ca|c'est|il|elle|ils|elles|ce|cette|est|sont|expire|expirent|perime|periment|se|perimee|perimees|jusqu'au|jusqu'a|ensuite|ok|euh)$/;

function cleanProduct(raw: string) {
  const words = fold(raw)
    .replace(/[.,;:!?]/g, " ")
    .split(" ")
    .filter(Boolean);

  while (words.length > 0 && FILLER.test(words[0])) words.shift();
  while (words.length > 0 && FILLER.test(words[words.length - 1])) words.pop();

  return words.join(" ");
}

/**
 * Découpe la phrase autour des expressions de date : ce qui précède chacune
 * est le produit. La ponctuation aide mais n'est pas requise — la dictée du
 * téléphone n'en met pas toujours.
 */
export function parseDictation(transcript: string, from = new Date()): Dictation {
  const corrections: Correction[] = [];
  const unmatched: string[] = [];

  const text = fold(transcript);
  if (!text) return { corrections, unmatched };

  let cursor = 0;
  let found = false;

  for (const match of text.matchAll(DATE_PATTERN)) {
    const date = toDate(match[0], from);
    const product = cleanProduct(text.slice(cursor, match.index));
    cursor = match.index + match[0].length;

    if (!date) {
      if (product) unmatched.push(product);
      continue;
    }

    found = true;
    if (product) corrections.push({ query: product, date: toDateInput(date) });
    else unmatched.push(match[0]);
  }

  const tail = cleanProduct(text.slice(cursor));
  if (tail) unmatched.push(tail);
  if (!found && corrections.length === 0 && unmatched.length === 0) {
    unmatched.push(text);
  }

  return { corrections, unmatched };
}

/**
 * Retrouve le produit visé parmi ceux de la livraison. Tolérant : « saumon »
 * doit reconnaître « Pavé de saumon frais », mais « riz » ne doit pas
 * attraper « Ravioles du Dauphiné ».
 */
export function matchProduct(query: string, names: string[]): number | null {
  const wanted = normalizeName(query);
  if (!wanted) return null;

  const words = wanted.split(" ").filter((word) => word.length > 2);
  let bestIndex: number | null = null;
  let bestScore = 0;

  names.forEach((name, index) => {
    const candidate = normalizeName(name);
    let score = 0;

    if (candidate === wanted) score = 100;
    else if (candidate.includes(wanted) || wanted.includes(candidate)) score = 50;
    else {
      const parts = candidate.split(" ").map((part) => normalizeName(part));
      // Un seul mot commun suffit s'il est significatif (« saumon »).
      score =
        10 *
        words.filter((word) =>
          parts.some((part) => part === word || part.startsWith(word)),
        ).length;
    }

    if (score > bestScore) {
      bestScore = score;
      bestIndex = index;
    }
  });

  return bestIndex;
}
