-- 3 recette(s) — généré par scripts/recipes-to-sql.mjs
-- Rejouable : une recette déjà présente (même titre) est ignorée.

-- Colonnes ajoutées après la première version du schéma : le fichier
-- s'installe seul, même sur une base qui n'a pas rejoué schema.sql.
alter table public.recipes add column if not exists source_url text;
alter table public.recipes add column if not exists servings integer not null default 2;
alter table public.recipes add column if not exists is_batch boolean not null default false;

-- Hachis parmentier
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Hachis parmentier')) then
    raise notice 'Déjà présente, ignorée : %', 'Hachis parmentier';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Hachis parmentier', '586 kcal/portion · Note 4,7/5 (2170 avis)', 'https://static.jow.fr/1024x1024/recipes/rXToxZSztduzOQ.png', 'https://jow.fr/recipes/hachis-parmentier-8d313toqclf509cd10gp',
          8, 35,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pommes de terre', 400, 'g', 'Fruits & Légumes', 0),
    (r, 'Bœuf (haché surgelé)', 250, 'g', 'Surgelés', 1),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Lait', 100, 'ml', 'Crémerie', 3),
    (r, 'Fromage râpé', 20, 'g', 'Crémerie', 4),
    (r, 'Beurre', 20, 'g', 'Crémerie', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Épluchez puis coupez les pommes de terre en morceaux.'),
    (r, 2, 'Dans une casserole d''eau bouillante salée, ajoutez les pommes de terre. Faites-les cuire 15 minutes, sur feu moyen.'),
    (r, 3, 'Pendant ce temps, épluchez puis émincez les oignons.'),
    (r, 4, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez les oignons et le bœuf haché. Faites revenir le tout 5 à 6 minutes, en mélangeant pour détacher les morceaux. Salez et poivrez. Réservez hors du feu.'),
    (r, 5, 'Vérifiez la cuisson des pommes de terre, puis égouttez-les.'),
    (r, 6, 'Salez, poivrez puis écrasez les pommes de terre à l''aide d''une fourchette ou d''un presse-purée. Ajoutez le beurre et le lait. Mélangez.'),
    (r, 7, 'Beurrez un plat allant au four (le nôtre fait 28 x 19 cm). Répartissez le bœuf haché, puis étalez la purée uniformément sur le dessus. Parsemez le tout de fromage râpé, puis enfournez 20 minutes à 180°C.'),
    (r, 8, 'Une fois le hachis parmentier bien doré, sortez le plat du four. Servez-le dans une assiette accompagné d''une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Hachis parmentier';
end
$$;

-- Salade au poulet pané & sauce pesto
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Salade au poulet pané & sauce pesto')) then
    raise notice 'Déjà présente, ignorée : %', 'Salade au poulet pané & sauce pesto';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Salade au poulet pané & sauce pesto', '541 kcal/portion · Note 4,7/5 (200 avis)', 'https://static.jow.fr/1024x1024/recipes/iCdl3zOQoXzr5Q.jpg', 'https://jow.fr/recipes/salade-au-poulet-pane-et-sauce-pesto-9ax4mgb64113hjb30yy5',
          3, 6,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Poulet (pané)', 2, 'pièce', 'Boucherie & Volaille', 0),
    (r, 'Salade (mélange)', 4, 'poignée', 'Fruits & Légumes', 1),
    (r, 'Tomates cerises', 200, 'g', 'Fruits & Légumes', 2),
    (r, 'Fromage à trous', 60, 'g', 'Crémerie', 3),
    (r, 'Sauce pesto', 2, 'c. à c.', 'Épicerie salée', 4),
    (r, 'Citron jaune', 2, 'quartier', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Lavez puis coupez les tomates cerises en deux.'),
    (r, 2, 'Faites chauffer une poêle, sur feu moyen. Ajoutez le poulet pané. Faites-le griller 3 minutes de chaque côté, jusqu''à ce qu''il soit bien doré. Coupez-le en morceaux.'),
    (r, 3, 'Coupez le fromage en petits dés.'),
    (r, 4, 'Préparez la sauce. Dans un bol, mélangez : le pesto, le jus de citron et un petit filet d''huile d''olive.'),
    (r, 5, 'Servez la salade dans une assiette creuse ou un plat, avec les tomates cerises, le poulet pané et le fromage. Nappez le tout de sauce au pesto. C''est prêt !');
  raise notice 'Ajoutée : %', 'Salade au poulet pané & sauce pesto';
end
$$;

-- Salade haricots verts, feta & croûtons
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Salade haricots verts, feta & croûtons')) then
    raise notice 'Déjà présente, ignorée : %', 'Salade haricots verts, feta & croûtons';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Salade haricots verts, feta & croûtons', '383 kcal/portion · Note 4,6/5 (237 avis)', 'https://static.jow.fr/1024x1024/recipes/SBOitz8s1njiRg.jpg', 'https://jow.fr/recipes/salade-haricots-verts-feta-et-croutons-8qx51me72msjdupa1244',
          6, 12,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Haricot vert (surgelé)', 300, 'g', 'Surgelés', 0),
    (r, 'Tomates séchées', 80, 'g', 'Épicerie salée', 1),
    (r, 'Feta', 80, 'g', 'Crémerie', 2),
    (r, 'Pain de campagne (non tranché)', 100, 'g', 'Pain & Pâtisserie', 3),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 4),
    (r, 'Persil (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole d''eau bouillante, faites cuire les haricots verts pendant environ 3 minutes puis réservez.'),
    (r, 2, 'Pendant ce temps, épluchez puis coupez l''oignon en fines lamelles. Coupez les tomates séchées en petits morceaux.'),
    (r, 3, 'Dans une poêle, ajoutez une noisette de beurre puis faites revenir les oignons pendant environ 5 minutes à feu moyen. Ajoutez un filet d''eau si jamais cela accroche.'),
    (r, 4, 'Pendant ce temps, déchirez votre pain de façon à obtenir des petits morceaux.'),
    (r, 5, 'Une fois que les oignons sont bien cuits, retirez-les de la poêle. Ajoutez une noisette de beurre, puis faites revenir les morceaux de pain pendant 4 minutes, le temps qu''ils soient bien dorés.'),
    (r, 6, 'Dans une assiette, ajoutez les haricots verts, les oignons, les tomates séchées, les croûtons puis mélangez bien.'),
    (r, 7, 'Ajoutez ensuite la feta émiettée, un trait d''huile d''olive, salez et poivrez. Finissez par quelques feuilles de persil si vous en avez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Salade haricots verts, feta & croûtons';
end
$$;

select r.title,
       count(distinct i.id) as ingredients,
       count(distinct s.id) as etapes
from public.recipes r
left join public.recipe_ingredients i on i.recipe_id = r.id
left join public.recipe_steps s on s.recipe_id = r.id
group by r.id, r.title
order by r.title;
