---
description: Ajoute une base de données PostgreSQL (Neon) + Drizzle ORM au projet
---

Tu vas ajouter une base de données au projet courant. Procédure stricte :

## Étape 1 — Provisionner Neon

1. Vérifie si la CLI Neon est installée (`neonctl --version`), sinon installe-la : `pnpm add -g neonctl`.
2. Vérifie la connexion (`neonctl me`), sinon guide l'utilisateur : `neonctl auth`.
3. Crée le projet Neon en région EU : `neonctl projects create --name <nom-du-projet> --region-id aws-eu-central-1`.
4. Récupère la chaîne de connexion : `neonctl connection-string`.

## Étape 2 — Brancher Drizzle

1. Installe les dépendances : `pnpm add drizzle-orm @neondatabase/serverless` et `pnpm add -D drizzle-kit`.
2. Crée `src/server/db/schema.ts` avec les tables déduites du besoin de l'utilisateur (VALIDE le schéma avec lui avant : liste les tables et colonnes en français simple).
3. Crée `drizzle.config.ts` et le client dans `src/server/db/index.ts`.
4. Ajoute les scripts `db:push` et `db:studio` au package.json.

## Étape 3 — Variables d'environnement

1. Ajoute `DATABASE_URL` dans `.env.local` (jamais commité) et dans `.env.example` (sans la valeur).
2. Pousse la variable sur Vercel : `vercel env add DATABASE_URL production` (+ preview et development).

## Étape 4 — Vérification

1. Applique le schéma : `pnpm db:push`.
2. Écris un test rapide de lecture/écriture (script jetable ou tRPC route) et vérifie qu'il passe.
3. Explique à l'utilisateur en français simple : où vivent ses données, comment voir ses tables (`pnpm db:studio`), et que la DB est en Europe (Francfort).

## Règles

- Toujours Neon région `aws-eu-central-1` (données en UE).
- Jamais de SQL brut dans le code applicatif : toujours passer par Drizzle.
- Jamais de secret en clair dans un fichier commité.
