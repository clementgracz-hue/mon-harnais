/**
 * Installe le schéma et les comptes dans un projet Supabase existant, via
 * l'API Management — sans passer par le SQL Editor.
 *
 *   SUPABASE_ACCESS_TOKEN=sbp_xxx node scripts/setup-supabase.mjs
 *
 * Le jeton se crée sur https://supabase.com/dashboard/account/tokens
 * (« Generate new token »). Il n'est jamais écrit sur le disque.
 *
 * Variables reconnues :
 *   SUPABASE_ACCESS_TOKEN   (requis) jeton personnel `sbp_…`
 *   SUPABASE_PROJECT_REF    (optionnel) réf du projet ; déduite s'il n'y en a qu'un
 *   SUPABASE_API_URL        (optionnel) surcharge de l'API, pour les tests
 *
 * Options :
 *   --dry-run    montre ce qui serait exécuté, sans rien envoyer
 *   --no-env     n'écrit pas .env.local
 *
 * Les deux scripts SQL sont rejouables : relancer cette commande est sans
 * risque si elle échoue en cours de route.
 */
import { readFile, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const API = (process.env.SUPABASE_API_URL ?? "https://api.supabase.com").replace(/\/$/, "");
const TOKEN = process.env.SUPABASE_ACCESS_TOKEN;
const DRY_RUN = process.argv.includes("--dry-run");
const NO_ENV = process.argv.includes("--no-env");

const STEPS = [
  { file: "supabase/schema.sql", label: "Tables, RLS, Realtime, bucket photos" },
  { file: "supabase/seed-users.sql", label: "Comptes Clément et Mathilde" },
];

function fail(message) {
  console.error(`\n✗ ${message}\n`);
  process.exit(1);
}

/** Panne réseau : DNS bloqué, hors ligne, ou proxy d'un bac à sable. */
function failOffline(cause) {
  const proxy = process.env.HTTPS_PROXY ?? process.env.https_proxy;
  fail(
    `${API} est injoignable depuis cette machine (${cause}).\n\n` +
      "  Le script n'a pas atteint le réseau — rien n'a été envoyé.\n" +
      (proxy
        ? `  Un proxy est configuré (${proxy}), or fetch() de Node ne l'utilise pas.\n` +
          "  Relance la commande hors de l'environnement cloisonné.\n\n"
        : "  Vérifie l'accès :  curl -I https://api.supabase.com\n\n") +
      "  Sinon, passe par le SQL Editor du dashboard : ouvre supabase/schema.sql\n" +
      "  puis supabase/seed-users.sql, copie leur contenu, colle, Run.",
  );
}

async function api(path, options = {}) {
  let response;
  try {
    response = await fetch(`${API}${path}`, {
      ...options,
      headers: {
        Authorization: `Bearer ${TOKEN}`,
        "Content-Type": "application/json",
        ...options.headers,
      },
    });
  } catch (error) {
    failOffline(error?.cause?.code ?? error?.code ?? "fetch failed");
  }

  const body = await response.text();
  if (!response.ok) {
    fail(`${options.method ?? "GET"} ${path} → HTTP ${response.status}\n  ${body.slice(0, 500)}`);
  }
  return body ? JSON.parse(body) : null;
}

/** Réf du projet : celle fournie, sinon l'unique projet du compte. */
async function resolveProjectRef() {
  if (process.env.SUPABASE_PROJECT_REF) return process.env.SUPABASE_PROJECT_REF;

  const projects = await api("/v1/projects");
  if (!Array.isArray(projects) || projects.length === 0) {
    fail("Aucun projet sur ce compte. Crée-le d'abord sur supabase.com.");
  }
  if (projects.length > 1) {
    const list = projects
      .map((project) => `  ${project.id}  ${project.name} (${project.region})`)
      .join("\n");
    fail(
      `Plusieurs projets trouvés, précise lequel :\n${list}\n\n` +
        "  SUPABASE_PROJECT_REF=<réf> node scripts/setup-supabase.mjs",
    );
  }

  console.log(`Projet : ${projects[0].name} (${projects[0].id})`);
  return projects[0].id;
}

/** Clé anon (ou publishable) du projet, pour remplir .env.local. */
async function fetchAnonKey(ref) {
  try {
    const keys = await api(`/v1/projects/${ref}/api-keys?reveal=true`);
    const anon = (Array.isArray(keys) ? keys : []).find(
      (key) => key.name === "anon" || key.type === "publishable",
    );
    return anon?.api_key ?? anon?.api_key_id ?? null;
  } catch {
    return null; // clé masquée ou endpoint indisponible : on le dira à l'écran
  }
}

async function main() {
  if (!TOKEN && !DRY_RUN) {
    fail(
      "SUPABASE_ACCESS_TOKEN manquant.\n" +
        "  Crée un jeton sur https://supabase.com/dashboard/account/tokens puis :\n" +
        "  SUPABASE_ACCESS_TOKEN=sbp_xxx node scripts/setup-supabase.mjs",
    );
  }

  const ref = DRY_RUN
    ? (process.env.SUPABASE_PROJECT_REF ?? "<réf-du-projet>")
    : await resolveProjectRef();

  for (const [index, step] of STEPS.entries()) {
    const sql = await readFile(join(ROOT, step.file), "utf8");
    const numero = `${index + 1}/${STEPS.length}`;

    if (DRY_RUN) {
      console.log(`[${numero}] ${step.file} — ${sql.length} caractères — ${step.label}`);
      continue;
    }

    process.stdout.write(`[${numero}] ${step.file} … `);
    const result = await api(`/v1/projects/${ref}/database/query`, {
      method: "POST",
      body: JSON.stringify({ query: sql }),
    });
    const rows = Array.isArray(result) ? result.length : 0;
    console.log(`ok${rows ? ` (${rows} ligne${rows > 1 ? "s" : ""})` : ""}`);
  }

  if (DRY_RUN) {
    console.log("\n--dry-run : rien n'a été envoyé.");
    return;
  }

  const url = `https://${ref}.supabase.co`;
  const anonKey = await fetchAnonKey(ref);

  console.log("\n✓ Base prête.\n");
  console.log(`  NEXT_PUBLIC_SUPABASE_URL=${url}`);
  console.log(
    `  NEXT_PUBLIC_SUPABASE_ANON_KEY=${anonKey ?? "<à copier depuis Project Settings > API>"}`,
  );

  if (!NO_ENV && anonKey) {
    const envPath = join(ROOT, ".env.local");
    await writeFile(
      envPath,
      `NEXT_PUBLIC_SUPABASE_URL=${url}\nNEXT_PUBLIC_SUPABASE_ANON_KEY=${anonKey}\n`,
      "utf8",
    );
    console.log(`\n  → écrit dans ${envPath}`);
  }

  console.log(
    "\n  Comptes créés : voir Authentication > Users.\n" +
      "  Pense à changer les mots de passe provisoires.\n",
  );
}

await main();
