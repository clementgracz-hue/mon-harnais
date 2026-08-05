# Menus & Courses

PWA mobile-first partagée à deux : nos repas de la semaine, nos recettes, et la
liste de courses prête à saisir sur le Leclerc Drive.

**Stack** — Next.js 15 (App Router) · TypeScript · Tailwind CSS · shadcn/ui ·
Lucide · Supabase (PostgreSQL + Auth + Realtime) · `@ducanh2912/next-pwa` ·
déploiement Vercel.

## Démarrage

```bash
npm install
cp .env.example .env.local   # puis renseigner l'URL et la clé anon Supabase
npm run dev
```

### 1. Base de données

Dans Supabase Studio → **SQL Editor**, exécuter `supabase/schema.sql`. Le script
est idempotent : il crée les tables, les politiques RLS, la publication Realtime,
le bucket de photos et un fonds de roulement de départ.

Le schéma a été vérifié sur PostgreSQL 16 : exécution deux fois de suite sans
erreur, moyenne des notes recalculée par trigger, suppression d'une recette qui
emporte ingrédients, étapes, avis et repas planifiés, et RLS refusant l'accès à
un visiteur non connecté.

### 2. Comptes

L'app est privée : toute route hors `/login` passe par le middleware. Créer les
deux comptes dans **Authentication → Users** (email + mot de passe). Les
politiques RLS donnent un accès complet à tout utilisateur authentifié — c'est
volontaire pour une app de couple, à revoir si elle s'ouvre à d'autres foyers.

### 3. Déploiement Vercel

Le projet vit dans le sous-dossier `menus/` du dépôt : régler **Root Directory =
`menus`** dans les réglages Vercel, puis ajouter `NEXT_PUBLIC_SUPABASE_URL` et
`NEXT_PUBLIC_SUPABASE_ANON_KEY` aux variables d'environnement.

## Structure

```
menus/
├── supabase/schema.sql        # schéma complet + RLS + Realtime + seed
├── public/
│   ├── manifest.json          # manifeste PWA (icônes, raccourcis)
│   └── icons/                 # icônes 192/512 + maskable + apple-touch
├── scripts/generate-icons.mjs # régénère les icônes (npm run icons)
├── tests/                     # tests unitaires (node --test)
└── src/
    ├── middleware.ts          # rafraîchit la session, protège les routes
    ├── app/
    │   ├── page.tsx                      # planificateur de la semaine
    │   ├── recettes/                     # catalogue, fiche, édition, cuisine
    │   ├── pense-bete/                   # pense-bête + fonds de roulement
    │   ├── courses/                      # liste consolidée & export Drive
    │   ├── login/ · offline/ · not-found.tsx
    │   └── auth/signout/route.ts
    ├── components/
    │   ├── bottom-nav.tsx     # navigation mobile (compteur temps réel)
    │   ├── recipe-card.tsx    # carte de recette
    │   ├── recipe-form.tsx    # formulaire partagé création / édition
    │   ├── image-upload.tsx   # photo → Supabase Storage
    │   ├── cook-mode.tsx      # plein écran, cases à cocher, wake lock
    │   ├── wishlist.tsx       # pense-bête Realtime
    │   ├── shopping-list.tsx  # liste de courses + « Copier » + clôture
    │   └── ui/                # primitives shadcn/ui
    └── lib/
        ├── supabase/          # client navigateur, serveur, middleware
        ├── aisles.ts          # rayons du Drive + détection auto
        ├── shopping.ts        # consolidation des doublons + export texte
        ├── veg.ts             # détection des produits animaux
        └── types/database.ts  # types de la base
```

## Fonctionnement

**Consolidation des courses** (`src/lib/shopping.ts`) — les ingrédients des
recettes de la semaine, le pense-bête et les récurrents cochés sont fusionnés par
nom normalisé (casse, accents, pluriel). Les quantités ne s'additionnent que dans
une même dimension : 200 g + 100 g + 0,5 kg = **800 g**, 50 cl + 1 L = **1,5 L**,
mais « 2 gousses » et « 1 pièce » d'ail restent affichées côte à côte. Le résultat
est trié dans l'ordre de parcours du Drive.

**Export Drive** — le bouton « Copier » produit un texte brut d'une ligne par
article, groupé par rayon, sans les articles déjà cochés. Les cases cochées sont
gardées en `localStorage` par semaine : la saisie sur le Drive peut se faire en
plusieurs fois.

**Clôture des courses** — le bouton « Courses terminées » solde le pense-bête et
désactive les produits récurrents, pour repartir d'une liste vide la semaine
suivante.

**Temps réel** — `shopping_wishlist`, `staple_products` et `weekly_menu_recipes`
sont publiées via Supabase Realtime : un produit ajouté sur un téléphone apparaît
immédiatement sur l'autre, y compris le compteur de la barre de navigation.

**Détection des rayons** (`src/lib/aisles.ts`) — chaque libellé est comparé à des
mots-clés en mots entiers, accents et pluriels tolérés, y compris au milieu d'un
libellé (« Petits pois »). L'ordre des rayons tranche les ambiguïtés : « jus
d'orange » part en Boissons, « lait de coco » en Épicerie salée.

**Repas végétal** (`src/lib/veg.ts`) — un repas est proposé comme 100% végétal
quand aucun ingrédient ne vient d'un rayon animal (boucherie, poissonnerie,
traiteur, crémerie) ni ne porte un nom de produit animal rangé ailleurs (thon en
conserve, miel…), les alternatives végétales étant épargnées (lait de coco, crème
de soja). C'est une proposition : le drapeau reste modifiable sur chaque repas.

## Scripts

| Commande | Effet |
| --- | --- |
| `npm run dev` | Serveur de développement (PWA désactivée) |
| `npm run build` | Build de production + génération du service worker |
| `npm run lint` | ESLint |
| `npm run typecheck` | `tsc --noEmit` |
| `npm test` | Tests unitaires (consolidation, rayons, végétal, semaine ISO) |
| `npm run icons` | Régénère les icônes PWA |

La CI GitHub Actions (`.github/workflows/menus-ci.yml`) rejoue lint, typecheck,
tests et build à chaque push touchant `menus/`.
