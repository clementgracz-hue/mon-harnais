-- Validation des repas : un repas reste au planning tant qu'il n'a pas été
-- cuisiné, même si un nouveau Drive est arrivé entre-temps.
--
-- Extrait de schema.sql, pour une base déjà installée. Rejouable.

alter table public.shopping_run_recipes add column if not exists cooked_at timestamptz;
alter table public.shopping_run_recipes add column if not exists cooked_by text;

create index if not exists shopping_run_recipes_todo_idx
  on public.shopping_run_recipes (cooked_at)
  where cooked_at is null;

-- Contrôle : les repas encore à cuisiner, commande par commande.
select r.week_number,
       r.created_at::date as commande,
       count(*) filter (where s.cooked_at is null) as a_cuisiner,
       count(*) filter (where s.cooked_at is not null) as cuisines
  from public.shopping_run_recipes s
  join public.shopping_runs r on r.id = s.run_id
 group by r.id, r.week_number, r.created_at
 order by r.created_at desc;
