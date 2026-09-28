import { guessAisle, type Aisle } from "@/lib/aisles";
import { normalizeName } from "@/lib/shopping";

/**
 * Lecture d'une liste collée — celle que Cowork rapporte du Drive, celle
 * qu'on recopie d'un vieux ticket. Le texte arrive dans tous les états :
 * puces, numéros, quantités accrochées au nom, titres de rayon.
 */

export type ParsedStaple = { name: string; aisle: Aisle };

export type StapleImport = {
  /** À insérer, dans l'ordre d'apparition. */
  staples: ParsedStaple[];
  /** Déjà connus ou répétés dans le collage : signalés, pas insérés. */
  duplicates: string[];
};

/** Enlève ce qui décore une ligne de liste sans nommer le produit. */
function cleanLine(raw: string) {
  return raw
    .replace(/^\s*(?:[-*•–—]|\d+[.)])\s*/, "")
    .replace(/\s*[—–]\s*[^—–]*$/, "") // « Feta — 80 g »
    .replace(/\s*\b\d+(?:[.,]\d+)?\s*(?:g|kg|ml|cl|l|pièces?|x)\b\.?$/i, "")
    .replace(/\s+/g, " ")
    .trim();
}

/** Une ligne qui annonce une section plutôt qu'un produit. */
function isHeading(line: string) {
  return line.endsWith(":") || /^[A-ZÀ-Ý\s&']+$/.test(line);
}

export function parseStapleList(text: string, existing: string[] = []): StapleImport {
  const known = new Set(existing.map(normalizeName));
  const staples: ParsedStaple[] = [];
  const duplicates: string[] = [];

  for (const raw of text.split(/\r?\n/)) {
    const name = cleanLine(raw);
    if (!name || name.length < 2 || isHeading(name)) continue;

    const key = normalizeName(name);
    if (known.has(key)) {
      duplicates.push(name);
      continue;
    }

    known.add(key);
    staples.push({ name, aisle: guessAisle(name) });
  }

  return { staples, duplicates };
}
