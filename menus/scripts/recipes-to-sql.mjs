/**
 * Convertit un fichier de recettes JSON en SQL prêt à coller dans SQL Editor.
 *
 *   npm run recipes:sql -- recipes/mes-recettes.json
 *   → écrit recipes/mes-recettes.sql
 *
 * Le rayon de chaque ingrédient est deviné avec la même fonction que l'app
 * (`guessAisle`), sauf si la recette le précise explicitement.
 *
 * Le SQL produit est rejouable : une recette dont le titre existe déjà est
 * ignorée, jamais dupliquée.
 */
import { readFile, writeFile } from "node:fs/promises";

import { guessAisle, AISLES } from "@/lib/aisles";

const [, , inputPath] = process.argv;

if (!inputPath) {
  console.error(
    "Usage : npm run recipes:sql -- <fichier.json>\n" +
      "Format attendu : voir recipes/exemple.json",
  );
  process.exit(1);
}

// Le fichier est écrit par le script : rediriger la sortie de `npm run`
// mêlerait sa bannière au SQL.
const outputPath = inputPath.replace(/\.json$/i, "") + ".sql";

/** Échappe une valeur pour un littéral SQL, ou renvoie NULL. */
function sql(value) {
  if (value === null || value === undefined || value === "") return "null";
  if (typeof value === "number") return String(value);
  return `'${String(value).replace(/'/g, "''")}'`;
}

function sqlArray(values = []) {
  if (values.length === 0) return "'{}'";
  return `array[${values.map(sql).join(", ")}]`;
}

const recipes = JSON.parse(await readFile(inputPath, "utf8"));
if (!Array.isArray(recipes)) {
  console.error("Le fichier doit contenir un tableau de recettes.");
  process.exit(1);
}

const blocks = [];
const warnings = [];

for (const recipe of recipes) {
  const titre = recipe.titre?.trim();
  if (!titre) {
    warnings.push("Recette sans titre ignorée.");
    continue;
  }

  const ingredients = (recipe.ingredients ?? []).map((ingredient, index) => {
    const nom = ingredient.nom?.trim() ?? "";
    let rayon = ingredient.rayon ?? guessAisle(nom);

    if (!AISLES.includes(rayon)) {
      warnings.push(`${titre} : rayon inconnu « ${rayon} » pour ${nom} → Autres`);
      rayon = "Autres";
    }
    if (!ingredient.rayon && rayon === "Autres") {
      warnings.push(`${titre} : rayon non deviné pour « ${nom} » → à vérifier`);
    }

    return { ...ingredient, nom, rayon, position: index };
  });

  const etapes = (recipe.etapes ?? []).map((instruction) => instruction.trim()).filter(Boolean);

  blocks.push(`
-- ${titre}
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower(${sql(titre)})) then
    raise notice 'Déjà présente, ignorée : %', ${sql(titre)};
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values (${sql(titre)}, ${sql(recipe.description)}, ${sql(recipe.photo)}, ${sql(recipe.lien)},
          ${sql(recipe.preparation ?? null)}, ${sql(recipe.cuisson ?? null)},
          ${sql(recipe.portions ?? 2)}, ${recipe.platEntier ? "true" : "false"},
          ${sqlArray(recipe.etiquettes)})
  returning id into r;
${
  ingredients.length
    ? `
  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
${ingredients
  .map(
    (i) =>
      `    (r, ${sql(i.nom)}, ${sql(i.quantite ?? null)}, ${sql(i.unite ?? null)}, ${sql(i.rayon)}, ${i.position})`,
  )
  .join(",\n")};`
    : ""
}
${
  etapes.length
    ? `
  insert into public.recipe_steps (recipe_id, step_number, instruction) values
${etapes.map((instruction, index) => `    (r, ${index + 1}, ${sql(instruction)})`).join(",\n")};`
    : ""
}
  raise notice 'Ajoutée : %', ${sql(titre)};
end
$$;`);
}

const output = [
  `-- ${blocks.length} recette(s) — généré par scripts/recipes-to-sql.mjs`,
  "-- Rejouable : une recette déjà présente (même titre) est ignorée.",
  "",
  "-- Colonnes ajoutées après la première version du schéma : le fichier",
  "-- s'installe seul, même sur une base qui n'a pas rejoué schema.sql.",
  "alter table public.recipes add column if not exists source_url text;",
  "alter table public.recipes add column if not exists servings integer not null default 2;",
  "alter table public.recipes add column if not exists is_batch boolean not null default false;",
  blocks.join("\n"),
  `
select r.title,
       count(distinct i.id) as ingredients,
       count(distinct s.id) as etapes
from public.recipes r
left join public.recipe_ingredients i on i.recipe_id = r.id
left join public.recipe_steps s on s.recipe_id = r.id
group by r.id, r.title
order by r.title;`,
].join("\n");

await writeFile(outputPath, `${output}\n`, "utf8");

for (const warning of warnings) console.log(`⚠ ${warning}`);
console.log(`✓ ${blocks.length} recette(s) → ${outputPath}`);
