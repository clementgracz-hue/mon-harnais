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

-- Bases créées avant l'ajout des colonnes.
alter table public.recipes add column if not exists source_url text;
-- Nombre de parts pour lequel les quantités sont écrites (Jow : 2).
alter table public.recipes add column if not exists servings integer not null default 2;
-- Plat entier (quiche, cake, tarte) : les quantités ne se divisent pas.
alter table public.recipes add column if not exists is_batch boolean not null default false;

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
  id             uuid primary key default gen_random_uuid(),
  week_number    integer not null check (week_number between 1 and 53),
  year           integer not null check (year between 2020 and 2100),
  -- Convives à table : les quantités du panier sont mises à l'échelle.
  servings       integer not null default 2 check (servings between 1 and 12),
  -- Objectif de repas pour la semaine (5 ou 6 en général).
  target_recipes integer not null default 6 check (target_recipes between 1 and 21),
  created_at     timestamptz not null default now(),
  unique (year, week_number)
);

alter table public.weekly_menu add column if not exists servings integer not null default 2;
alter table public.weekly_menu add column if not exists target_recipes integer not null default 6;

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

-- ---------------------------------------------------------------------------
--  8. shopping_runs — historique des courses passées
--
--  Instantané figé : les libellés et quantités sont recopiés en texte, pour
--  qu'une liste commandée reste consultable même si la recette change ou
--  disparaît ensuite.
-- ---------------------------------------------------------------------------
create table if not exists public.shopping_runs (
  id          uuid primary key default gen_random_uuid(),
  week_number integer not null check (week_number between 1 and 53),
  year        integer not null check (year between 2020 and 2100),
  item_count  integer not null default 0,
  closed_by   text,
  created_at  timestamptz not null default now()
);

create index if not exists shopping_runs_date_idx on public.shopping_runs (created_at desc);

create table if not exists public.shopping_run_items (
  id             uuid primary key default gen_random_uuid(),
  run_id         uuid not null references public.shopping_runs (id) on delete cascade,
  name           text not null,
  amount         text,                                -- « 300 g », « 2 gousses »
  aisle_category aisle_category not null default 'Autres',
  sources        text[] not null default '{}',        -- recette / pense-bête / récurrent
  position       integer not null default 0
);

create index if not exists shopping_run_items_run_idx on public.shopping_run_items (run_id, position);

create table if not exists public.shopping_run_recipes (
  id                  uuid primary key default gen_random_uuid(),
  run_id              uuid not null references public.shopping_runs (id) on delete cascade,
  -- La recette peut être supprimée plus tard : le titre reste, le lien saute.
  recipe_id           uuid references public.recipes (id) on delete set null,
  title               text not null,
  day_assigned        text,
  is_kid_friendly_veg boolean not null default false
);

create index if not exists shopping_run_recipes_run_idx on public.shopping_run_recipes (run_id);

-- Un repas reste au planning tant qu'il n'a pas été cuisiné, même si un
-- nouveau Drive est arrivé entre-temps.
alter table public.shopping_run_recipes add column if not exists cooked_at timestamptz;
alter table public.shopping_run_recipes add column if not exists cooked_by text;

create index if not exists shopping_run_recipes_todo_idx
  on public.shopping_run_recipes (cooked_at)
  where cooked_at is null;

-- ---------------------------------------------------------------------------
--  Clôture des courses, en une transaction
--
--  Archive la liste et les repas de la semaine, puis vide le panier :
--  pense-bête soldé, récurrents désactivés, repas de la semaine retirés.
-- ---------------------------------------------------------------------------
create or replace function public.close_shopping_run(payload jsonb)
returns uuid
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_week integer := (payload->>'week')::integer;
  v_year integer := (payload->>'year')::integer;
  v_items jsonb  := coalesce(payload->'items', '[]'::jsonb);
  v_run  uuid;
  v_menu uuid;
begin
  insert into public.shopping_runs (week_number, year, closed_by, item_count)
  values (v_week, v_year, payload->>'closed_by', jsonb_array_length(v_items))
  returning id into v_run;

  insert into public.shopping_run_items (run_id, name, amount, aisle_category, sources, position)
  select
    v_run,
    entry.item->>'name',
    nullif(entry.item->>'amount', ''),
    -- Un rayon inconnu ne doit pas faire échouer l'archivage.
    case
      when entry.item->>'aisle' = any (enum_range(null::aisle_category)::text[])
        then (entry.item->>'aisle')::aisle_category
      else 'Autres'
    end,
    coalesce(array(select jsonb_array_elements_text(entry.item->'sources')), '{}'),
    entry.ordinality - 1
  from jsonb_array_elements(v_items) with ordinality as entry(item, ordinality)
  where coalesce(entry.item->>'name', '') <> '';

  select id into v_menu
    from public.weekly_menu
   where week_number = v_week and year = v_year;

  if v_menu is not null then
    insert into public.shopping_run_recipes
      (run_id, recipe_id, title, day_assigned, is_kid_friendly_veg)
    select v_run, r.id, coalesce(r.title, 'Recette supprimée'),
           m.day_assigned, m.is_kid_friendly_veg
      from public.weekly_menu_recipes m
      left join public.recipes r on r.id = m.recipe_id
     where m.menu_id = v_menu;

    delete from public.weekly_menu_recipes where menu_id = v_menu;
  end if;

  update public.shopping_wishlist set is_checked  = true  where is_checked  = false;
  update public.staple_products   set is_selected = false where is_selected = true;

  return v_run;
end;
$$;

-- ---------------------------------------------------------------------------
--  9. pantry_items — le frigo : ce qui est rangé et jusqu'à quand
--
--  Rempli au retour du Drive depuis une liste archivée. La date de péremption
--  sert à ordonner les repas de la semaine et à prévenir avant qu'il ne soit
--  trop tard.
-- ---------------------------------------------------------------------------
create table if not exists public.pantry_items (
  id             uuid primary key default gen_random_uuid(),
  name           text not null,
  aisle_category aisle_category not null default 'Autres',
  expires_on     date,
  amount         text,
  -- Course d'origine, pour ne pas ranger deux fois la même liste.
  run_id         uuid references public.shopping_runs (id) on delete set null,
  is_used        boolean not null default false,
  created_at     timestamptz not null default now()
);

create index if not exists pantry_items_expiry_idx on public.pantry_items (expires_on)
  where is_used = false;
create index if not exists pantry_items_run_idx on public.pantry_items (run_id);

-- ============================================================================
--  Realtime — le pense-bête, les récurrents et le menu se synchronisent à deux
-- ============================================================================
do $$
begin
  begin execute 'alter publication supabase_realtime add table public.shopping_wishlist';   exception when duplicate_object then null; end;
  begin execute 'alter publication supabase_realtime add table public.staple_products';     exception when duplicate_object then null; end;
  begin execute 'alter publication supabase_realtime add table public.weekly_menu_recipes'; exception when duplicate_object then null; end;
  begin execute 'alter publication supabase_realtime add table public.pantry_items';        exception when duplicate_object then null; end;
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
alter table public.shopping_runs        enable row level security;
alter table public.shopping_run_items   enable row level security;
alter table public.shopping_run_recipes enable row level security;
alter table public.pantry_items          enable row level security;

do $$
declare t text;
begin
  foreach t in array array[
    'recipes','recipe_ingredients','recipe_steps','recipe_comments',
    'staple_products','shopping_wishlist','weekly_menu','weekly_menu_recipes',
    'shopping_runs','shopping_run_items','shopping_run_recipes','pantry_items'
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
grant execute on function public.close_shopping_run(jsonb) to authenticated;

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
--
--  Uniquement sur une base neuve : une liste déjà tenue à la main ne doit pas
--  se voir réimposer les valeurs d'usine à chaque rejeu du schéma.
-- ============================================================================
insert into public.staple_products (name, category, is_frequent)
select seed.name, seed.category::aisle_category, true
  from (values
    ('Jus d''orange',        'Boissons'),
    ('Café en grains',       'Épicerie sucrée'),
    ('Lait',                 'Crémerie'),
    ('Beurre',               'Crémerie'),
    ('Œufs',                 'Crémerie'),
    ('Pain de mie',          'Pain & Pâtisserie'),
    ('Pâtes',                'Épicerie salée'),
    ('Riz',                  'Épicerie salée'),
    ('Huile d''olive',       'Épicerie salée'),
    ('Papier toilette',      'Entretien & Maison'),
    ('Liquide vaisselle',    'Entretien & Maison'),
    ('Lessive',              'Entretien & Maison'),
    ('Couches',              'Bébé'),
    ('Lingettes bébé',       'Bébé'),
    ('Litière chat',         'Animalerie'),
    ('Croquettes chat',      'Animalerie')
  ) as seed(name, category)
 where not exists (select 1 from public.staple_products);
