---
description: Crée un projet web complet (T3) à partir d'une description, puis le déploie sur Vercel
argument-hint: [description du projet]
---

Tu vas créer une application web complète pour l'utilisateur. Description fournie : $ARGUMENTS

Suis STRICTEMENT cette procédure, étape par étape. Ne saute aucune étape. Parle en français simple, sans jargon technique non expliqué.

## Étape 0 — Cadrage

1. Si la description est vide ou floue, pose 3 à 5 questions (une par une) : à quoi sert l'app, qui l'utilise, quelles pages/écrans, faut-il des comptes utilisateurs, faut-il stocker des données.
2. Déduis les addons nécessaires : base de données (/add-db), authentification (/add-auth), emails (/add-email).
3. Présente un plan clair (pages, fonctionnalités, addons retenus) et ATTENDS la validation explicite de l'utilisateur avant de construire.

## Étape 1 — Vérification des prérequis

Vérifie que ces outils sont installés et connectés (sinon guide l'installation) :
- Node.js >= 20 et pnpm (`node -v`, `pnpm -v`)
- Git et l'authentification GitHub (`gh auth status`)
- Vercel CLI connecté (`vercel whoami`)

## Étape 2 — Scaffold T3

1. Crée le projet : `pnpm create t3-app@latest <nom-du-projet> --CI --tailwind --trpc --appRouter --dbProvider postgres` (adapte les flags si l'utilisateur n'a pas besoin de DB).
2. Installe shadcn/ui : `pnpm dlx shadcn@latest init` avec les réponses par défaut.
3. Configure la police Inter via next/font.
4. Copie le template de conventions du harnais (`templates/CLAUDE.template.md`) vers `CLAUDE.md` à la racine du projet, en remplaçant les variables {{PROJECT_NAME}} et {{STACK_NOTES}}.

## Étape 3 — Base commune (toujours, quel que soit le projet)

- SEO de base : metadata dans le layout, `robots.txt`, `sitemap.ts`, image Open Graph placeholder, HTML sémantique.
- Page 404 personnalisée.
- Pages mentions légales et politique de confidentialité (placeholders à compléter).
- `.env.example` documentant chaque variable d'environnement.

## Étape 4 — Addons

Pour chaque addon validé à l'étape 0, exécute la procédure correspondante :
- Base de données → procédure de /add-db
- Authentification → procédure de /add-auth
- Emails → procédure de /add-email

## Étape 5 — GitHub + déploiement

1. `git init`, premier commit.
2. Crée un repo GitHub PRIVÉ : `gh repo create <nom> --private --source=. --push`.
3. Déploie sur Vercel : `vercel link` puis `vercel deploy --prod`. Pousse toutes les variables d'environnement nécessaires avec `vercel env add`.
4. Vérifie que le site répond (HTTP 200) sur l'URL de production.

## Étape 6 — Restitution

Termine par un résumé en français simple :
- L'URL du site en ligne
- Ce qui a été construit (pages, fonctionnalités)
- Où sont les données et les secrets
- Les 3 prochaines actions possibles (ex : ajouter un domaine, ajouter Stripe, itérer sur le design)

## Règles permanentes

- Ne JAMAIS inventer de clé d'API : demande à l'utilisateur de la créer et guide-le clic par clic.
- Ne JAMAIS mettre de secret en clair dans le code ou dans un commit.
- Valider chaque choix structurant avec l'utilisateur avant d'agir.
