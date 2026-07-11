---
description: Ajoute la connexion / inscription (NextAuth v5) au projet
---

Tu vas ajouter l'authentification au projet courant. Procédure stricte :

## Étape 0 — Choix du mode

Demande à l'utilisateur de choisir :
- **Mode admin** : une seule interface protégée par mot de passe (pas d'inscription publique). Pour les back-offices.
- **Mode utilisateurs** : inscription + connexion publiques (email + mot de passe), page compte, suppression de compte.

Prérequis : une base de données (si absente, exécute d'abord la procédure de /add-db).

## Étape 1 — Installation

1. `pnpm add next-auth@beta @auth/drizzle-adapter bcryptjs`
2. Génère `AUTH_SECRET` : `npx auth secret` (ou `openssl rand -base64 32`), ajoute-le à `.env.local`, `.env.example` (sans valeur) et Vercel.

## Étape 2 — Configuration

1. Ajoute les tables NextAuth au schéma Drizzle (users, accounts, sessions, verificationTokens).
2. Crée `src/server/auth.ts` avec le provider Credentials (email + mot de passe hashé bcrypt, 12 rounds minimum).
3. Crée les pages : `/login`, et en mode utilisateurs `/signup` + `/account` (avec suppression de compte).
4. Protège les routes privées via le middleware Next.js (redirection vers /login).

## Étape 3 — Vérification

1. `pnpm db:push` puis teste le parcours complet en local : inscription (ou création admin), connexion, accès page protégée, déconnexion.
2. Vérifie que les mots de passe ne sont JAMAIS loggés ni stockés en clair.
3. Redéploie et reteste en production.

## Extensions optionnelles

Si l'utilisateur veut « Se connecter avec Google/GitHub », propose de créer plus tard une commande dédiée (/add-google-auth, /add-github-auth) sur le même modèle : création de l'app OAuth guidée clic par clic, ajout du provider, variables d'env poussées sur Vercel.

## Règles

- Hash bcrypt obligatoire, jamais de mot de passe en clair.
- Messages d'erreur de connexion volontairement vagues (« identifiants incorrects ») pour ne pas révéler si un email existe.
- Rate limiting simple sur le login si le projet est public.
