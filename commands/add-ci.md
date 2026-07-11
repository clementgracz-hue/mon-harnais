---
description: Ajoute l'intégration continue (GitHub Actions) au projet - lint, typecheck et build vérifiés avant chaque merge
---

Tu vas ajouter la CI au projet courant. Procédure stricte :

## Étape 1 — Workflow GitHub Actions

Crée `.github/workflows/ci.yml` :

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: pnpm
      - run: pnpm install --frozen-lockfile
      - run: pnpm lint
      - run: pnpm typecheck
      - run: pnpm build
        env:
          SKIP_ENV_VALIDATION: "1"
```

Adapte les jobs aux scripts réellement présents dans le package.json (ajoute `typecheck: tsc --noEmit` s'il manque). Si le projet a des tests, ajoute `pnpm test` après le typecheck.

## Étape 2 — Protéger la branche main

Guide l'utilisateur clic par clic (nécessite l'interface GitHub) :
GitHub → Settings → Branches → Add branch ruleset → cible `main` → activer « Require status checks to pass » et sélectionner le job `verify`.

Explique en français simple : plus aucun code cassé ne peut être fusionné sur main.

## Étape 3 — Déploiement continu propre (Vercel)

1. Vérifie que le projet Vercel est connecté au repo GitHub (`vercel git connect` si besoin). Ainsi : chaque push sur main = déploiement production automatique, chaque PR = URL de preview.
2. Recommande le workflow : ne plus jamais utiliser `vercel deploy --prod` à la main ; tout passe par git push.

## Étape 4 — Vérification

1. Commit et push le workflow (avec l'accord de l'utilisateur).
2. Attends la fin du run sur GitHub Actions (`https://github.com/<user>/<repo>/actions`) et vérifie qu'il est vert.
3. Si le run échoue, corrige les erreurs de lint/typecheck AVANT de terminer : la CI doit être verte à la livraison.

## Règles

- La CI ne doit jamais contenir de secret : le build utilise SKIP_ENV_VALIDATION.
- Ne jamais désactiver un check pour « faire passer » un merge.
- Tout nouveau script de qualité (tests, audit) doit être ajouté au workflow.
