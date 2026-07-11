---
description: Ajoute l'envoi d'emails transactionnels (Resend) au projet
---

Tu vas ajouter l'envoi d'emails au projet courant. Procédure stricte :

## Étape 1 — Compte et clé API

1. Demande à l'utilisateur s'il a déjà un compte Resend. Sinon, guide-le clic par clic : https://resend.com → créer un compte (gratuit : 100 emails/jour) → API Keys → Create API Key.
2. Ajoute `RESEND_API_KEY` à `.env.local`, `.env.example` (sans valeur) et Vercel (`vercel env add`).

## Étape 2 — Intégration

1. `pnpm add resend react-email @react-email/components`
2. Crée `src/server/email/index.ts` : un helper `sendEmail({ to, subject, react })` unique — tout envoi d'email du projet passe par lui.
3. Crée les templates dans `src/server/email/templates/` (React Email) : commence par un template de base aux couleurs du projet.
4. Expéditeur par défaut : `onboarding@resend.dev` tant qu'aucun domaine n'est vérifié. Si l'utilisateur a un domaine, guide la vérification DNS dans Resend puis utilise `noreply@son-domaine.fr`.

## Étape 3 — Vérification

1. Envoie un email de test à l'adresse de l'utilisateur et demande-lui de confirmer la réception.
2. Vérifie que les erreurs d'envoi sont catchées et loggées sans faire planter l'app.

## Règles

- Tout envoi passe par le helper unique, jamais d'appel direct à l'API dans les composants.
- Jamais d'email sans action utilisateur ou justification claire (pas de spam).
- Les emails contenant des liens sensibles (reset de mot de passe) expirent en 1 heure maximum.
