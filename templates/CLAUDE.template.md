# {{PROJECT_NAME}}

Projet créé avec le harnais « mon-harnais ». Claude Code doit suivre ces conventions à CHAQUE interaction.

## Stack

Next.js (App Router) + TypeScript + tRPC + Drizzle + Tailwind + shadcn/ui. Déploiement Vercel, base Neon (EU).
{{STACK_NOTES}}

## Design

- Lire `globals.css` avant de créer un composant ; utiliser les variables CSS, jamais les couleurs Tailwind par défaut.
- Police : Inter via next/font (sauf demande contraire).
- Toujours chercher un composant shadcn/ui avant d'en créer un sur mesure.
- Mobile-first : tout composant doit fonctionner sur mobile (< 640 px) et desktop.
- `cursor-pointer` sur tous les éléments cliquables.

## Code

- TypeScript strict : jamais de `any`, tout est typé.
- Images : toujours `<Image>` de next/image avec un `alt` descriptif.
- Feedback utilisateur : toast shadcn/sonner, jamais `alert()`.
- Si base de données : UI optimiste (mettre à jour l'interface immédiatement, synchroniser en arrière-plan).
- Tout envoi d'email passe par le helper `src/server/email/index.ts`.

## Sécurité

- Jamais de secret en clair dans le code ou un commit ; tout passe par `.env.local` + Vercel env.
- `.env.example` tenu à jour à chaque nouvelle variable.
- Valider les entrées utilisateur côté serveur (zod dans les routes tRPC).

## Workflow

- Git : ne JAMAIS pousser sans demande explicite de l'utilisateur.
- Tâche complexe (3 fichiers ou plus) : créer une todo liste numérotée avec progression ✅/⏳.
- Expliquer chaque choix technique en français simple, sans jargon.
- Après toute modification déployée : vérifier que le site répond en production.
