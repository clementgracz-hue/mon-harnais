-- ============================================================================
--  Menus & Courses — schéma Supabase (PostgreSQL)
--  À exécuter dans Supabase Studio > SQL Editor (ou `supabase db push`).
--  Idempotent : peut être rejoué sans casser l'existant.
-- ============================================================================

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
--  Rayons du Leclerc Drive (ordre = ordre de parcours dans le Drive)
-- ---------------------------------------------------------------------------
do $$
begin
  if not exists (select 1 from pg_type where typname = 'aisle_category') then
    create type aisle_category as enum (
      'Fruits & Légumes',
      'Boucherie & Volaille',
      'Poissonnerie',
      'Crémerie',
      'Traiteur & Charcuterie',
      'Surgelés',
      'Épicerie salée',
      'Épicerie sucrée',
      'Pain & Pâtisserie',
      'Boissons',
      'Bébé',
      'Hygiène & Beauté',
      'Entretien & Maison',
      'Animalerie',
      'Autres'
    );
  end if;
end
$$;

-- ---------------------------------------------------------------------------
--  1. recipes
-- ---------------------------------------------------------------------------
create table if not exists public.recipes (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  description text,
  image_url   text,                                   -- photo (Supabase Storage ou URL externe)
  source_url  text,                                   -- lien d'origine (Jow, blog…)
  prep_time   integer check (prep_time  >= 0),        -- minutes
  cook_time   integer check (cook_time  >= 0),        -- minutes
  rating      numeric(2,1) check (rating between 0 and 5),  -- moyenne des notes (trigger)
  tags        text[] not null default '{}',           -- ex: {Express, "Végé Soir Enfant", Saison}
  created_at  timestamptz not null default now()
);

-- Bases créées avant l'ajout de la colonne.
alter table public.recipes add column if not exists source_url text;

create index if not exists recipes_tags_idx  on public.recipes using gin (tags);
create index if not exists recipes_title_idx on public.recipes (lower(title));

-- ---------------------------------------------------------------------------
--  2. recipe_ingredients
-- ---------------------------------------------------------------------------
create table if not exists public.recipe_ingredients (
  id             uuid primary key default gen_random_uuid(),
  recipe_id      uuid not null references public.recipes (id) on delete cascade,
  name           text not null,
  quantity       numeric(10,2),                       -- null = "selon goût"
  unit           text,                                -- g, kg, ml, cl, L, c. à s., pièce…
  aisle_category aisle_category not null default 'Autres',
  position       integer not null default 0
);

create index if not exists recipe_ingredients_recipe_idx on public.recipe_ingredients (recipe_id);

-- ---------------------------------------------------------------------------
--  3. recipe_steps
-- ---------------------------------------------------------------------------
create table if not exists public.recipe_steps (
  id          uuid primary key default gen_random_uuid(),
  recipe_id   uuid not null references public.recipes (id) on delete cascade,
  step_number integer not null check (step_number > 0),
  instruction text not null,
  unique (recipe_id, step_number)
);

create index if not exists recipe_steps_recipe_idx on public.recipe_steps (recipe_id, step_number);

-- ---------------------------------------------------------------------------
--  3bis. recipe_comments — notation (1 à 5 étoiles) + commentaires
--  (table additionnelle : la colonne recipes.rating stocke la moyenne)
-- ---------------------------------------------------------------------------
create table if not exists public.recipe_comments (
  id         uuid primary key default gen_random_uuid(),
  recipe_id  uuid not null references public.recipes (id) on delete cascade,
  author     text not null default 'Nous',
  rating     smallint check (rating between 1 and 5),
  comment    text,
  created_at timestamptz not null default now()
);

create index if not exists recipe_comments_recipe_idx on public.recipe_comments (recipe_id, created_at desc);

-- Recalcule recipes.rating à chaque insert/update/delete de commentaire noté.
create or replace function public.refresh_recipe_rating()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  target uuid := coalesce(new.recipe_id, old.recipe_id);
begin
  update public.recipes r
     set rating = (
       select round(avg(c.rating)::numeric, 1)
         from public.recipe_comments c
        where c.recipe_id = target and c.rating is not null
     )
   where r.id = target;
  return null;
end;
$$;

drop trigger if exists recipe_comments_refresh_rating on public.recipe_comments;
create trigger recipe_comments_refresh_rating
  after insert or update or delete on public.recipe_comments
  for each row execute function public.refresh_recipe_rating();

-- ---------------------------------------------------------------------------
--  4. staple_products — « fonds de roulement » (produits récurrents)
-- ---------------------------------------------------------------------------
create table if not exists public.staple_products (
  id          uuid primary key default gen_random_uuid(),
  name        text not null unique,
  category    aisle_category not null default 'Autres',
  is_frequent boolean not null default true,   -- mis en avant en tête de liste
  is_selected boolean not null default false,  -- coché pour la liste de courses en cours
  created_at  timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
--  5. shopping_wishlist — pense-bête partagé (temps réel)
-- ---------------------------------------------------------------------------
create table if not exists public.shopping_wishlist (
  id             uuid primary key default gen_random_uuid(),
  item_name      text not null,
  quantity       numeric(10,2),
  unit           text,
  aisle_category aisle_category not null default 'Autres',
  is_checked     boolean not null default false,
  added_by       text,                                -- prénom ou email de l'auteur
  created_at     timestamptz not null default now()
);

create index if not exists shopping_wishlist_created_idx on public.shopping_wishlist (created_at desc);

-- ---------------------------------------------------------------------------
--  6. weekly_menu
-- ---------------------------------------------------------------------------
create table if not exists public.weekly_menu (
  id          uuid primary key default gen_random_uuid(),
  week_number integer not null check (week_number between 1 and 53),
  year        integer not null check (year between 2020 and 2100),
  created_at  timestamptz not null default now(),
  unique (year, week_number)
);

-- ---------------------------------------------------------------------------
--  7. weekly_menu_recipes
-- ---------------------------------------------------------------------------
create table if not exists public.weekly_menu_recipes (
  id                  uuid primary key default gen_random_uuid(),
  menu_id             uuid not null references public.weekly_menu (id) on delete cascade,
  recipe_id           uuid not null references public.recipes (id)     on delete cascade,
  day_assigned        text check (day_assigned in (
                        'lundi','mardi','mercredi','jeudi','vendredi','samedi','dimanche')),
  is_kid_friendly_veg boolean not null default false,  -- true = 100% végétal (repas du soir enfant)
  created_at          timestamptz not null default now(),
  unique (menu_id, recipe_id, day_assigned)
);

create index if not exists weekly_menu_recipes_menu_idx on public.weekly_menu_recipes (menu_id);

-- ============================================================================
--  Realtime — le pense-bête, les récurrents et le menu se synchronisent à deux
-- ============================================================================
do $$
begin
  begin execute 'alter publication supabase_realtime add table public.shopping_wishlist';   exception when duplicate_object then null; end;
  begin execute 'alter publication supabase_realtime add table public.staple_products';     exception when duplicate_object then null; end;
  begin execute 'alter publication supabase_realtime add table public.weekly_menu_recipes'; exception when duplicate_object then null; end;
end
$$;

alter table public.shopping_wishlist   replica identity full;
alter table public.staple_products     replica identity full;
alter table public.weekly_menu_recipes replica identity full;

-- ============================================================================
--  RLS — app privée à 2 comptes : tout utilisateur authentifié a accès complet
-- ============================================================================
alter table public.recipes             enable row level security;
alter table public.recipe_ingredients  enable row level security;
alter table public.recipe_steps        enable row level security;
alter table public.recipe_comments     enable row level security;
alter table public.staple_products     enable row level security;
alter table public.shopping_wishlist   enable row level security;
alter table public.weekly_menu         enable row level security;
alter table public.weekly_menu_recipes enable row level security;

do $$
declare t text;
begin
  foreach t in array array[
    'recipes','recipe_ingredients','recipe_steps','recipe_comments',
    'staple_products','shopping_wishlist','weekly_menu','weekly_menu_recipes'
  ] loop
    execute format('drop policy if exists "authenticated_all" on public.%I', t);
    execute format(
      'create policy "authenticated_all" on public.%I
         for all to authenticated using (true) with check (true)', t);
  end loop;
end
$$;

-- Privilèges explicites : ne dépend pas des default privileges du projet.
-- `anon` (visiteur non connecté) ne reçoit rien : l'app exige une session.
grant usage on schema public to anon, authenticated;
grant all privileges on all tables in schema public to authenticated;
grant all privileges on all sequences in schema public to authenticated;
revoke all privileges on all tables in schema public from anon;

-- ============================================================================
--  Storage — bucket des photos de recettes (privé, lecture/écriture connectés)
-- ============================================================================
insert into storage.buckets (id, name, public)
values ('recipe-photos', 'recipe-photos', true)
on conflict (id) do nothing;

drop policy if exists "recipe_photos_read"  on storage.objects;
drop policy if exists "recipe_photos_write" on storage.objects;

create policy "recipe_photos_read" on storage.objects
  for select using (bucket_id = 'recipe-photos');

create policy "recipe_photos_write" on storage.objects
  for all to authenticated
  using (bucket_id = 'recipe-photos')
  with check (bucket_id = 'recipe-photos');

-- ============================================================================
--  Seed — fonds de roulement de départ
-- ============================================================================
insert into public.staple_products (name, category, is_frequent) values
  ('Jus d''orange',        'Boissons',            true),
  ('Café en grains',       'Épicerie sucrée',     true),
  ('Lait',                 'Crémerie',            true),
  ('Beurre',               'Crémerie',            true),
  ('Œufs',                 'Crémerie',            true),
  ('Pain de mie',          'Pain & Pâtisserie',   true),
  ('Pâtes',                'Épicerie salée',      true),
  ('Riz',                  'Épicerie salée',      true),
  ('Huile d''olive',       'Épicerie salée',      true),
  ('Papier toilette',      'Entretien & Maison',  true),
  ('Liquide vaisselle',    'Entretien & Maison',  true),
  ('Lessive',              'Entretien & Maison',  true),
  ('Couches',              'Bébé',                true),
  ('Lingettes bébé',       'Bébé',                true),
  ('Litière chat',         'Animalerie',          true),
  ('Croquettes chat',      'Animalerie',          true)
on conflict (name) do nothing;
