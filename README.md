# mon-harnais

Harnais de création d'apps web pour Claude Code, inspiré de [Hypervibe](https://github.com/flavien-ia/hypervibe-harness) (Flavien Chervet).

Stack imposée : **Next.js (App Router) + TypeScript + tRPC + Drizzle + Tailwind + shadcn/ui**, déployé sur **Vercel** avec base **Neon** (PostgreSQL, EU).

## Installation

1. Pousser ce dossier sur GitHub (repo public ou privé) :

```bash
git init
git add .
git commit -m "Initial harness"
gh repo create mon-harnais --public --source=. --push
```

2. Dans Claude Code :

```
/plugin marketplace add <ton-user-github>/mon-harnais
/plugin install mon-harnais@mon-harnais
```

Pour tester en local sans passer par GitHub :

```bash
claude --plugin-dir ./mon-harnais
```

## Commandes

| Commande | Effet |
| --- | --- |
| `/bootstrap <description>` | Crée un projet T3 complet, repo GitHub, déploiement Vercel |
| `/add-db` | Base PostgreSQL Neon (EU) + Drizzle ORM |
| `/add-auth` | Connexion / inscription NextAuth v5 (mode admin ou utilisateurs) |
| `/add-email` | Emails transactionnels via Resend |
| `/add-ci` | CI GitHub Actions (lint + typecheck + build sur chaque PR/push, merge bloqué si échec) + CD Vercel via git push |

Chaque commande est une procédure stricte dans `commands/`. Le fichier `templates/CLAUDE.template.md` est copié dans chaque projet créé : ce sont les conventions que Claude suivra ensuite à chaque interaction.

## Étendre le harnais

À chaque fois que tu ré-expliques la même chose à Claude, transforme l'explication en commande :

1. Crée `commands/ma-commande.md` avec un frontmatter `description:` et une procédure numérotée.
2. Termine toujours par une étape de vérification (tester, déployer, confirmer).
3. Ajoute les règles permanentes (sécurité, conventions) en fin de fichier.

Idées de prochaines commande