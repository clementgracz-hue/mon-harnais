/**
 * Convertit une liste de recettes Jow copiée en Markdown vers le format JSON
 * attendu par `recipes-to-sql.mjs`.
 *
 *   npm run recipes:jow -- recipes/jow-favoris.md
 *   → écrit recipes/jow-favoris.json
 *
 * Format d'entrée attendu, par recette :
 *
 *   ## 1. Titre
 *   - **Lien** : https://…
 *   - **Photo** : https://…
 *   - **Portions** : 2 personnes · **Prépa** 5 min · **Cuisson** 15 min · …
 *   - 246 kcal/portion · Note 4,4/5 (727 avis)
 *   **Ingrédients**
 *   - 120 g Nouilles chinoises
 *   **Préparation**
 *   1. …
 */
import { readFile, writeFile } from "node:fs/promises";

const [, , inputPath] = process.argv;
if (!inputPath) {
  console.error("Usage : npm run recipes:jow -- <fichier.md>");
  process.exit(1);
}

/** Abréviations Jow → unités de l'application. */
const UNITS = new Map([
  ["g", "g"],
  ["kg", "kg"],
  ["ml", "ml"],
  ["cl", "cl"],
  ["l", "L"],
  ["càs", "c. à s."],
  ["càc", "c. à c."],
  ["gou.", "gousse"],
  ["gou", "gousse"],
  ["pinc.", "pincée"],
  ["pinc", "pincée"],
  ["bou.", "bouquet"],
  ["bou", "bouquet"],
  ["tran.", "tranche"],
  ["tran", "tranche"],
  ["sac.", "sachet"],
  ["sac", "sachet"],
  ["poignée", "poignée"],
  ["poignées", "poignée"],
  ["quartier", "quartier"],
  ["quartiers", "quartier"],
  ["brin", "brin"],
  ["brins", "brin"],
  ["cm", "cm"],
  ["feuille", "feuille"],
  ["feuilles", "feuille"],
]);

/** « 1/2 », « 23,33 », « 2 » → nombre. */
function toNumber(raw) {
  if (!raw) return null;
  const fraction = raw.match(/^(\d+)\s*\/\s*(\d+)$/);
  if (fraction) return Number(fraction[1]) / Number(fraction[2]);
  const value = Number(raw.replace(",", "."));
  return Number.isFinite(value) ? value : null;
}

/** « 300 g Aubergine », « 1/2 Oignon jaune », « 2 càs Sauce soja ». */
function parseIngredient(line) {
  const match = line.match(/^(\d+(?:[.,]\d+)?(?:\s*\/\s*\d+)?)?\s*(.*)$/);
  const quantite = toNumber(match?.[1]?.trim());
  let rest = (match?.[2] ?? line).trim();

  let unite = null;
  const first = rest.split(/\s+/)[0];
  const mapped = UNITS.get(first.toLowerCase());
  if (mapped && rest.split(/\s+/).length > 1) {
    unite = mapped;
    rest = rest.slice(first.length).trim();
  }

  // Sans unité mais avec un nombre : c'est une pièce (« 1/2 Oignon »).
  if (!unite && quantite != null) unite = "pièce";

  return { nom: rest, quantite, unite };
}

const source = await readFile(inputPath, "utf8");
const blocks = source.split(/^## /m).slice(1);
const recipes = [];
const warnings = [];

for (const block of blocks) {
  const lines = block.split("\n");
  const titre = lines[0].replace(/^\d+\.\s*/, "").trim();
  if (!titre) continue;

  const lien = block.match(/\*\*Lien\*\*\s*:\s*(\S+)/)?.[1] ?? null;
  const photo = block.match(/\*\*Photo\*\*\s*:\s*(\S+)/)?.[1] ?? null;
  const portionsMatch = block.match(/\*\*Portions\*\*\s*:\s*(\d+)\s*([^·\n]*)/);
  const portions = toNumber(portionsMatch?.[1]) ?? 2;
  // « 6 quiches », « 4 tartes » : un plat entier, dont les quantités ne se
  // divisent pas — contrairement à « 2 personnes ».
  const platEntier = !/personne/i.test(portionsMatch?.[2] ?? "personnes");
  const preparation = toNumber(block.match(/\*\*Prépa\*\*\s*(\d+)/)?.[1]);
  const cuisson = toNumber(block.match(/\*\*Cuisson\*\*\s*(\d+)/)?.[1]);
  const total = toNumber(block.match(/\*\*Total\*\*\s*(\d+)/)?.[1]);

  // Ligne nutrition / note, reprise en description.
  const stats = block.match(/^-\s*(\d+\s*kcal.*)$/m)?.[1]?.trim();

  const section = (name) => {
    const start = block.indexOf(`**${name}**`);
    if (start === -1) return "";
    const after = block.slice(start + name.length + 4);
    const end = after.search(/\n\*\*|\n---/);
    return end === -1 ? after : after.slice(0, end);
  };

  const ingredients = section("Ingrédients")
    .split("\n")
    .map((line) => line.match(/^-\s+(.*)$/)?.[1]?.trim())
    .filter(Boolean)
    .map(parseIngredient)
    .filter((item) => item.nom);

  const etapes = section("Préparation")
    .split("\n")
    .map((line) => line.match(/^\d+\.\s+(.*)$/)?.[1]?.trim())
    .filter(Boolean);

  if (ingredients.length === 0) warnings.push(`${titre} : aucun ingrédient`);
  if (etapes.length === 0) warnings.push(`${titre} : aucune étape`);

  const etiquettes = ["Jow"];
  if ((total ?? (preparation ?? 0) + (cuisson ?? 0)) <= 20) etiquettes.push("Express");
  if (/four|enfournez/i.test(block)) etiquettes.push("Four");
  if (/air-fryer/i.test(block)) etiquettes.push("Air fryer");

  recipes.push({
    titre,
    description: [stats, platEntier ? `Plat entier : ${portions} parts.` : null]
      .filter(Boolean)
      .join(" · "),
    lien,
    photo,
    portions,
    platEntier,
    preparation,
    cuisson,
    etiquettes,
    ingredients,
    etapes,
  });
}

const outputPath = inputPath.replace(/\.md$/i, "") + ".json";
await writeFile(outputPath, JSON.stringify(recipes, null, 2) + "\n", "utf8");

for (const warning of warnings) console.log(`⚠ ${warning}`);
console.log(
  `✓ ${recipes.length} recette(s) → ${outputPath}` +
    ` (${recipes.reduce((n, r) => n + r.ingredients.length, 0)} ingrédients,` +
    ` ${recipes.reduce((n, r) => n + r.etapes.length, 0)} étapes)`,
);
