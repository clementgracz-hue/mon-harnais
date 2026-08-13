-- 116 recette(s) — généré par scripts/recipes-to-sql.mjs
-- Rejouable : une recette déjà présente (même titre) est ignorée.

-- Colonnes ajoutées après la première version du schéma : le fichier
-- s'installe seul, même sur une base qui n'a pas rejoué schema.sql.
alter table public.recipes add column if not exists source_url text;
alter table public.recipes add column if not exists servings integer not null default 2;
alter table public.recipes add column if not exists is_batch boolean not null default false;

-- Moussaka
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Moussaka')) then
    raise notice 'Déjà présente, ignorée : %', 'Moussaka';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Moussaka', '637 kcal/portion · Note 4,8/5 (755 avis)', 'https://static.jow.fr/1024x1024/recipes/0MFnCzch8bjfqA.jpg', 'https://jow.fr/recipes/moussaka-8zvt7ixki3zk031107qt',
          17, 40,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Aubergine', 300, 'g', 'Fruits & Légumes', 0),
    (r, 'Bœuf (haché)', 200, 'g', 'Boucherie & Volaille', 1),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Sauce tomate (basilic)', 200, 'g', 'Épicerie salée', 3),
    (r, 'Ail', 1, 'gousse', 'Fruits & Légumes', 4),
    (r, 'Farine de blé', 30, 'g', 'Épicerie salée', 5),
    (r, 'Beurre', 30, 'g', 'Crémerie', 6),
    (r, 'Lait', 250, 'ml', 'Crémerie', 7),
    (r, 'Mozzarella (râpée)', 60, 'g', 'Crémerie', 8),
    (r, 'Muscade', 2, 'pincée', 'Épicerie salée', 9);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Lavez puis coupez les aubergines en très fines lamelles dans le sens de la longueur.'),
    (r, 2, 'Disposez les tranches d''aubergines sur une plaque recouverte de papier cuisson. Salez, poivrez puis badigeonnez-les d''huile d''olive. Enfournez 15 à 20 minutes à 180°C.'),
    (r, 3, 'Pendant ce temps, épluchez puis émincez finement l''oignon.'),
    (r, 4, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez la viande haché, salez et poivrez puis faites-la revenir 5 minutes.'),
    (r, 5, 'Ajoutez les oignons et l''ail râpé puis poursuivez la cuisson 5 minutes.'),
    (r, 6, 'Ajoutez la moitié de la muscade et la sauce tomate. (Optionnel : ajoutez une pincée de cannelle). Mélangez puis poursuivez la cuisson 5 minutes à couvert sur feu doux.'),
    (r, 7, 'Pendant ce temps, préparez la béchamel : dans une casserole, ajoutez le beurre et faites-le fondre sur feu doux. Ajoutez la farine et mélangez rapidement.'),
    (r, 8, 'Ajoutez progressivement le lait en mélangeant jusqu''à obtenir une texture un peu épaisse. Salez, poivrez et ajoutez de la muscade puis mélangez.'),
    (r, 9, 'Vérifier la cuisson de la viande.'),
    (r, 10, 'Vérifiez la cuisson des aubergines puis sortez-les du four.'),
    (r, 11, 'Dans un plat à gratin (le nôtre fait 25 x 20 cm), ajoutez un filet d''huile d''olive puis disposer la moitié des aubergines. Recouvrez-les avec la moitié de la viande. Répétez une seconde fois avec l''autre moitié des aubergines et la viande.'),
    (r, 12, 'Recouvrez de béchamel puis parsemez le tout de mozzarella râpée. Enfournez 20 minutes à 210°C.'),
    (r, 13, 'Une fois le fromage bien fondu et doré, sortez la moussaka du four. Servez aussitôt. C''est prêt !');
  raise notice 'Ajoutée : %', 'Moussaka';
end
$$;

-- Bœuf sauté au chou
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Bœuf sauté au chou')) then
    raise notice 'Déjà présente, ignorée : %', 'Bœuf sauté au chou';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Bœuf sauté au chou', '488 kcal/portion · Note 4,5/5 (174 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-02-202309.png_merge_recipes/TOqVEL92jCPeZA.png.jpg', 'https://jow.fr/recipes/boeuf-saute-au-chou-8a1bec1kbyf7ipvn05r0',
          6, 10,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Riz', 140, 'g', 'Épicerie salée', 0),
    (r, 'Bœuf (haché)', 200, 'g', 'Boucherie & Volaille', 1),
    (r, 'Sauce soja salée', 2, 'c. à s.', 'Épicerie salée', 2),
    (r, 'Gingembre (frais)', 2, 'cm', 'Fruits & Légumes', 3),
    (r, 'Chou blanc (pièce)', 200, 'g', 'Fruits & Légumes', 4),
    (r, 'Coriandre (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 5),
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole d''eau bouillante, faite cuire le riz selon les instructions du paquet. Égouttez en fin de cuisson.'),
    (r, 2, 'Émincez très finement le chou.'),
    (r, 3, 'Dans une poêle chaude, ajoutez un filet d''huile d''olive. Ajoutez le chou et faites le cuire 5 minutes à feu moyen.'),
    (r, 4, 'Ajoutez la viande, le gingembre râpé, l''ail émincé, la sauce soja, salez, poivrez. Mélangez et faites revenir 5 minutes à feu vif pour faire griller la viande.'),
    (r, 5, 'Servez le riz avec le bœuf sauté. Vous pouvez ajouter du chou frais si vous le souhaitez. (Optionnel : ajoutez de la coriandre fraîche et du citron si vous en avez). C''est prêt !');
  raise notice 'Ajoutée : %', 'Bœuf sauté au chou';
end
$$;

-- Aubergines braisées au porc & riz
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Aubergines braisées au porc & riz')) then
    raise notice 'Déjà présente, ignorée : %', 'Aubergines braisées au porc & riz';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Aubergines braisées au porc & riz', '503 kcal/portion · Note 4,5/5 (394 avis)', 'https://static.jow.fr/1024x1024/recipes/HeheyF7sqrK41A.jpg', 'https://jow.fr/recipes/aubergines-braisees-au-porc-et-riz-8i983kndlzb4kl8k0hbv',
          16, 15,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Aubergine', 300, 'g', 'Fruits & Légumes', 0),
    (r, 'Chair à saucisse', 120, 'g', 'Boucherie & Volaille', 1),
    (r, 'Ail', 1, 'gousse', 'Fruits & Légumes', 2),
    (r, 'Gingembre (frais)', 10, 'g', 'Fruits & Légumes', 3),
    (r, 'Sucre (en poudre)', 2, 'c. à c.', 'Épicerie sucrée', 4),
    (r, 'Sauce soja salée', 2, 'c. à s.', 'Épicerie salée', 5),
    (r, 'Riz', 140, 'g', 'Épicerie salée', 6),
    (r, 'Ciboulette', 0.2, 'bouquet', 'Fruits & Légumes', 7);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Lavez puis coupez les aubergines en cubes. Disposez-les dans une passoire et salez-les afin qu''elles dégorgent.'),
    (r, 2, 'Pendant ce temps, épluchez puis râpez l''ail et le gingembre. Réservez.'),
    (r, 3, 'Si vous en avez, rincez puis ciselez finement la ciboulette.'),
    (r, 4, 'Préparez la sauce. Dans un bol, mélangez : le sucre et la sauce soja.'),
    (r, 5, 'Enlevez l''eau et le sel des aubergines, en les-épongeant avec du papier absorbant.'),
    (r, 6, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez les aubergines et faites-les dorer 5 à 6 minutes. Réservez sur du papier absorbant.'),
    (r, 7, 'Dans la même poêle, faites chauffer un petit filet d''huile d''olive, sur feu doux. Ajoutez le gingembre et l''ail râpés et faites-les revenir 30 secondes, en remuant.'),
    (r, 8, 'Ajoutez ensuite la chair à saucisse et faites revenir le tout 1 minute, sur feu moyen, en mélangeant pour détacher les morceaux.'),
    (r, 9, 'Ajoutez la sauce par-dessus le tout et poivrez généreusement. Mélangez bien.'),
    (r, 10, 'Rajoutez les aubergines dans la poêle, puis versez-y environ 30 ml d’eau par portion. Baissez le feu et laissez mijoter 10 minutes, en remuant de temps en temps.'),
    (r, 11, 'Pendant ce temps, dans une casserole d''eau bouillante salée, faites cuire le riz selon les indications du paquet.'),
    (r, 12, 'Vérifiez la cuisson des aubergines - l''eau de la poêle doit s''être évaporée et les aubergines doivent être bien tendres à cœur. Hors du feu, parsemez le tout de ciboulette ciselée.'),
    (r, 13, 'En fin de cuisson, égouttez le riz.'),
    (r, 14, 'Servez le riz dans une assiette avec les aubergines braisées au porc. Re-assaisonnez selon vos goûts, c''est prêt !');
  raise notice 'Ajoutée : %', 'Aubergines braisées au porc & riz';
end
$$;

-- Feta, légumes rôtis & orzo
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Feta, légumes rôtis & orzo')) then
    raise notice 'Déjà présente, ignorée : %', 'Feta, légumes rôtis & orzo';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Feta, légumes rôtis & orzo', '532 kcal/portion · Note 4,6/5 (811 avis)', 'https://static.jow.fr/1024x1024/recipes/tar79gFnsVhHkQ.jpg', 'https://jow.fr/recipes/feta-legumes-rotis-et-orzo-8zle1on1aups02uy0cjw',
          7, 30,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Tomates cerises', 200, 'g', 'Fruits & Légumes', 0),
    (r, 'Courgette', 1, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Oignon rouge', 0.5, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Feta', 100, 'g', 'Crémerie', 3),
    (r, 'Citron jaune', 2, 'tranche', 'Fruits & Légumes', 4),
    (r, 'Pâtes (orzo)', 200, 'g', 'Épicerie salée', 5),
    (r, 'Basilic (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Épluchez puis coupez les oignons rouges en quartiers fins.'),
    (r, 2, 'Lavez puis coupez les courgettes en deux dans le sens de la longueur, puis en biseaux.'),
    (r, 3, 'Lavez puis coupez le citron en fines rondelles.'),
    (r, 4, 'Dans un plat allant au four, déposez les oignons, les courgettes et les rondelles de citron. Ajoutez un filet d''huile d''olive et mélangez bien.'),
    (r, 5, 'Ajoutez les tomates cerises et les blocs de feta* coupés en deux. Salez, poivrez et arrosez le tout d’un filet d’huile d’olive. Enfournez 25 à 30 minutes à 200°C.'),
    (r, 6, 'Pendant ce temps, dans une casserole d''eau bouillante salée, faites cuire les pâtes selon les instructions du paquet. En fin de cuisson, égouttez-les puis réservez au chaud.'),
    (r, 7, 'Une fois les légumes bien dorés, sortez le plat du four. Servez les pâtes orzo avec les légumes et la feta rôtis. Ajoutez quelques feuilles de basilic, si vous en avez et re-assaisonnez selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Feta, légumes rôtis & orzo';
end
$$;

-- Quiche chèvre épinards
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Quiche chèvre épinards')) then
    raise notice 'Déjà présente, ignorée : %', 'Quiche chèvre épinards';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Quiche chèvre épinards', '342 kcal/portion · Note 4,6/5 (1969 avis) · Plat entier : 6 parts.', 'https://static.jow.fr/1024x1024/recipes/WgXg1IF7xibdPw.jpg', 'https://jow.fr/recipes/quiche-chevre-epinards-89nzh3fuhktx84vm06ld',
          16, 50,
          6, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâte brisée', 1, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Œuf', 3, 'pièce', 'Crémerie', 1),
    (r, 'Crème fraîche', 3, 'c. à s.', 'Crémerie', 2),
    (r, 'Chèvre (bûche)', 200, 'g', 'Crémerie', 3),
    (r, 'Épinards (surgelés)', 400, 'g', 'Surgelés', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Décongelez les épinards selon les instructions du paquet et égouttez-les bien.'),
    (r, 2, 'Placez la pâte brisée dans un moule à tarte (le nôtre fait 25 cm de diamètre). Piquez-la et faites-la précuire 5 minutes à 180°C.'),
    (r, 3, 'Pendant ce temps, coupez la moitié du chèvre en rondelles.'),
    (r, 4, 'Préparez l''appareil à quiche. Dans un saladier, ajoutez : les œufs et la crème fraîche. Salez, poivrez puis fouettez le tout énergiquement.'),
    (r, 5, 'Ajoutez les épinards et le reste du chèvre préalablement émietté. Mélangez le tout délicatement.'),
    (r, 6, 'Une fois la pâte précuite, sortez-la du four.'),
    (r, 7, 'Versez l''appareil à quiche dans le fond de tarte et ajoutez les rondelles de chèvre par-dessus*. Enfournez 40 à 45 minutes à 180°C.'),
    (r, 8, 'Une fois cuite et bien dorée, sortez la quiche chèvre épinards du four. Servez-la chaude ou froide avec une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Quiche chèvre épinards';
end
$$;

-- Tarte fine mortadelle, burrata & pistaches
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tarte fine mortadelle, burrata & pistaches')) then
    raise notice 'Déjà présente, ignorée : %', 'Tarte fine mortadelle, burrata & pistaches';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tarte fine mortadelle, burrata & pistaches', '418 kcal/portion · Note 4,8/5 (193 avis)', 'https://static.jow.fr/1024x1024/recipes/ImGf2LuxU6zphw.jpg', 'https://jow.fr/recipes/tarte-fine-mortadelle-burrata-et-pistaches-95u7iwwjkbk7556h155x',
          9, 25,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâte feuilletée', 0.5, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Crème fraîche', 1, 'c. à s.', 'Crémerie', 1),
    (r, 'Courgette', 100, 'g', 'Fruits & Légumes', 2),
    (r, 'Mortadelle', 2.5, 'tranche', 'Traiteur & Charcuterie', 3),
    (r, 'Burrata', 0.5, 'pièce', 'Crémerie', 4),
    (r, 'Sauce pesto', 1, 'c. à c.', 'Épicerie salée', 5),
    (r, 'Pistaches (émondées)', 10, 'g', 'Épicerie sucrée', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Lavez puis coupez les courgettes en fines lamelles, à l''aide d''un économe.'),
    (r, 2, 'Déroulez la pâte feuilletée sur une plaque de cuisson. Étalez la crème fraîche sur la pâte en laissant 1 à 2 cm au bord.'),
    (r, 3, 'Disposez les tagliatelles de courgettes sur la pâte. Salez, poivrez et ajoutez un filet d''huile d''olive. Enfournez 20 à 25 minutes à 180°C.'),
    (r, 4, 'Une fois la tarte dorée, sortez-la du four. Disposez les tranches de mortadelle sur la tarte avec la burrata au centre puis ajoutez le pesto.'),
    (r, 5, 'Parsemez la tarte de pistaches concassées et ajoutez quelques feuilles de basilic, si vous en avez. Servez-la avec une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Tarte fine mortadelle, burrata & pistaches';
end
$$;

-- Risotto de coquillettes & brocolis
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Risotto de coquillettes & brocolis')) then
    raise notice 'Déjà présente, ignorée : %', 'Risotto de coquillettes & brocolis';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Risotto de coquillettes & brocolis', '434 kcal/portion · Note 4,2/5 (179 avis)', 'https://static.jow.fr/1024x1024/recipes/dLbsUquITjdZkw.jpg', 'https://jow.fr/recipes/risotto-de-coquillettes-et-brocolis-93ada5zyh5kw02xx05je',
          7, 24,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (coquillettes)', 160, 'g', 'Épicerie salée', 0),
    (r, 'Brocoli (frais)', 200, 'g', 'Fruits & Légumes', 1),
    (r, 'Échalote', 1, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 3),
    (r, 'Râpé végétal', 60, 'g', 'Crémerie', 4),
    (r, 'Vin blanc', 40, 'ml', 'Boissons', 5),
    (r, 'Bouillon de légumes (cube)', 0.5, 'pièce', 'Épicerie salée', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez puis émincez finement les échalotes.'),
    (r, 2, 'Lavez puis coupez le brocoli en sommités. Coupez les sommités en 2 ou en 4 selon leur taille.'),
    (r, 3, 'Faites chauffer un filet d''huile d''olive dans une casserole, sur feu moyen. Ajoutez les échalotes et faites-les revenir 2 à 3 minutes, en mélangeant.'),
    (r, 4, 'Ajoutez les coquillettes, le brocoli et le vin blanc. Mélangez et poursuivez la cuisson, jusqu''à absorption.'),
    (r, 5, 'Faites bouillir 250 ml d''eau par personne et y dissoudre le bouillon. Ajoutez l''équivalent d''une louche de bouillon et l''ail râpé. Mélangez jusqu''à absorption, puis rajoutez à nouveau une louche de bouillon. Recommencez l''opération jusqu''à ce que les coquillettes soient cuites.'),
    (r, 6, 'Une fois les coquillettes cuites, ajoutez le râpé végétal. Salez, poivrez, puis mélangez bien le tout.'),
    (r, 7, 'Servez le risotto de coquillettes & brocolis dans une assiette creuse. Re-assaisonnez selon vous goûts, c''est prêt.');
  raise notice 'Ajoutée : %', 'Risotto de coquillettes & brocolis';
end
$$;

-- Saint-Jacques poêlées et brocoli
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Saint-Jacques poêlées et brocoli')) then
    raise notice 'Déjà présente, ignorée : %', 'Saint-Jacques poêlées et brocoli';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Saint-Jacques poêlées et brocoli', '340 kcal/portion · Note 4,5/5 (160 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-04-202309.png_merge_recipes/l0r9MOKw01Lm6w.png.jpg', 'https://jow.fr/recipes/saint-jacques-poelees-et-brocoli-83t31nax8ihsgaa60xq7',
          7, 15,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Brocoli (frais)', 200, 'g', 'Fruits & Légumes', 0),
    (r, 'Noix de Saint-Jacques (surgelé)', 180, 'g', 'Surgelés', 1),
    (r, 'Pommes de terre', 2, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Cheddar (râpé)', 50, 'g', 'Crémerie', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Si besoin, faites décongeler les noix de Saint-Jacques. Épluchez la pomme de terre et coupez-la en petit dés. Lavez puis coupez le chou-fleur en sommités. Coupez les sommités en 2 ou en 4 selon leur taille. Coupez le tronc en petits cubes.'),
    (r, 2, 'Faites bouillir une casserole d''eau chaude, versez-y la pomme de terre et laissez-la cuire 5 minutes. Ajoutez le brocoli après 5 minutes, pour 10 minutes supplémentaires.'),
    (r, 3, 'Stoppez la cuisson après avoir vérifié que les légumes soient tendres (laissez cuire 2 minutes supplémentaires si ce n''est pas le cas). À l''aide d''une fourchette, écrasez-les. Ajoutez le cheddar*, salez, poivrez.'),
    (r, 4, 'Dans une poêle chaude, poêlez les noix de Saint-Jacques 2 minutes de chaque côté.'),
    (r, 5, 'Servez les Saint-Jacques accompagnées de la purée et d''un filet d''huile d''olive.');
  raise notice 'Ajoutée : %', 'Saint-Jacques poêlées et brocoli';
end
$$;

-- Gratin de poireaux, pommes de terre & fromage à raclette
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Gratin de poireaux, pommes de terre & fromage à raclette')) then
    raise notice 'Déjà présente, ignorée : %', 'Gratin de poireaux, pommes de terre & fromage à raclette';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Gratin de poireaux, pommes de terre & fromage à raclette', '601 kcal/portion · Note 4,5/5 (635 avis)', 'https://static.jow.fr/1024x1024/recipes/PZ0SRl0YnYfgsw.jpg', 'https://jow.fr/recipes/gratin-de-poireaux-pommes-de-terre-et-fromage-a-raclette-92fe1lfaiojk030l0xvf',
          15, 35,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Poireau', 500, 'g', 'Fruits & Légumes', 0),
    (r, 'Pommes de terre', 200, 'g', 'Fruits & Légumes', 1),
    (r, 'Raclette', 80, 'g', 'Crémerie', 2),
    (r, 'Beurre', 40, 'g', 'Crémerie', 3),
    (r, 'Farine de blé', 40, 'g', 'Épicerie salée', 4),
    (r, 'Lait', 300, 'ml', 'Crémerie', 5),
    (r, 'Salade (Mélange)', 100, 'g', 'Fruits & Légumes', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Épluchez les pommes de terre, puis coupez-les en fines rondelles.'),
    (r, 2, 'Dans une casserole d''eau bouillante salée, ajoutez les pommes de terre. Faites-les cuire 10 minutes, sur feu moyen.'),
    (r, 3, 'Pendant ce temps, coupez les extrémités des poireaux pour ne garder que le blanc, puis émincez-les finement. Placez-les dans une passoire et rincez abondamment pour retirer les impuretés.'),
    (r, 4, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu vif. Ajoutez les poireaux émincés. Salez, poivrez, puis faites-les revenir 2 à 3 minutes, en mélangeant. Couvrez et poursuivez la cuisson 8 à 10 minutes, sur feu doux.'),
    (r, 5, 'Vérifiez la cuisson des pommes de terre, puis égouttez-les.'),
    (r, 6, 'Préparez la béchamel. Faites fondre le beurre dans une casserole, sur feu doux. Ajoutez la farine et mélangez rapidement.'),
    (r, 7, 'Ajoutez progressivement le lait, en mélangeant, jusqu''à obtenir une texture de pâte à crêpes un peu épaisse. Salez, poivrez puis mélangez. Réservez hors du feu.'),
    (r, 8, 'Dans un plat à gratin, ajoutez une première couche de pommes de terre. Poivrez puis ajoutez une couche de poireaux, de la béchamel et une couche de fromage à raclette. Répétez l’opération jusqu''à épuisement des ingrédients, en terminant par le fromage à raclette. Enfournez 25 minutes à 200°C.'),
    (r, 9, 'Une fois le gratin bien doré et le fromage fondu, sortez le plat du four. Servez-le accompagné de la salade verte assaisonnée selon vos goûts, c''est prêt !');
  raise notice 'Ajoutée : %', 'Gratin de poireaux, pommes de terre & fromage à raclette';
end
$$;

-- Saucisses, potatoes au air-fryer & salade
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Saucisses, potatoes au air-fryer & salade')) then
    raise notice 'Déjà présente, ignorée : %', 'Saucisses, potatoes au air-fryer & salade';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Saucisses, potatoes au air-fryer & salade', '550 kcal/portion · Note 4,8/5 (76 avis)', 'https://static.jow.fr/1024x1024/recipes/JL4v2NitwFRu3w.jpg', 'https://jow.fr/recipes/saucisses-potatoes-au-air-fryer-et-salade-93656ewri07402sd0n43',
          6, 30,
          2, false,
          array['Jow', 'Air fryer'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Saucisse (chipolata)', 4, 'pièce', 'Boucherie & Volaille', 0),
    (r, 'Pommes de terre', 300, 'g', 'Fruits & Légumes', 1),
    (r, 'Salade (Mélange)', 2, 'poignée', 'Fruits & Légumes', 2),
    (r, 'Ketchup', 2, 'c. à c.', 'Épicerie salée', 3),
    (r, 'Moutarde', 2, 'c. à c.', 'Épicerie salée', 4),
    (r, 'Origan (séché)', 2, 'pincée', 'Épicerie salée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Lavez puis coupez les pommes de terre en quartiers.'),
    (r, 2, 'Disposez les potatoes dans le panier du air-fryer avec la grille. Ajoutez un filet d''huile d''olive. Salez, poivrez et assaisonnez d''origan. Mélangez bien, puis faites cuire au air-fryer 15 à 20 minutes à 200°C.'),
    (r, 3, 'Au bout de 15 à 20 minutes, sortez les potatoes du air-fryer et remuez-les. Poursuivez la cuisson au air-fryer 10 minutes à 200°C.'),
    (r, 4, 'En parallèle, ajoutez les chipolatas dans le panier du air-fryer avec la grille. Piquez-les à l''aide du bout d''un couteau, puis faites-les cuire au air-fryer 10 minutes à 200°C.'),
    (r, 5, 'Une fois les potatoes dorées et croustillantes et les saucisses cuites, sortez-les du air-fryer.'),
    (r, 6, 'Servez les chipolatas dans une assiette avec les potatoes, la salade verte, le ketchup et la moutarde. Re-assaisonnez selon vos goûts, c''est prêt !');
  raise notice 'Ajoutée : %', 'Saucisses, potatoes au air-fryer & salade';
end
$$;

-- Salade de macaroni
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Salade de macaroni')) then
    raise notice 'Déjà présente, ignorée : %', 'Salade de macaroni';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Salade de macaroni', '497 kcal/portion · Note 4,5/5 (103 avis)', 'https://static.jow.fr/1024x1024/recipes/TzMyVbWUeNPhwg.jpg', 'https://jow.fr/recipes/salade-de-macaroni-94352u8xli6pd2cr0oxy',
          6, 12,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (macaroni)', 160, 'g', 'Épicerie salée', 0),
    (r, 'Allumettes (jambon)', 100, 'g', 'Traiteur & Charcuterie', 1),
    (r, 'Petits pois (surgelés)', 100, 'g', 'Surgelés', 2),
    (r, 'Fromage à trous', 60, 'g', 'Crémerie', 3),
    (r, 'Échalote', 1, 'pièce', 'Fruits & Légumes', 4),
    (r, 'Vinaigre balsamique', 2, 'c. à c.', 'Épicerie salée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole d''eau bouillante salée, faites cuire les pâtes selon les instructions du paquet.'),
    (r, 2, 'Pendant ce temps, épluchez puis émincez finement les échalotes.'),
    (r, 3, 'Coupez le fromage en cubes.'),
    (r, 4, 'En fin de cuisson des pâtes, ajoutez les petits pois dans la casserole. Poursuivez la cuisson 4 à 5 minutes, puis égouttez le tout et réservez.'),
    (r, 5, 'Pendant ce temps, préparez la vinaigrette. Dans un bol, mélangez : le vinaigre balsamique et une cuillère à soupe d''huile d''olive par personne. Salez et poivrez.'),
    (r, 6, 'Dans un saladier, ajoutez : les pâtes et les petits pois, les allumettes de jambon, les cubes de fromage et les échalotes. Versez la vinaigrette par-dessus le tout puis mélangez bien.'),
    (r, 7, 'Servez la salade de macaroni dans une assiette creuse. Re-assaisonnez selon vos goûts, c''est prêt !');
  raise notice 'Ajoutée : %', 'Salade de macaroni';
end
$$;

-- Haché de veau, carottes rôties & feta
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Haché de veau, carottes rôties & feta')) then
    raise notice 'Déjà présente, ignorée : %', 'Haché de veau, carottes rôties & feta';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Haché de veau, carottes rôties & feta', '430 kcal/portion · Note 4,5/5 (128 avis)', 'https://static.jow.fr/1024x1024/recipes/qGxnJ8rcW0xGHQ.jpg', 'https://jow.fr/recipes/hache-de-veau-carottes-roties-et-feta-93zg240j9hu75xiu1dwf',
          9, 20,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Veau (haché)', 200, 'g', 'Boucherie & Volaille', 0),
    (r, 'Carotte (frais)', 300, 'g', 'Fruits & Légumes', 1),
    (r, 'Lentilles (cuites)', 140, 'g', 'Épicerie salée', 2),
    (r, 'Feta', 40, 'g', 'Crémerie', 3),
    (r, 'Yaourt Grec', 2, 'c. à s.', 'Crémerie', 4),
    (r, 'Échalote', 1, 'pièce', 'Fruits & Légumes', 5),
    (r, 'Paprika', 2, 'pincée', 'Épicerie salée', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Épluchez puis émincez finement les échalotes.'),
    (r, 2, 'Épluchez puis coupez les carottes en deux dans la longueur.'),
    (r, 3, 'Dans un plat allant au four, ajoutez les carottes. Assaisonnez-les de paprika, poivrez et ajoutez un filet d''huile d''olive. Mélangez bien, puis enfournez 20 minutes à 200°C.'),
    (r, 4, 'Dans un bol, mélangez : le yaourt grec, la feta émiettée et les échalotes. Salez, poivrez et ajoutez un filet d''huile d''olive. Réservez au frais.'),
    (r, 5, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez les hachés de veau. Salez, poivrez et faites-les revenir 5 à 6 minutes, en les retournant à mi-cuisson.'),
    (r, 6, 'Une fois les carottes dorées et tendres à cœur, sortez-les du four.'),
    (r, 7, 'Étalez la crème de feta dans une assiette. Ajoutez les lentilles par-dessus, suivies des carottes rôties et du haché de veau. Re-assaisonnez selon vos goûts, c''est prêt !');
  raise notice 'Ajoutée : %', 'Haché de veau, carottes rôties & feta';
end
$$;

-- Filet mignon à la moutarde, pommes de terre & brocoli
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Filet mignon à la moutarde, pommes de terre & brocoli')) then
    raise notice 'Déjà présente, ignorée : %', 'Filet mignon à la moutarde, pommes de terre & brocoli';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Filet mignon à la moutarde, pommes de terre & brocoli', '325 kcal/portion · Note 4,5/5 (558 avis)', 'https://static.jow.fr/1024x1024/recipes/40dZEjt0J0qwNw.jpg', 'https://jow.fr/recipes/filet-mignon-a-la-moutarde-pommes-de-terre-et-brocoli-8tnibc4jkts16cux0nhv',
          6, 45,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Porc (filet mignon)', 0.5, 'pièce', 'Boucherie & Volaille', 0),
    (r, 'Pommes de terre', 300, 'g', 'Fruits & Légumes', 1),
    (r, 'Brocoli (frais)', 200, 'g', 'Fruits & Légumes', 2),
    (r, 'Moutarde à l''ancienne', 2, 'c. à c.', 'Épicerie salée', 3),
    (r, 'Thym (feuilles)', 2, 'pincée', 'Épicerie salée', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 190°C. Lavez et découpez les pommes de terre en très fines lamelles.'),
    (r, 2, 'Dans un plat allant au four, ajoutez les rondelles de pomme de terre. Assaisonnez de sel, poivre, thym & d''un filet d''huile d''olive. Enfournez 15 à 20 minutes à 190°C.'),
    (r, 3, 'Au bout des 10 à 15 minutes de cuisson, sortez le plat du four et ajoutez-y le filet mignon. Badigeonnez-le de moutarde et assaisonnez de sel, poivre, thym & d''un filet d''huile d''olive. Enfournez de nouveau 20 à 25 minutes à 190°C (en fonction de la taille du filet mignon, comptez environ une demi-heure par 500g).'),
    (r, 4, 'Pendant ce temps, lavez et coupez le brocoli en sommités. Faites-les pré-cuire quelques minutes à la vapeur avant la cuisson au four, pour des légumes plus tendres.'),
    (r, 5, 'Sortez le plat du four et ajoutez les brocolis. Assaisonnez de sel, de poivre, de thym & d''un filet d''huile d''olive. Enfournez à nouveau 10 minutes à 190°C.'),
    (r, 6, 'À la sortie du four, laissez le filet mignon reposer avant de le couper en tranches.'),
    (r, 7, 'Servez les tranches de filet mignon à la moutarde avec les pommes de terre croustillantes et le brocoli. Ré-assaisonnez selon vos goûts, c''est prêt !');
  raise notice 'Ajoutée : %', 'Filet mignon à la moutarde, pommes de terre & brocoli';
end
$$;

-- Cheeseburger poulet & sauce miel moutarde
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Cheeseburger poulet & sauce miel moutarde')) then
    raise notice 'Déjà présente, ignorée : %', 'Cheeseburger poulet & sauce miel moutarde';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Cheeseburger poulet & sauce miel moutarde', '645 kcal/portion · Note 4,6/5 (736 avis)', 'https://static.jow.fr/1024x1024/recipes/KgEZvi6MwMh0dA.jpg', 'https://jow.fr/recipes/cheeseburger-poulet-et-sauce-miel-moutarde-9435cskhli6pd2cr1bn5',
          3, 8,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pain burger', 2, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Poulet (pané)', 2, 'pièce', 'Boucherie & Volaille', 1),
    (r, 'Fromage à trous (tranches)', 2, 'tranche', 'Crémerie', 2),
    (r, 'Salade (coeur de laitue)', 2, 'poignée', 'Fruits & Légumes', 3),
    (r, 'Moutarde', 2, 'c. à c.', 'Épicerie salée', 4),
    (r, 'Miel (liquide)', 1, 'c. à c.', 'Épicerie sucrée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une poêle chaude, ajoutez les poulets panés. Faites-les griller 3 minutes de chaque côté, jusqu''à ce qu''ils soient bien dorés. Réservez au chaud.'),
    (r, 2, 'Dans la même poêle, faites chauffer un filet d''huile d''olive, sur feu moyen. Faites toaster les pains burger 1 à 2 minutes, jusqu''à ce qu''ils soient dorés.'),
    (r, 3, 'Préparez la sauce miel moutarde. Dans un bol, mélangez : la moutarde et le miel.'),
    (r, 4, 'Garnissez vos burgers en tartinant les pains burger de la sauce miel moutarde. Ajoutez le poulet pané, le fromage en tranches et les feuilles de laitue. Refermez le burger et dégustez aussitôt. C''est prêt !');
  raise notice 'Ajoutée : %', 'Cheeseburger poulet & sauce miel moutarde';
end
$$;

-- Lasagnes pesto & brocolis
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Lasagnes pesto & brocolis')) then
    raise notice 'Déjà présente, ignorée : %', 'Lasagnes pesto & brocolis';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Lasagnes pesto & brocolis', '588 kcal/portion · Note 4,5/5 (472 avis)', 'https://static.jow.fr/1024x1024/recipes/YHjlVB3je0PkdQ.jpg', 'https://jow.fr/recipes/lasagnes-pesto-et-brocolis-8rlpjykf7xnn5djq0m4m',
          12, 44,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Lasagnes (cru)', 90, 'g', 'Crémerie', 0),
    (r, 'Brocoli (frais)', 300, 'g', 'Fruits & Légumes', 1),
    (r, 'Sauce pesto', 2, 'c. à s.', 'Épicerie salée', 2),
    (r, 'Béchamel', 190, 'ml', 'Épicerie salée', 3),
    (r, 'Parmesan (râpé)', 75, 'g', 'Crémerie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Lavez puis coupez le brocoli en sommités. Coupez les sommités en 2 ou en 4 selon leur taille. Vous pouvez également couper le tronc en petits cubes et l''ajouter à votre préparation.'),
    (r, 2, 'Dans une casserole d''eau bouillante salée, ajoutez le brocoli. Laissez cuire 9 minutes.'),
    (r, 3, 'Une fois les brocolis cuits, égouttez-les. Réduisez-les en purée, à l''aide d''une fourchette.'),
    (r, 4, 'Ajoutez la béchamel puis mélangez pour l''incorporer. (Si vous souhaitez réaliser votre propre béchamel, tapez “Béchamel maison" dans la barre de recherche de l’application !).'),
    (r, 5, 'Ajoutez le pesto et la moitié du parmesan. Salez, poivrez et mélangez à nouveau.'),
    (r, 6, 'Dans un plat allant au four (le nôtre fait 20 x 20 cm), étalez une première couche du mélange aux brocolis.* Disposez ensuite les feuilles de lasagnes, puis répétez l''opération jusqu''à épuisement des ingrédients.'),
    (r, 7, 'Terminez par une couche de brocolis, puis parsemez du reste de parmesan râpé. Enfournez 35 minutes à 180°C.'),
    (r, 8, 'Une fois dorées et cuites à cœur, sortez les lasagnes du four et servez-les accompagnées d''une salade verte. C''est prêt !');
  raise notice 'Ajoutée : %', 'Lasagnes pesto & brocolis';
end
$$;

-- Ravioles à la toscane
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Ravioles à la toscane')) then
    raise notice 'Déjà présente, ignorée : %', 'Ravioles à la toscane';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Ravioles à la toscane', '622 kcal/portion · Note 4,7/5 (2662 avis)', 'https://static.jow.fr/1024x1024/recipes/SQiYvIFirgqd6Q.jpg', 'https://jow.fr/recipes/ravioles-a-la-toscane-8ekx43augkyoka5t0v68',
          3, 12,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Ravioli (Ricotta-épinards)', 300, 'g', 'Crémerie', 0),
    (r, 'Tomates séchées', 40, 'g', 'Épicerie salée', 1),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 2),
    (r, 'Épinard (frais)', 4, 'poignée', 'Fruits & Légumes', 3),
    (r, 'Parmesan (râpé)', 2, 'c. à s.', 'Crémerie', 4),
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Égouttez puis émincez les tomates séchées.'),
    (r, 2, 'Dans une casserole d''eau bouillante salée, faites cuire les ravioli selon les instructions du paquet. En fin de cuisson, égouttez-les.'),
    (r, 3, 'Pendant ce temps, faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez l''ail râpé et faites-le revenir 30 secondes, en mélangeant.'),
    (r, 4, 'Ajoutez les tomates séchées et la crème fraîche, puis mélangez bien.'),
    (r, 5, 'Ajoutez les épinards et un filet d''eau. Poursuivez la cuisson 2 minutes, en remuant.'),
    (r, 6, 'Ajoutez les ravioli et le parmesan râpé. Poivrez, puis mélangez le tout délicatement pendant 1 à 2 minutes supplémentaires.'),
    (r, 7, 'Servez les ravioles à la toscane dans une assiette. Ajoutez un peu de parmesan râpé, s''il vous en reste. C''est prêt !');
  raise notice 'Ajoutée : %', 'Ravioles à la toscane';
end
$$;

-- Grilled cheese brie & cerise noire
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Grilled cheese brie & cerise noire')) then
    raise notice 'Déjà présente, ignorée : %', 'Grilled cheese brie & cerise noire';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Grilled cheese brie & cerise noire', '624 kcal/portion · Note 4,4/5 (524 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-02-202309.png_merge_recipes/D55eWNQChZ6NFQ.png.jpg', 'https://jow.fr/recipes/grilled-cheese-brie-et-cerise-noire-81m063jq2lyo00tg05xs',
          5, 4,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pain de mie', 8, 'tranche', 'Pain & Pâtisserie', 0),
    (r, 'Fromage frais', 60, 'g', 'Crémerie', 1),
    (r, 'Épinard (frais)', 10, 'g', 'Fruits & Légumes', 2),
    (r, 'Confiture de cerise', 2, 'c. à c.', 'Épicerie sucrée', 3),
    (r, 'Brie (fondant)', 60, 'g', 'Crémerie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Étalez le fromage frais sur chaque tranche.'),
    (r, 2, 'Ajoutez le brie coupé en tranche sur l''une et la confiture sur l''autre.'),
    (r, 3, 'Salez, poivrez. Optionnel : ajoutez quelques pousses d''épinards. Refermez le sandwich. Recommencez autant de fois que de sandwich nécessaires.'),
    (r, 4, 'Dans une poêle à feu moyen, ajoutez une noisette de beurre (ou huile d''olive) et faire revenir les grilled cheese 2 minutes sur chaque face pour quelles soient bien dorées. Veillez à ce qu''elles ne brûlent pas !'),
    (r, 5, 'Coupez le feu, couvrez la poêle et laissez reposer 1 minute hors du feu.'),
    (r, 6, 'Coupez les sandwichs.'),
    (r, 7, 'Dégustez aussitôt. C''est prêt !');
  raise notice 'Ajoutée : %', 'Grilled cheese brie & cerise noire';
end
$$;

-- Salade endives, avocat & comté
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Salade endives, avocat & comté')) then
    raise notice 'Déjà présente, ignorée : %', 'Salade endives, avocat & comté';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Salade endives, avocat & comté', '680 kcal/portion · Note 4,7/5 (1033 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-02-202309.png_merge_recipes/8T6uRJltaWuurA.png.jpg', 'https://jow.fr/recipes/salade-endives-avocat-et-comte-8lf15bnr8rcicvir0y19',
          5, 0,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Endives', 3, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Pomme rouge', 1, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Avocat', 1, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Comté', 80, 'g', 'Crémerie', 3),
    (r, 'Noisette', 60, 'g', 'Épicerie sucrée', 4),
    (r, 'Moutarde', 2, 'c. à c.', 'Épicerie salée', 5),
    (r, 'Vinaigre de cidre', 1, 'c. à c.', 'Épicerie salée', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Concassez grossièrement les noisettes, puis toastez-les. Dans une poêle chaude à sec, ajoutez les noisettes et faites-les revenir quelques minutes, jusqu''à ce qu''elles soient bien dorées. Réservez.'),
    (r, 2, 'Préparez la vinaigrette. Dans un petit bol, mélangez : la moutarde, le vinaigre de cidre et 1 cuillère à soupe d''huile d''olive par personne. Salez et poivrez. Vous pouvez également ajouter une pointe de miel, si vous le souhaitez.'),
    (r, 3, 'Lavez puis émincez les endives grossièrement.'),
    (r, 4, 'Si vous souhaitez, épluchez les pommes. Lavez puis coupez les pommes en fines lamelles. Coupez-les ensuite en petit dés.'),
    (r, 5, 'Coupez l''avocat en deux. Retirez la peau, puis coupez-le en petits dés.'),
    (r, 6, 'Coupez le comté en petits cubes.'),
    (r, 7, 'Dans une assiette creuse, servez les endives avec les morceaux de pomme, l''avocat, le comté, et les noisettes toastées. Versez la vinaigrette par-dessus, puis mélangez bien le tout. C''est prêt !');
  raise notice 'Ajoutée : %', 'Salade endives, avocat & comté';
end
$$;

-- Crème de panais, lard & œufs pochés
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Crème de panais, lard & œufs pochés')) then
    raise notice 'Déjà présente, ignorée : %', 'Crème de panais, lard & œufs pochés';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Crème de panais, lard & œufs pochés', '408 kcal/portion · Note 4,5/5 (46 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-01-202309.png_merge_recipes/Mj0JCaRsK5nvTg.png.jpg', 'https://jow.fr/recipes/creme-de-panais-lard-et-oeufs-poches-8ks5es3jip8jfcwg0k0u',
          6, 28,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Panais', 400, 'g', 'Fruits & Légumes', 0),
    (r, 'Œuf', 2, 'pièce', 'Crémerie', 1),
    (r, 'Lard (tranches)', 2, 'tranche', 'Traiteur & Charcuterie', 2),
    (r, 'Beurre', 40, 'g', 'Crémerie', 3),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 4),
    (r, 'Persil (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez puis coupez l''oignon en fines tranches.'),
    (r, 2, 'Épluchez puis coupez le panais en morceaux.'),
    (r, 3, 'Faites chauffer une casserole et ajoutez un filet d''huile d''olive. Ajoutez l''oignon et le panais. Salez, poivrez et laissez cuire le tout 3 minutes sur feu moyen tout en remuant.'),
    (r, 4, 'Ajoutez de l''eau à hauteur (soit environ 5cl par portion). Couvrez et laissez cuire 25 minutes sur feu moyen.'),
    (r, 5, 'Faites chauffer une casserole d''eau. Ajoutez une c. à soupe de vinaigre de votre choix dans l''eau. Portez à petite ébullition. Faites un mouvement circulaire dans l''eau vinaigrée pour former un petit tourbillon.'),
    (r, 6, 'Cassez votre œuf dans un petit récipient (soit 1 œuf par portion). Versez l''œuf délicatement dans l''eau et faites cuire 3 min à petite ébullition. (Il est plus facile de cuire les œufs un à un dans l''eau). Réservez les œufs de côté.'),
    (r, 7, 'Faites griller les tranches de lard dans une poêle bien chaude jusqu''à ce qu''ils deviennent croustillants. Débarrassez-les sur du papier absorbant.'),
    (r, 8, 'Une fois les panais cuits, retirez la casserole du feu.'),
    (r, 9, 'Mixez-les avec du beurre jusqu''à obtenir une purée lisse.'),
    (r, 10, 'Dans une assiette creuse, déposez la crème de panais, l''œuf poché et les morceaux de lard. Si vous en avez, ajoutez quelques feuilles de persil, et versez un filet d''huile d''olive. C''est prêt !');
  raise notice 'Ajoutée : %', 'Crème de panais, lard & œufs pochés';
end
$$;

-- Pain de thon à la tomate
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Pain de thon à la tomate')) then
    raise notice 'Déjà présente, ignorée : %', 'Pain de thon à la tomate';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Pain de thon à la tomate', '176 kcal/portion · Note 4,5/5 (135 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-04-202309.png_merge_recipes/9tKm1mDrVaLBjg.png.jpg', 'https://jow.fr/recipes/pain-de-thon-a-la-tomate-8lr7g7gelq3qi7940rpd',
          5, 40,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Thon (conserve)', 80, 'g', 'Épicerie salée', 0),
    (r, 'Pain de mie', 0.6666666666666666, 'tranche', 'Pain & Pâtisserie', 1),
    (r, 'Tomate (concentré)', 23.33, 'g', 'Épicerie salée', 2),
    (r, 'Échalote', 0.3333333333333333, 'pièce', 'Fruits & Légumes', 3),
    (r, 'Œuf', 1.67, 'pièce', 'Crémerie', 4),
    (r, 'Persil (frais)', 2, 'brin', 'Fruits & Légumes', 5),
    (r, 'Salade (Mélange)', 4, 'poignée', 'Fruits & Légumes', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Épluchez puis émincez finement les échalotes.'),
    (r, 2, 'Déchirez le pain de mie en gros morceaux.'),
    (r, 3, 'Dans un saladier, ajoutez : les échalotes, le pain de mie, le thon émietté, le concentré de tomates et les œufs. Salez, poivrez puis ajoutez le persil. Mixez le tout, jusqu''à obtenir une préparation homogène.'),
    (r, 4, 'Tapissez un moule à cake (le nôtre fait 29 x 10 cm) de papier cuisson. Versez-y la pâte, puis enfournez 35 à 40 minutes à 180°C.'),
    (r, 5, 'Une fois que le pain de thon est bien doré, plantez votre couteau au centre. S''il ressort propre, il est prêt, sinon re-enfournez 2 à 3 minutes. Servez le pain de thon à la tomate accompagnée de la salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Pain de thon à la tomate';
end
$$;

-- Gâteau avoine, banane & fruits rouges
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Gâteau avoine, banane & fruits rouges')) then
    raise notice 'Déjà présente, ignorée : %', 'Gâteau avoine, banane & fruits rouges';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Gâteau avoine, banane & fruits rouges', '480 kcal/portion · Note 4,3/5 (76 avis)', 'https://static.jow.fr/1024x1024/patterns/kale-01-202309.png_merge_recipes/UOmTp1e7NF9QIQ.png.jpg', 'https://jow.fr/recipes/gateau-avoine-banane-et-fruits-rouges-8m041t2n34j5ctf117zy',
          5, 25,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Avoine (flocons)', 100, 'g', 'Épicerie sucrée', 0),
    (r, 'Boisson végétale', 400, 'ml', 'Crémerie', 1),
    (r, 'Graines de Chia', 2, 'c. à s.', 'Épicerie salée', 2),
    (r, 'Banane', 2, 'pièce', 'Fruits & Légumes', 3),
    (r, 'Fruits rouges (surgelés)', 80, 'g', 'Surgelés', 4),
    (r, 'Sirop d''érable', 2, 'c. à s.', 'Épicerie sucrée', 5),
    (r, 'Yaourt végétal', 2, 'c. à s.', 'Crémerie', 6),
    (r, 'Noix de coco (râpée)', 2, 'c. à s.', 'Épicerie sucrée', 7);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Beurrez ou huilez un moule à gratin (le nôtre fait 24 x 19 cm). Ajoutez les bananes et écrasez-les à l''aide d''une fourchette.'),
    (r, 2, 'Ajoutez une couche de flocons d''avoine puis de graines de chia puis de lait. Mélangez légèrement.'),
    (r, 3, 'Parsemez le tout de fruits rouges surgelés et de noix de coco râpée si vous en avez. Enfournez pendant 25 minutes à 180°C.'),
    (r, 4, 'Sortez du four et dégustez avec du yaourt et un filet de sirop d''érable, c''est prêt !');
  raise notice 'Ajoutée : %', 'Gâteau avoine, banane & fruits rouges';
end
$$;

-- Croissant au jambon
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Croissant au jambon')) then
    raise notice 'Déjà présente, ignorée : %', 'Croissant au jambon';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Croissant au jambon', '596 kcal/portion · Note 4,7/5 (811 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-05-202309.png_merge_recipes/K0OgySWW2oLMWw.png.jpg', 'https://jow.fr/recipes/croissant-au-jambon-8lvai9ttc9er704j0iey',
          6, 10,
          2, false,
          array['Jow', 'Express', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Croissant', 2, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Jambon blanc', 2, 'tranche', 'Traiteur & Charcuterie', 1),
    (r, 'Fromage râpé', 120, 'g', 'Crémerie', 2),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 3),
    (r, 'Parmesan (râpé)', 1, 'c. à s.', 'Crémerie', 4),
    (r, 'Salade (Mélange)', 4, 'poignée', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Dans un bol, mélangez la crème avec la moitié du fromage râpé et le parmesan. Salez et poivrez.'),
    (r, 2, 'Ouvrez les croissants en deux sans les couper jusqu''au bout. Garnissez-les avec une couche du mélange crème-fromage, une tranche de jambon et une deuxième couche du mélange crème-fromage. Refermez le croissant.'),
    (r, 3, 'Disposez les croissants sur une plaque recouverte de papier cuisson puis ajoutez l''autre moitié du gruyère râpé sur le dessus.'),
    (r, 4, 'Enfournez pendant 10 minutes à 200°C.'),
    (r, 5, 'Servez le croissant avec une salade verte assaisonnée selon vos goûts, c''est prêt !');
  raise notice 'Ajoutée : %', 'Croissant au jambon';
end
$$;

-- Avocado toast & burrata
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Avocado toast & burrata')) then
    raise notice 'Déjà présente, ignorée : %', 'Avocado toast & burrata';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Avocado toast & burrata', '560 kcal/portion · Note 4,7/5 (1131 avis)', 'https://static.jow.fr/1024x1024/recipes/s5feSNHz4nOPiw.jpg', 'https://jow.fr/recipes/avocado-toast-et-burrata-8n6bh3m886t2altj0fgo',
          4, 0,
          2, false,
          array['Jow', 'Express', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pain de campagne (tranché)', 4, 'tranche', 'Pain & Pâtisserie', 0),
    (r, 'Avocat', 1, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Burrata', 1, 'pièce', 'Crémerie', 2),
    (r, 'Échalote', 0.5, 'pièce', 'Fruits & Légumes', 3),
    (r, 'Citron jaune', 2, 'quartier', 'Fruits & Légumes', 4),
    (r, 'Coriandre (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez puis émincez très finement les échalotes.'),
    (r, 2, 'Lavez puis ciselez la coriandre.'),
    (r, 3, 'Faites griller les tranches de pain au grille pain ou au four.'),
    (r, 4, 'Pendant ce temps, dans un bol, écrasez l''avocat. Ajoutez le jus de citron. Salez, poivrez et ajoutez la coriandre ciselée. Mélangez.'),
    (r, 5, 'Étalez le mélange à l''avocat sur les tranches de pain. Disposez ensuite les morceaux de burrata par-dessus et les échalotes émincées. Ajoutez un filet d''huile d''olive, salez, poivrez, puis décorez avec de la coriandre s''il vous en reste. C''est prêt !');
  raise notice 'Ajoutée : %', 'Avocado toast & burrata';
end
$$;

-- Tartelette pesto, tomates & salade
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tartelette pesto, tomates & salade')) then
    raise notice 'Déjà présente, ignorée : %', 'Tartelette pesto, tomates & salade';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tartelette pesto, tomates & salade', '363 kcal/portion · Note 4,7/5 (667 avis)', 'https://static.jow.fr/1024x1024/recipes/m6mv88WkYG8QDQ.jpg', 'https://jow.fr/recipes/tartelette-pesto-tomates-et-salade-8o4s2gg16uxg2zdj11ob',
          7, 20,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâte feuilletée', 0.5, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Sauce pesto', 2, 'c. à c.', 'Épicerie salée', 1),
    (r, 'Tomates cerises', 200, 'g', 'Fruits & Légumes', 2),
    (r, 'Feta', 60, 'g', 'Crémerie', 3),
    (r, 'Salade (Mélange)', 4, 'poignée', 'Fruits & Légumes', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Étalez votre pâte feuilletée sur une plaque allant au four puis découpez-la en 4.'),
    (r, 2, 'Au centre de chaque morceau de pâte, ajoutez le pesto* et étalez-le.'),
    (r, 3, 'Ajoutez les tomates cerises coupées en 2 et la feta* émiettée sur chaque tartelette.'),
    (r, 4, 'Badigeonnez les bords de la tarte avec un peu d''eau. Rabattez les bords de chaque part pour former des tartelettes. Versez un filet d''huile et enfournez pour 15 minutes de cuisson à 200°C.'),
    (r, 5, 'Servez avec une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Tartelette pesto, tomates & salade';
end
$$;

-- Tarte tomates rocamadour
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tarte tomates rocamadour')) then
    raise notice 'Déjà présente, ignorée : %', 'Tarte tomates rocamadour';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tarte tomates rocamadour', '409 kcal/portion · Note 4,5/5 (369 avis) · Plat entier : 4 parts.', 'https://static.jow.fr/1024x1024/patterns/yolk-02-202309.png_merge_recipes/so21kLwpZAXLeg.png.jpg', 'https://jow.fr/recipes/tarte-tomates-rocamadour-85lj7u5nlm28jf0j18yf',
          10, 48,
          4, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Tomate pelée', 440, 'g', 'Épicerie salée', 0),
    (r, 'Chèvre (Rocamadour)', 3, 'pièce', 'Crémerie', 1),
    (r, 'Pâte brisée', 1, 'pièce', 'Pain & Pâtisserie', 2),
    (r, 'Oignon jaune', 1, 'pièce', 'Fruits & Légumes', 3),
    (r, 'Œuf', 3, 'pièce', 'Crémerie', 4),
    (r, 'Crème liquide', 40, 'ml', 'Crémerie', 5),
    (r, 'Herbes de Provence', 2, 'pincée', 'Épicerie salée', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Placez la pâte brisée dans un moule à tarte (le nôtre fait 31 cm de diamètre) et piquez-la avec une fourchette. Faites-la pré-cuire pendant 7 minutes, puis réservez.'),
    (r, 2, 'Pendant ce temps, épluchez puis hachez finement les oignons.'),
    (r, 3, 'Faites chauffer un filet d''huile d''olive dans une poêle. Ajoutez les oignons et faites-les revenir 2 minutes.'),
    (r, 4, 'Ajoutez ensuite les tomates pelées préalablement égouttées*. Salez, poivrez et ajoutez une pincée d''herbes de Provence, si vous en avez. Concassez les tomates et laissez-les cuire 10 minutes, pour que le jus des tomates réduise.'),
    (r, 5, 'Pendant ce temps, préparez l''appareil. Dans un saladier, ajoutez : les œufs, la crème, du sel et du poivre. Fouettez le tout énergiquement.'),
    (r, 6, 'Versez l''appareil sur la pâte précuite. Répartissez ensuite les tomates par-dessus. Mélangez grossièrement.'),
    (r, 7, 'Ajoutez le rocamadour par-dessus et une pincée d''herbes de Provence. aromatiques. Enfournez 40 minutes à 180°C.'),
    (r, 8, 'Une fois bien dorée et cuite, sortez la tarte du four et servez-la avec une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Tarte tomates rocamadour';
end
$$;

-- Tomates farcies
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tomates farcies')) then
    raise notice 'Déjà présente, ignorée : %', 'Tomates farcies';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tomates farcies', '696 kcal/portion · Note 4,6/5 (535 avis)', 'https://static.jow.fr/1024x1024/recipes/aZFePXYjYwMlDw.jpg', 'https://jow.fr/recipes/tomates-farcies-81svjp7u34c000vm1cwh',
          12, 45,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Tomate (à cuire)', 4, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Riz', 140, 'g', 'Épicerie salée', 1),
    (r, 'Chair à saucisse', 200, 'g', 'Boucherie & Volaille', 2),
    (r, 'Persil (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 3),
    (r, 'Échalote', 0.5, 'pièce', 'Fruits & Légumes', 4),
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 5),
    (r, 'Pain de mie', 1, 'tranche', 'Pain & Pâtisserie', 6),
    (r, 'Lait', 4, 'c. à s.', 'Crémerie', 7);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Dans un récipient placez le pain de mie et versez le lait par-dessus, pour qu''il s''imbibe. Réservez.'),
    (r, 2, 'Lavez puis découpez le haut des tomates (sur 1 cm environ) et videz la chair avec une cuillère. Réservez la chair.'),
    (r, 3, 'Épluchez, puis émincez finement l''échalote et l''ail. Ciselez le persil.'),
    (r, 4, 'Dans un saladier, ajoutez : la chair à saucisse, le pain de mie imbibé, le persil, l''ail et l''échalote. Salez, poivrez puis malaxez le tout avec les mains.'),
    (r, 5, 'Dans un plat à gratin, versez le riz*, 180 ml d''eau par personne et la chair des tomates. Salez, poivrez, puis mélangez bien.'),
    (r, 6, 'Ajoutez la farce de saucisse dans les tomates, puis disposez-les dans le plat allant au four. Replacez le chapeau de la tomate sur le dessus, puis enfournez 45 minutes à 180°C.'),
    (r, 7, 'Sortez le plat du four et parsemez de persil, s''il vous en reste. C''est prêt !');
  raise notice 'Ajoutée : %', 'Tomates farcies';
end
$$;

-- Courgettes farcies lardons ricotta
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Courgettes farcies lardons ricotta')) then
    raise notice 'Déjà présente, ignorée : %', 'Courgettes farcies lardons ricotta';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Courgettes farcies lardons ricotta', '519 kcal/portion · Note 4,5/5 (140 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-01-202309.png_merge_recipes/OsMFVZxp3h8ivA.png.jpg', 'https://jow.fr/recipes/courgettes-farcies-lardons-ricotta-85pgab8kcssw8sn5155j',
          8, 31,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Courgette ronde', 4, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Lardons', 100, 'g', 'Traiteur & Charcuterie', 1),
    (r, 'Ricotta', 160, 'g', 'Crémerie', 2),
    (r, 'Parmesan (râpé)', 2, 'c. à s.', 'Crémerie', 3),
    (r, 'Pignons de pin', 2, 'c. à s.', 'Épicerie salée', 4),
    (r, 'Épinard (frais)', 4, 'poignée', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez votre four à 200°C. Coupez les chapeaux des courgettes et videz-les. Réservez la chair des courgettes.'),
    (r, 2, 'Hachez la chair de courgette.'),
    (r, 3, 'Dans une poêle, faites rissoler les lardons 3 minutes.'),
    (r, 4, 'Ajoutez la chair de courgette et laissez cuire 5 minutes'),
    (r, 5, 'Ajouter les épinards. Laissez réduire 3 minutes.'),
    (r, 6, 'En dehors du feu, mélangez la poêlée avec la ricotta, le parmesan et les pignons. Salez, poivrez.'),
    (r, 7, 'Garnissez les courgettes du mélange et replacez les chapeaux sur les courgettes.'),
    (r, 8, 'Huilez un plat et placez-y les courgettes. Enfournez le plat 20 minutes à 200°C.'),
    (r, 9, 'Servez, c''est prêt !');
  raise notice 'Ajoutée : %', 'Courgettes farcies lardons ricotta';
end
$$;

-- Crevettes au miel & patate douce
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Crevettes au miel & patate douce')) then
    raise notice 'Déjà présente, ignorée : %', 'Crevettes au miel & patate douce';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Crevettes au miel & patate douce', '396 kcal/portion · Note 4,4/5 (526 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-05-202309.png_merge_recipes/3VClrNhBI1lGdg.png.jpg', 'https://jow.fr/recipes/crevettes-au-miel-et-patate-douce-8fltircy03o0jy4y0ccy',
          4, 10,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Crevette (cuite)', 200, 'g', 'Poissonnerie', 0),
    (r, 'Patate douce', 500, 'g', 'Fruits & Légumes', 1),
    (r, 'Miel (liquide)', 2, 'c. à c.', 'Épicerie sucrée', 2),
    (r, 'Sauce soja salée', 2, 'c. à c.', 'Épicerie salée', 3),
    (r, 'Gingembre (frais)', 10, 'g', 'Fruits & Légumes', 4),
    (r, 'Graines de sésame', 20, 'g', 'Épicerie salée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez puis coupez les patates douces en demi lunes.'),
    (r, 2, 'Dans une casserole d''eau bouillante salée, faites cuire les patates douces 10 minutes, sur feu moyen.'),
    (r, 3, 'Pendant ce temps, épluchez le gingembre.'),
    (r, 4, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez les crevettes et le gingembre râpé. Faites-les revenir 2 minutes, en remuant.'),
    (r, 5, 'Ajoutez la sauce soja, le miel et 2 cuillères à soupe d''eau par portion. Mélangez bien, puis laissez réduire 2 à 3 minutes, sur feu doux. Poivrez.'),
    (r, 6, 'En fin de cuisson, ajoutez les graines de sésame. Réservez au chaud.'),
    (r, 7, 'Une fois les patates douces tendres à cœur, égouttez-les. Dans la même casserole, ajoutez un filet d''huile d''olive, puis écrasez les patates douces en purée. Si besoin, ajoutez un petit filet d''eau, jusqu''à obtenir une texture lisse. Assaisonnez selon vos goûts.'),
    (r, 8, 'Servez la purée de patates douces dans une assiette avec les crevettes au miel. Re-assaisonnez selon vos goûts, c''est prêt !');
  raise notice 'Ajoutée : %', 'Crevettes au miel & patate douce';
end
$$;

-- Saucisse aux oignons
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Saucisse aux oignons')) then
    raise notice 'Déjà présente, ignorée : %', 'Saucisse aux oignons';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Saucisse aux oignons', '888 kcal/portion · Note 4,7/5 (156 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-05-202309.png_merge_recipes/3T0J73tIyxSZVA.png.jpg', 'https://jow.fr/recipes/saucisse-aux-oignons-8dwd1p0wdp3l14vv0ct6',
          8, 20,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pommes de terre', 500, 'g', 'Fruits & Légumes', 0),
    (r, 'Lait', 100, 'ml', 'Crémerie', 1),
    (r, 'Beurre', 80, 'g', 'Crémerie', 2),
    (r, 'Saucisse (fumée)', 2, 'pièce', 'Boucherie & Volaille', 3),
    (r, 'Oignon jaune', 1, 'pièce', 'Fruits & Légumes', 4),
    (r, 'Moutarde à l''ancienne', 2, 'c. à c.', 'Épicerie salée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez les pommes de terre et coupez-les en petits dés.'),
    (r, 2, 'Faites bouillir une casserole d''eau chaude, ajoutez-y les pommes de terre et laissez cuire 15 minutes.'),
    (r, 3, 'Dans une casserole, cuire les saucisses selon les instructions de préparation du paquet.'),
    (r, 4, 'Dans une poêle ajoutez la moitié du beurre et les oignons émincés.'),
    (r, 5, 'Faites-les revenir 5 minutes à feu vif, puis ajoutez 5cl d''eau par personne.'),
    (r, 6, 'Laissez mijoter à feu moyen jusqu''à ce que la cuisson des saucisses soit terminée.'),
    (r, 7, 'Ajoutez la moutarde dans les oignons.'),
    (r, 8, 'Une fois le temps de cuisson des saucisses écoulé, ajoutez-les dans la poêle et laissez mijoter à feu doux le temps de préparer la purée.'),
    (r, 9, 'Une fois la cuisson des pommes de terre écoulée, égouttez-les puis placez-les dans un récipient.'),
    (r, 10, 'Ajoutez le lait et le beurre, salez et poivrez et écrasez le tout jusqu''à former une purée de la consistance souhaitée.'),
    (r, 11, 'Servez les saucisses sur la purée avec le jus et les oignons. Salez, poivrez et servez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Saucisse aux oignons';
end
$$;

-- Galette complète
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Galette complète')) then
    raise notice 'Déjà présente, ignorée : %', 'Galette complète';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Galette complète', '532 kcal/portion · Note 4,8/5 (3698 avis)', 'https://static.jow.fr/1024x1024/recipes/W40exe5YldaZmA.jpg', 'https://jow.fr/recipes/galette-complete-81pfd91j1lkg00ws06qy',
          3, 5,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Jambon blanc', 2, 'tranche', 'Traiteur & Charcuterie', 0),
    (r, 'Œuf', 2, 'pièce', 'Crémerie', 1),
    (r, 'Galette bretonne', 2, 'pièce', 'Crémerie', 2),
    (r, 'Fromage râpé', 60, 'g', 'Crémerie', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Faites fondre un morceau de beurre dans la crêpière (ou une grande poêle). Déposez la galette et versez l''œuf au centre, attention à ne pas casser le jaune. Salez et poivrez.'),
    (r, 2, 'Quand le blanc de l''œuf commence à cuire, ajoutez le jambon préalablement coupé en tranches et le fromage râpé.'),
    (r, 3, 'Repliez la galette en carré ou en demi lune. Laissez griller 2 minutes, c''est prêt !');
  raise notice 'Ajoutée : %', 'Galette complète';
end
$$;

-- Croziflette
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Croziflette')) then
    raise notice 'Déjà présente, ignorée : %', 'Croziflette';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Croziflette', '673 kcal/portion · Note 4,7/5 (2578 avis)', 'https://static.jow.fr/1024x1024/recipes/pe0nGtncFOo2gg.jpg', 'https://jow.fr/recipes/croziflette-88z843hzhgme7hm10qoh',
          7, 35,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Reblochon', 100, 'g', 'Crémerie', 0),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Lardons', 100, 'g', 'Traiteur & Charcuterie', 2),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 3),
    (r, 'Crozets', 160, 'g', 'Crémerie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 210°C. Faites cuire les crozets dans une casserole d''eau bouillante pendant 20 minutes.'),
    (r, 2, 'Pendant ce temps, épluchez puis émincez les oignons finement.'),
    (r, 3, 'Dans une poêle chaude, ajoutez les oignons émincés et les lardons. Faites revenir le tout pendant 10 minutes.'),
    (r, 4, 'Une fois les crozets cuits, égouttez-les.'),
    (r, 5, 'Coupez le fromage en deux.'),
    (r, 6, 'Dans un plat à gratin (le nôtre fait 26 x 18 cm), ajoutez les crozets, la crème fraîche et le mélange lardons/oignons. Salez, poivrez et mélangez bien.'),
    (r, 7, 'Ajoutez le fromage par-dessus, puis enfournez 15 minutes à 210°C.'),
    (r, 8, 'Une fois le fromage bien fondu et doré, sortez le plat du four. C''est prêt !');
  raise notice 'Ajoutée : %', 'Croziflette';
end
$$;

-- Gratin de patates douces & châtaignes
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Gratin de patates douces & châtaignes')) then
    raise notice 'Déjà présente, ignorée : %', 'Gratin de patates douces & châtaignes';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Gratin de patates douces & châtaignes', '565 kcal/portion · Note 4,4/5 (282 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-04-202309.png_merge_recipes/QZYSQ8PerP.png.jpg', 'https://jow.fr/recipes/gratin-de-patates-douces-et-chataignes-82mulhaghw5s00y307lu',
          12, 25,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Patate douce', 400, 'g', 'Fruits & Légumes', 0),
    (r, 'Crème fraîche', 3, 'c. à s.', 'Crémerie', 1),
    (r, 'Fromage râpé', 60, 'g', 'Crémerie', 2),
    (r, 'Marrons (cuits en conserve)', 200, 'g', 'Épicerie salée', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Épluchez et coupez les patates douces en cubes.'),
    (r, 2, 'Dans un récipient allant au micro-onde, ajoutez un fond d''eau et les patates douces. Recouvrir avec du film alimentaire transparent et faire cuire au micro-onde 5 minutes à la puissance maximale.'),
    (r, 3, 'Sortez les patates douces du micro-onde : elles doivent être tendres. (Replacez 2 minutes au micro-onde si ce n''est pas le cas). Égouttez-les.'),
    (r, 4, 'Placez les patates douces dans un plat allant au four. Ajoutez les marrons égouttés.* Salez, poivrez et mélangez.'),
    (r, 5, 'Ajoutez la crème et le fromage râpé. Enfournez pendant 20 minutes à 200°C.'),
    (r, 6, 'Une fois doré, sortez le plat du four et servez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Gratin de patates douces & châtaignes';
end
$$;

-- Croziflette végé aux poireaux
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Croziflette végé aux poireaux')) then
    raise notice 'Déjà présente, ignorée : %', 'Croziflette végé aux poireaux';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Croziflette végé aux poireaux', '585 kcal/portion · Note 4,6/5 (316 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-01-202309.png_merge_recipes/trw6sFSyjTNx7g.png.jpg', 'https://jow.fr/recipes/croziflette-vege-aux-poireaux-8ftdje7tb6cwki2p0ii7',
          7, 35,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Reblochon', 100, 'g', 'Crémerie', 0),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Poireau', 160, 'g', 'Fruits & Légumes', 2),
    (r, 'Crème fraîche', 1, 'c. à s.', 'Crémerie', 3),
    (r, 'Crozets', 200, 'g', 'Crémerie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 210°C. Faites cuire les crozets dans une casserole d''eau chaude pendant 20 minutes.'),
    (r, 2, 'Émincez les poireaux* et rincez-les à l''eau claire dans une passoire. *Cosultez nos tips pour cette étape'),
    (r, 3, 'Émincez l''oignon.'),
    (r, 4, 'Dans une poêle chaude, ajoutez un filet d''huile d''olive, les poireaux, les oignons et laissez-les cuire 10 minutes à feu moyen.'),
    (r, 5, 'Versez un filet de vin blanc pour déglacer la poêle si vous le souhaitez.'),
    (r, 6, 'Égouttez les crozets en fin de cuisson.'),
    (r, 7, 'Dans un récipient, versez les crozets, la poêlée de légumes, la crème fraîche, salez, poivrez et mélangez.'),
    (r, 8, 'Versez le tout dans un plat à gratin (le nôtre fait 26 x 20 cm). Sur le gratin, ajoutez le fromage en lamelles ou coupé en deux.'),
    (r, 9, 'Poivrez et enfournez 15 minutes à 210°C.'),
    (r, 10, 'Sortez le plat du four. C''est prêt !');
  raise notice 'Ajoutée : %', 'Croziflette végé aux poireaux';
end
$$;

-- Tatin de tomates cerises
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tatin de tomates cerises')) then
    raise notice 'Déjà présente, ignorée : %', 'Tatin de tomates cerises';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tatin de tomates cerises', '348 kcal/portion · Note 4,3/5 (250 avis) · Plat entier : 4 parts.', 'https://static.jow.fr/1024x1024/patterns/raddish-05-202309.png_merge_recipes/ZQp380l808u0rQ.png.jpg', 'https://jow.fr/recipes/tatin-de-tomates-cerises-8gs084zl4d4wkobk12m2',
          4, 30,
          4, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Tomates cerises', 500, 'g', 'Fruits & Légumes', 0),
    (r, 'Pâte feuilletée', 1, 'pièce', 'Pain & Pâtisserie', 1),
    (r, 'Beurre demi-sel', 40, 'g', 'Crémerie', 2),
    (r, 'Sucre (en poudre)', 30, 'g', 'Épicerie sucrée', 3),
    (r, 'Sauce soja salée', 4, 'c. à s.', 'Épicerie salée', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Dans une poêle à feu vif versez la sauce soja, le sucre* et le beurre. Faites réduire pour faire un caramel.'),
    (r, 2, 'Lavez les tomates cerises et coupez-les en deux.'),
    (r, 3, 'Récupérez le papier de votre pâte feuilletée et ajoutez-le dans le fond de votre moule (le nôtre fait 23 cm de diamètre) pour faciliter le démoulage.'),
    (r, 4, 'Versez le caramel dans le fond de votre moule et disposez les tomates avec la partie bombée vers le bas.'),
    (r, 5, 'Puis disposez la pâte feuilletée sur le dessus en repliant les bords vers l''intérieur.'),
    (r, 6, 'Faites une cheminée à l''aide d''un petit couteau puis enfournez le tout à 200°C pendant 25 à 30 minutes.'),
    (r, 7, 'Une fois bien dorée, sortez la tarte du four. Laissez-la refroidir complètement avant de la démouler. Pour ce faire : placez une grande assiette/plat sur le dessus du moule. puis retournez le tout d''un coup sec. Attention au démoulage, il peut y avoir un peu de jus de cuisson.'),
    (r, 8, 'Servez la tatin avec quelques feuilles de basilic sur le dessus et une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Tatin de tomates cerises';
end
$$;

-- Grilled cheese poulet & oignons confits
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Grilled cheese poulet & oignons confits')) then
    raise notice 'Déjà présente, ignorée : %', 'Grilled cheese poulet & oignons confits';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Grilled cheese poulet & oignons confits', '578 kcal/portion · Note 4,6/5 (509 avis)', 'https://static.jow.fr/1024x1024/recipes/NWqcjk0XujJJeQ.jpg', 'https://jow.fr/recipes/grilled-cheese-poulet-et-oignons-confits-8kf5bdsj6rk2asfy1812',
          4, 19,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pain de mie', 4, 'tranche', 'Pain & Pâtisserie', 0),
    (r, 'Blanc de poulet (tranches)', 2, 'tranche', 'Boucherie & Volaille', 1),
    (r, 'Fromage frais', 60, 'g', 'Crémerie', 2),
    (r, 'Oignon jaune', 100, 'g', 'Fruits & Légumes', 3),
    (r, 'Miel (liquide)', 2, 'c. à c.', 'Épicerie sucrée', 4),
    (r, 'Comté', 40, 'g', 'Crémerie', 5),
    (r, 'Salade (Mélange)', 2, 'poignée', 'Fruits & Légumes', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez puis coupez les oignons en fines lamelles.'),
    (r, 2, 'Faites chauffer un filet d''huile d''olive dans une poêle sur feu moyen. Ajouter les oignons. Salez, poivrez et faites-les revenir 4 à 5 minutes.'),
    (r, 3, 'Ajoutez le miel. Poursuivez la cuisson 8 à 10 minutes, jusqu''à ce que les oignons soient bien caramélisés.'),
    (r, 4, 'Pendant ce temps, coupez le comté en fines lamelles, à l''aide d''un économe.'),
    (r, 5, 'Étalez le fromage frais sur chaque tranche de pain de mie, puis disposez les lamelles de comté par-dessus.'),
    (r, 6, 'Ajoutez ensuite les oignons caramélisés et le jambon de poulet sur l''une des deux tranches. Refermez le grilled cheese avec la seconde tranche de pain.'),
    (r, 7, 'Faites fondre une noisette de beurre dans une poêle, sur feu moyen. Faites revenir le grilled cheese 2 minutes sur chaque face, jusqu''à ce qu''il soit bien doré. Coupez le feu, couvrez la poêle et laissez reposer hors du feu pendant 1 minute.'),
    (r, 8, 'Coupez le grilled cheese poulet & oignons confits en deux, si vous le souhaitez. Servez-le avec la salade verte assaisonnée selon vos goûts et dégustez aussitôt. C''est prêt.');
  raise notice 'Ajoutée : %', 'Grilled cheese poulet & oignons confits';
end
$$;

-- Ravioles sautées aux épinards
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Ravioles sautées aux épinards')) then
    raise notice 'Déjà présente, ignorée : %', 'Ravioles sautées aux épinards';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Ravioles sautées aux épinards', '487 kcal/portion · Note 3,7/5 (397 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-03-202309.png_merge_recipes/QGaAtquG7g.png.jpg', 'https://jow.fr/recipes/ravioles-sautees-aux-epinards-816489cagwds00ur0kgf',
          2, 4,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Ravioles du Dauphiné', 240, 'g', 'Crémerie', 0),
    (r, 'Épinard (frais)', 4, 'poignée', 'Fruits & Légumes', 1),
    (r, 'Noisette', 20, 'g', 'Épicerie sucrée', 2),
    (r, 'Ail', 1, 'gousse', 'Fruits & Légumes', 3),
    (r, 'Parmesan (morceaux)', 40, 'g', 'Crémerie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Pour séparer les plaquettes de ravioles sans les casser, mettez-les au congélateur 10 à 15 minutes. Il vous suffit ensuite de les "casser" comme des quartiers de chocolat. Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez les ravioles du Dauphiné et faites les dorer 3 à 4 minutes, en mélangeant.'),
    (r, 2, 'Faites chauffer une noisette de beurre dans une seconde poêle, sur feu moyen. Ajoutez les épinards et l''ail râpé. Salez, poivrez et faites-les revenir 1 minute.'),
    (r, 3, 'Servez les ravioles dans une assiette avec les épinards. Parsemez de noisettes concassées et de parmesan râpé. Re-assaisonnez selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Ravioles sautées aux épinards';
end
$$;

-- Tagliatelle aux crevettes & chorizo
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tagliatelle aux crevettes & chorizo')) then
    raise notice 'Déjà présente, ignorée : %', 'Tagliatelle aux crevettes & chorizo';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tagliatelle aux crevettes & chorizo', '704 kcal/portion · Note 4,7/5 (3786 avis)', 'https://static.jow.fr/1024x1024/recipes/QLr4OTi2Go1i5A.jpg', 'https://jow.fr/recipes/tagliatelle-aux-crevettes-et-chorizo-8hd1a0fk621skrs615vb',
          2, 10,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (Tagliatelle sèches)', 200, 'g', 'Épicerie salée', 0),
    (r, 'Crevette (cuite)', 160, 'g', 'Poissonnerie', 1),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 2),
    (r, 'Chorizo (entier)', 50, 'g', 'Traiteur & Charcuterie', 3),
    (r, 'Petits pois (surgelés)', 120, 'g', 'Surgelés', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole d''eau bouillante salée, faites cuire les pâtes selon les instructions du paquet. En fin de cuisson, réservez une petite louche d''eau de cuisson puis égouttez-les.'),
    (r, 2, 'Pendant ce temps, enlevez la peau du chorizo, si vous le souhaitez. Coupez-le en fines rondelles.'),
    (r, 3, 'Faites chauffer un petit filet d''huile d''olive dans une poêle, sur feu vif. Ajoutez le chorizo et les crevettes. Faites-les cuire 2 minutes, en mélangeant.'),
    (r, 4, 'Ajoutez les petits pois et la crème fraîche. Salez légèrement, poivrez et poursuivez la cuisson 3 à 4 minutes, sur feu moyen, en mélangeant.'),
    (r, 5, 'Ajoutez les pâtes égouttées avec l''eau de cuisson réservée, si besoin, et mélangez à nouveau.'),
    (r, 6, 'Servez les pâtes aux crevettes & chorizo dans une assiette creuse. Re-assaisonnez selon vos goûts, c''est prêt !');
  raise notice 'Ajoutée : %', 'Tagliatelle aux crevettes & chorizo';
end
$$;

-- Poulet au miel & haricots
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Poulet au miel & haricots')) then
    raise notice 'Déjà présente, ignorée : %', 'Poulet au miel & haricots';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Poulet au miel & haricots', '296 kcal/portion · Note 4,4/5 (1091 avis)', 'https://static.jow.fr/1024x1024/patterns/kale-04-202309.png_merge_recipes/tdd1337mDRrP7Q.png.jpg', 'https://jow.fr/recipes/poulet-au-miel-et-haricots-7y8thdsb2ibk043p00ax',
          4, 13,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Poulet (escalope)', 2, 'pièce', 'Boucherie & Volaille', 0),
    (r, 'Miel (liquide)', 2, 'c. à s.', 'Épicerie sucrée', 1),
    (r, 'Citron jaune', 2, 'quartier', 'Fruits & Légumes', 2),
    (r, 'Haricot vert (frais)', 500, 'g', 'Fruits & Légumes', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Si besoin, équeutez les haricots verts.'),
    (r, 2, 'Dans une casserole d''eau bouillante salée, faites cuire les haricots verts 12 minutes. En fin de cuisson, égouttez-les.'),
    (r, 3, 'Optionnel : afin d''avoir une peau bien dorée, ajoutez l''équivalent d''une cuillère à soupe de farine par personne dans une assiette creuse. Roulez le poulet dans la farine de sorte à bien l''enrober.'),
    (r, 4, 'Faites fondre une noisette de beurre, dans une poêle, sur moyen. Ajoutez le poulet. Salez, poivrez et faites-le revenir 3 à 4 minutes sur chaque face, jusqu''à ce qu''il soit bien doré et cuit à cœur.'),
    (r, 5, 'Ajoutez le jus de citron et le miel. Poursuivez la cuisson 1 à 2 minutes, sur feu vif, en nappant le poulet de la sauce, jusqu''à ce qu''elle commence à caraméliser.'),
    (r, 6, 'Coupez le poulet en lamelles, si vous le souhaitez.'),
    (r, 7, 'Dans une assiette, servez le poulet avec les haricots verts. Nappez le tout du beurre citronné au miel et re-assaisonnez selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Poulet au miel & haricots';
end
$$;

-- Risotto de coquillettes
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Risotto de coquillettes')) then
    raise notice 'Déjà présente, ignorée : %', 'Risotto de coquillettes';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Risotto de coquillettes', '487 kcal/portion · Note 4,6/5 (824 avis)', 'https://static.jow.fr/1024x1024/recipes/mi0IxBiLn9nz6w.jpg', 'https://jow.fr/recipes/risotto-de-coquillettes-842z38rl8axuf6ld0377',
          4, 14,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (coquillettes)', 160, 'g', 'Épicerie salée', 0),
    (r, 'Jambon blanc', 2, 'tranche', 'Traiteur & Charcuterie', 1),
    (r, 'Vin blanc', 40, 'ml', 'Boissons', 2),
    (r, 'Comté', 40, 'g', 'Crémerie', 3),
    (r, 'Crème fraîche', 1, 'c. à s.', 'Crémerie', 4),
    (r, 'Bouillon de volaille (cube)', 0.5, 'pièce', 'Épicerie salée', 5),
    (r, 'Échalote', 0.5, 'pièce', 'Fruits & Légumes', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez et émincez l''échalote.'),
    (r, 2, 'Faites-les rissoler 2 minutes dans une casserole avec une noisette de beurre.'),
    (r, 3, 'Ajoutez les coquillettes et laissez-les dorer 2 minutes.'),
    (r, 4, 'Versez le vin blanc et mélangez jusqu''à absorption.'),
    (r, 5, 'Faites bouillir 25 cl d''eau par personne et faites-y dissoudre le bouillon.'),
    (r, 6, 'Ajoutez une louche de bouillon et mélangez jusqu''à absorption, recommencez l''opération pendant 10 minutes. Goûtez les coquillettes. Continuez la cuisson quelques minutes si elles sont trop fermes.'),
    (r, 7, 'Une fois les coquillettes cuites, salez, poivrez, ajoutez la crème, le comté râpé et mélangez.'),
    (r, 8, 'Roulez les tranches de jambons et coupez-les afin d’obtenir des lamelles.'),
    (r, 9, 'Dressez les coquillettes sur une assiette, ajoutez le jambon et quelques herbes fraîches si vous en avez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Risotto de coquillettes';
end
$$;

-- Tresse feuilletée saumon épinards
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tresse feuilletée saumon épinards')) then
    raise notice 'Déjà présente, ignorée : %', 'Tresse feuilletée saumon épinards';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tresse feuilletée saumon épinards', '460 kcal/portion · Note 4,6/5 (284 avis) · Plat entier : 4 parts.', 'https://static.jow.fr/1024x1024/patterns/yolk-04-202309.png_merge_recipes/PEgzru06lWRNWw.png.jpg', 'https://jow.fr/recipes/tresse-feuilletee-saumon-epinards-8jr86f7uibpsklat14jw',
          12, 35,
          4, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâte feuilletée', 1, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Saumon (frais)', 2, 'pièce', 'Poissonnerie', 1),
    (r, 'Épinards (surgelés)', 250, 'g', 'Surgelés', 2),
    (r, 'Crème fraîche', 4, 'c. à s.', 'Crémerie', 3),
    (r, 'Ail', 1, 'gousse', 'Fruits & Légumes', 4),
    (r, 'Œuf', 1, 'pièce', 'Crémerie', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Faites chauffer une poêle avec un filet d''huile d''olive ou une noisette de beurre. Ajoutez les épinards surgelés, un filet d''eau et couvrez. Faites réchauffer pendant 5 minutes.'),
    (r, 2, 'Une fois les épinards décongelés, éteignez le feu. Ajoutez la crème fraîche et râpez l''ail au dessus des épinards. Salez et poivrez. Mélangez.'),
    (r, 3, 'Étalez votre pâte feuilletée. Déposez les épinards au centre en formant un grand rectangle. Assaisonnez selon vos goûts. Par-dessus, déposez les filets de saumon (si besoin, enlevez la peau).'),
    (r, 4, 'Séparez le blanc du jaune d''œuf et gardez le jaune. Utilisez la moitié de votre jaune d''œuf pour badigeonner les bords de votre pâte. Découpez les côtés de la pâte feuilletée en bandes d’environ 1,5 cm. Refermez-les sur la garniture pour former une tresse.'),
    (r, 5, 'Badigeonnez la tresse avec le reste du jaune d''œuf. Déposez la dans un plat allant au four et enfournez pendant 35 minutes à 180°C.'),
    (r, 6, 'Sortez du four, servez avec une salade ou du riz, c''est prêt !');
  raise notice 'Ajoutée : %', 'Tresse feuilletée saumon épinards';
end
$$;

-- Potimarron rôti & mélange de céréales
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Potimarron rôti & mélange de céréales')) then
    raise notice 'Déjà présente, ignorée : %', 'Potimarron rôti & mélange de céréales';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Potimarron rôti & mélange de céréales', '404 kcal/portion · Note 4,3/5 (56 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-03-202309.png_merge_recipes/ReecVRf38F.png.jpg', 'https://jow.fr/recipes/potimarron-roti-et-melange-de-cereales-81subjvu34c000vm1cj1',
          7, 40,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Potimarron', 0.5, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Chèvre frais', 40, 'g', 'Crémerie', 1),
    (r, 'Mélange céréales', 160, 'g', 'Épicerie salée', 2),
    (r, 'Noisette', 40, 'g', 'Épicerie sucrée', 3),
    (r, 'Oignon rouge', 1, 'pièce', 'Fruits & Légumes', 4),
    (r, 'Menthe (feuilles)', 0.4, 'bouquet', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Lavez, coupez en 2 et videz le potimarron avez une cuillère à soupe, coupez ensuite en quartiers de 3-4 cm.'),
    (r, 2, 'Épluchez les oignons et coupez les en 4.'),
    (r, 3, 'Disposez les legumes sur une plaque de cuisson avec du papier sulfurisé ou dans un plat à gratin. Arrosez le tout avec un filet d''huile d''olive, salez poivrez, puis enfournez pendant 40 minutes.'),
    (r, 4, 'Pendant ce temps, faire cuire les céréales selon les instructions du paquet. Égouttez, mettre de côté.'),
    (r, 5, 'Optionnel : Hachez les noisettes.'),
    (r, 6, 'Sortez les légumes rôtis du four.'),
    (r, 7, 'Servir les céréales, ajoutez les légumes rôtis, le chèvre émietté, (optionnel: les noisettes concassées et les herbes fraîches si vous en avez), salez poivrez, ajoutez un filet d''huile d''olive, c''est prêt ! Se mange aussi bien chaud que froid.');
  raise notice 'Ajoutée : %', 'Potimarron rôti & mélange de céréales';
end
$$;

-- Farfalle & fondue de poireaux
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Farfalle & fondue de poireaux')) then
    raise notice 'Déjà présente, ignorée : %', 'Farfalle & fondue de poireaux';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Farfalle & fondue de poireaux', '527 kcal/portion · Note 4,6/5 (1545 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-02-202309.png_merge_recipes/foZcUQ0z0ya6CQ.png.jpg', 'https://jow.fr/recipes/farfalle-et-fondue-de-poireaux-8ecqhkpm5cd310o6124m',
          4, 18,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (Farfalle)', 200, 'g', 'Épicerie salée', 0),
    (r, 'Poireau', 240, 'g', 'Fruits & Légumes', 1),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 2),
    (r, 'Parmesan (râpé)', 30, 'g', 'Crémerie', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Coupez les extrémités des poireaux* pour ne garder que le blanc. Émincez-les finement, puis placez-les dans une passoire et rincez abondamment pour retirer les impuretés.'),
    (r, 2, 'Faites fondre une noisette de beurre dans une poêle, sur feu vif. Ajoutez les poireaux et faites-les revenir 2 minutes, en mélangeant. Baissez le feu sur moyen, puis couvrez et poursuivez la cuisson 5 minutes.'),
    (r, 3, 'En parallèle, dans une casserole d''eau bouillante salée, faites cuire les pâtes selon les instructions du paquet.'),
    (r, 4, 'Vérifiez la cuisson des poireaux, puis ajoutez la crème fraîche. Salez, poivrez et mélangez. Poursuivez la cuisson 4 à 5 minutes.'),
    (r, 5, 'Une fois cuites, égouttez les pâtes.'),
    (r, 6, 'Ajoutez les pâtes et le parmesan râpé dans la poêle avec la fondue de poireaux. Re-assaisonnez selon vos goûts et mélangez bien.'),
    (r, 7, 'Servez les pâtes et la fondue de poireaux dans une assiette avec la protéine de votre choix - ex : poulet, saumon ou œuf au plat. Parsemez de parmesan râpé et re-assaisonnez selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Farfalle & fondue de poireaux';
end
$$;

-- Butternut & saucisses rôties
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Butternut & saucisses rôties')) then
    raise notice 'Déjà présente, ignorée : %', 'Butternut & saucisses rôties';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Butternut & saucisses rôties', '485 kcal/portion · Note 4,4/5 (245 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-03-202309.png_merge_recipes/AGhsZfmXlTHEGA.png.jpg', 'https://jow.fr/recipes/butternut-et-saucisses-roties-8dk2acu0kn042gs50r9r',
          10, 35,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Courge butternut', 500, 'g', 'Fruits & Légumes', 0),
    (r, 'Saucisse (fumée)', 160, 'g', 'Boucherie & Volaille', 1),
    (r, 'Épinard (frais)', 4, 'poignée', 'Fruits & Légumes', 2),
    (r, 'Mélange céréales', 80, 'g', 'Épicerie salée', 3),
    (r, 'Oignon rouge', 0.5, 'pièce', 'Fruits & Légumes', 4),
    (r, 'Herbes de Provence', 1, 'c. à c.', 'Épicerie salée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Si vous le souhaitez, épluchez la courge butternut. Coupez-la en 2 dans la longueur. Videz-la puis coupez-la en cubes.'),
    (r, 2, 'Dans une casserole d''eau bouillante salée, ajoutez le mélange de céréales. Faites-le cuire selon les indications du paquet. En fin de cuisson, égouttez-le.'),
    (r, 3, 'En parallèle, dans une seconde casserole d''eau bouillante salée, ajoutez la courge. Faites-la pré-cuire 3 à 4 minutes.'),
    (r, 4, 'Pendant ce temps, coupez les saucisses en rondelles.'),
    (r, 5, 'Épluchez puis coupez les oignons rouges en quartiers.'),
    (r, 6, 'Au bout de 3 à 4 minutes, ajoutez les épinards dans la casserole avec la courge. Poursuivez la cuisson 2 minutes, puis égouttez le tout.'),
    (r, 7, 'Dans un plat allant au four, ajoutez : le butternut, les épinards, les oignons, les saucisses et le mélange de céréales. Salez, poivrez et ajoutez les herbes de Provence. Badigeonnez le tout d''un filet d''huile d''olive, puis mélangez. Enfournez 25 minutes à 200°C.'),
    (r, 8, 'Une fois les légumes bien dorés et grillés, sortez le plat du four. Servez dans une assiette accompagné d''une salade verte. C''est prêt !');
  raise notice 'Ajoutée : %', 'Butternut & saucisses rôties';
end
$$;

-- Galette chèvre miel
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Galette chèvre miel')) then
    raise notice 'Déjà présente, ignorée : %', 'Galette chèvre miel';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Galette chèvre miel', '474 kcal/portion · Note 4,5/5 (332 avis)', 'https://static.jow.fr/1024x1024/patterns/kale-02-202309.png_merge_recipes/BN176An1hiDO1A.png.jpg', 'https://jow.fr/recipes/galette-chevre-miel-89bqc35fffyq8jk919ps',
          1, 4,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Galette bretonne', 2, 'pièce', 'Crémerie', 0),
    (r, 'Chèvre frais', 80, 'g', 'Crémerie', 1),
    (r, 'Crème fraîche', 1, 'c. à s.', 'Crémerie', 2),
    (r, 'Noix', 20, 'g', 'Épicerie sucrée', 3),
    (r, 'Miel (liquide)', 2, 'c. à c.', 'Épicerie sucrée', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Faites fondre une noisette de beurre dans une crêpière ou une grande poêle, sur feu moyen. Déposez-y la galette au sarrasin.'),
    (r, 2, 'Ajoutez le chèvre frais en morceaux, la crème et les noix concassées sur la galette. Laissez cuire 1 à 2 minutes.'),
    (r, 3, 'Une fois le fromage fondu, repliez la galette en carré ou en demi lune. Poursuivez la cuisson 1 minute supplémentaire.'),
    (r, 4, 'Dans une assiette, servez la galette avec un filet de miel par-dessus. Accompagnez-la d''une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Galette chèvre miel';
end
$$;

-- Cake tomates mozza & olives
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Cake tomates mozza & olives')) then
    raise notice 'Déjà présente, ignorée : %', 'Cake tomates mozza & olives';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Cake tomates mozza & olives', '384 kcal/portion · Note 4,8/5 (356 avis) · Plat entier : 6 parts.', 'https://static.jow.fr/1024x1024/patterns/kale-04-202309.png_merge_recipes/4IvWVC2wYPRv3g.png.jpg', 'https://jow.fr/recipes/cake-tomates-mozza-et-olives-8gf5fnhfijht0ik50cod',
          10, 40,
          6, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Tomates séchées', 80, 'g', 'Épicerie salée', 0),
    (r, 'Mozzarella (boule)', 100, 'g', 'Crémerie', 1),
    (r, 'Olives vertes (dénoyautées)', 80, 'g', 'Épicerie salée', 2),
    (r, 'Fromage râpé', 100, 'g', 'Crémerie', 3),
    (r, 'Farine de blé', 150, 'g', 'Épicerie salée', 4),
    (r, 'Œuf', 3, 'pièce', 'Crémerie', 5),
    (r, 'Lait', 125, 'ml', 'Crémerie', 6),
    (r, 'Huile d''olive', 60, 'ml', 'Épicerie salée', 7),
    (r, 'Levure chimique', 1, 'sachet', 'Épicerie sucrée', 8);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Dans un saladier, ajoutez : la farine, les œufs et la levure. Salez, poivrez et mélangez, à l''aide d''un fouet.'),
    (r, 2, 'Ajoutez : l''huile d''olive et le lait. Mélangez à nouveau.'),
    (r, 3, 'Ajoutez ensuite : le fromage râpé, les tomates séchées, les olives et la mozzarella déchirée. Mélangez le tout, à l''aide d''une spatule.'),
    (r, 4, 'Tapissez un moule à cake (le nôtre fait 29 x 10 cm) de papier cuisson. Versez-y la pâte, puis enfournez 40 minutes à 180°C.'),
    (r, 5, 'Une fois que le cake est bien doré, plantez votre couteau au centre. S''il ressort propre, le cake est prêt, sinon re-enfournez 2 à 3 minutes. Servez le cake tomates mozza & olives à l''apéro ou avec une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Cake tomates mozza & olives';
end
$$;

-- Tarte rustique oignons & raclette
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tarte rustique oignons & raclette')) then
    raise notice 'Déjà présente, ignorée : %', 'Tarte rustique oignons & raclette';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tarte rustique oignons & raclette', '366 kcal/portion · Note 4,5/5 (547 avis) · Plat entier : 6 parts.', 'https://static.jow.fr/1024x1024/patterns/kale-03-202309.png_merge_recipes/Q90himz5NpFKtw.png.jpg', 'https://jow.fr/recipes/tarte-rustique-oignons-et-raclette-83ijelmpizx31qkv0v9c',
          10, 40,
          6, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâte brisée', 1, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Raclette', 200, 'g', 'Crémerie', 1),
    (r, 'Oignon jaune', 4, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Moutarde à l''ancienne', 1, 'c. à s.', 'Épicerie salée', 3),
    (r, 'Crème fraîche', 4, 'c. à s.', 'Crémerie', 4),
    (r, 'Salade (Mélange)', 6, 'poignée', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Épluchez et émincez les oignons.'),
    (r, 2, 'Faites-les revenir dans une poêle avec une noisette de beurre. Ajoutez un fond d''eau, couvrez puis laissez mijoter 5 minutes.'),
    (r, 3, 'Pendant ce temps, mélangez la crème, la moutarde, une pincée de sel et du poivre.'),
    (r, 4, 'Retirez le couvercle les oignons et cuire 5 minutes supplémentaires. Salez, poivrez.'),
    (r, 5, 'Coupez le fromage à raclette en petits dés.'),
    (r, 6, 'L''eau des oignons doit s''évaporer totalement.'),
    (r, 7, 'Disposez la pâte sur une surface plane. Étalez le mélange crème-moutarde sur la pâte en laissant 2 à 3 cm sur les bords.'),
    (r, 8, 'Disposez les oignons, le fromage à raclette, poivrez puis repliez les bords vers l''intérieur.'),
    (r, 9, 'Enfournez à 200°C pendant 30 minutes jusqu''à ce que le fromage soit bien doré.'),
    (r, 10, 'A déguster avec une petite salade verte avec une vinaigrette à la moutarde à l''ancienne par exemple. C''est prêt !');
  raise notice 'Ajoutée : %', 'Tarte rustique oignons & raclette';
end
$$;

-- Classic Cheeseburger
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Classic Cheeseburger')) then
    raise notice 'Déjà présente, ignorée : %', 'Classic Cheeseburger';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Classic Cheeseburger', '663 kcal/portion · Note 4,7/5 (1223 avis)', 'https://static.jow.fr/1024x1024/recipes/7fw8eErB9n2mKg.jpg', 'https://jow.fr/recipes/classic-cheeseburger-87qad40l8pgw6wh21ax4',
          9, 40,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Yellow mustard', 1, 'c. à c.', 'Épicerie salée', 0),
    (r, 'Ketchup', 2, 'c. à c.', 'Épicerie salée', 1),
    (r, 'Oignon rouge', 0.25, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Pommes de terre', 300, 'g', 'Fruits & Légumes', 3),
    (r, 'Salade (coeur de laitue)', 20, 'g', 'Fruits & Légumes', 4),
    (r, 'Pain burger', 2, 'pièce', 'Pain & Pâtisserie', 5),
    (r, 'Cheddar (tranches)', 2, 'tranche', 'Crémerie', 6),
    (r, 'Bœuf (steak haché frais)', 2, 'pièce', 'Boucherie & Volaille', 7);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Si besoin, faites décongeler les steaks hachés. Préchauffez votre four à 200°C. Coupez les pommes de terre en frites.'),
    (r, 2, 'Rincez les frites à l''eau froide.'),
    (r, 3, 'Placez les frites dans un bol. Salez et poivrez selon vos goûts, ajoutez 1 c. à soupe d''huile d''olive par personne et mélangez.'),
    (r, 4, 'Placez les pommes de terre sur une plaque allant au four. Enfournez 40 minutes à 200°C.'),
    (r, 5, 'Coupez les oignons en deux puis émincez-les finement.'),
    (r, 6, 'Dans un récipient ajoutez les steaks, salez, poivrez, malaxez puis reformez les steaks.'),
    (r, 7, '5 minutes avant la fin de la cuisson des frites, cuire les steaks dans une poêle bien chaude : 2 minutes sur chaque face pour une cuisson saignante.'),
    (r, 8, 'Une fois le steak retourné une fois, ajoutez le cheddar sur le dessus. Terminez la cuisson selon vos goûts.'),
    (r, 9, 'Profitez-en pour faire dorer vos pains dans la poêle ayant servie à la cuisson des steaks : 15 à 30 secondes pour qu''ils soient juste dorés.'),
    (r, 10, 'Ajoutez la moutarde et le ketchup sur les pains à burger, ajoutez la salade, le steak une fois cuit, les oignons puis refermez le burger.'),
    (r, 11, 'Sortez les frites du four, une fois qu''elles sont bien croustillantes.'),
    (r, 12, 'Servez le burger avec les frites, c''est prêt !');
  raise notice 'Ajoutée : %', 'Classic Cheeseburger';
end
$$;

-- Galette savoyarde
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Galette savoyarde')) then
    raise notice 'Déjà présente, ignorée : %', 'Galette savoyarde';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Galette savoyarde', '686 kcal/portion · Note 4,7/5 (684 avis)', 'https://static.jow.fr/1024x1024/recipes/hlmCDAeAgsnWoA.jpg', 'https://jow.fr/recipes/galette-savoyarde-89c69iku5tua84mp07vb',
          5, 15,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Galette bretonne', 2, 'pièce', 'Crémerie', 0),
    (r, 'Reblochon', 80, 'g', 'Crémerie', 1),
    (r, 'Pommes de terre', 200, 'g', 'Fruits & Légumes', 2),
    (r, 'Lardons', 80, 'g', 'Traiteur & Charcuterie', 3),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 4),
    (r, 'Salade (Mélange)', 2, 'poignée', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Lavez puis coupez les pommes de terre en rondelles.'),
    (r, 2, 'Dans une casserole d’eau bouillante salée, ajoutez les pommes de terre. Faites-les cuire 10 à 12 minutes, sur feu moyen. Égouttez-les en fin de cuisson.'),
    (r, 3, 'Pendant ce temps, épluchez puis émincez les oignons.'),
    (r, 4, 'Dans une poêle chaude, ajoutez les lardons et les oignons. Faites-les revenir 6 à 8 minutes, en mélangeant, jusqu''à ce qu''ils soient bien dorés.'),
    (r, 5, 'Pendant ce temps, coupez le reblochon en lamelles.'),
    (r, 6, 'Faites fondre une noisette de beurre dans une crêpière ou dans une grande poêle, sur feu moyen. Déposez-y la galette au sarrasin.'),
    (r, 7, 'Ajoutez les pommes de terre suivies du mélange lardons/oignons, puis des tranches de reblochon. Poivrez et laissez cuire 2 minutes.'),
    (r, 8, 'Une fois le reblochon fondu, repliez la galette en carré ou en demi-lune. Poursuivez la cuisson 1 minute supplémentaire.'),
    (r, 9, 'Servez la galette savoyarde dans une assiette avec la salade assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Galette savoyarde';
end
$$;

-- Soupe potimarron & jambon
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Soupe potimarron & jambon')) then
    raise notice 'Déjà présente, ignorée : %', 'Soupe potimarron & jambon';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Soupe potimarron & jambon', '319 kcal/portion · Note 4,7/5 (107 avis)', 'https://static.jow.fr/1024x1024/patterns/kale-01-202309.png_merge_recipes/cfIigQhKhiGAgQ.png.jpg', 'https://jow.fr/recipes/soupe-potimarron-et-jambon-87yhc5v44xvk3apd19l4',
          5, 20,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Potimarron', 1, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Crème liquide', 100, 'ml', 'Crémerie', 1),
    (r, 'Jambon cru', 2, 'tranche', 'Traiteur & Charcuterie', 2),
    (r, 'Échalote', 1, 'pièce', 'Fruits & Légumes', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez et émincez l''échalote.'),
    (r, 2, 'Coupez le potimarron en deux, videz-le, coupez-le en tranches puis en cubes.'),
    (r, 3, 'Dans une casserole, ajoutez une noisette de beurre et faites rissolez les cubes de potimarron et l''échalote pendant 3 minutes à feu vif.'),
    (r, 4, 'Salez et couvrez le potimarron d''eau à niveau, couvrez et laissez cuire 15 minutes.'),
    (r, 5, 'Pendant ce temps, faites chauffer une poêle et placez-y les tranches de jambon. Saisissez-les, à feu vif, 1 minute de chaque côté.'),
    (r, 6, 'Après 15 minutes de cuisson, mixez la soupe, (Optionnel : ajoutez de l''eau pour rectifier la texture). Ajoutez la crème fraîche et mixez à nouveau rapidement.'),
    (r, 7, 'Servez la soupe avec les chips de jambon, c''est prêt !');
  raise notice 'Ajoutée : %', 'Soupe potimarron & jambon';
end
$$;

-- Velouté d'endives
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Velouté d''endives')) then
    raise notice 'Déjà présente, ignorée : %', 'Velouté d''endives';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Velouté d''endives', '119 kcal/portion · Note 3,6/5 (38 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-04-202309.png_merge_recipes/2OS5QrLaroaqcw.png.jpg', 'https://jow.fr/recipes/veloute-d-endives-8eqohh99bbwikptt00t1',
          6, 22,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Endives', 600, 'g', 'Fruits & Légumes', 0),
    (r, 'Échalote', 1, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Bouillon de légumes (cube)', 0.5, 'pièce', 'Épicerie salée', 2),
    (r, 'Crème fraîche', 30, 'g', 'Crémerie', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Lavez puis coupez les endives en rondelles en retirant le cœur. Réservez les premières feuilles pour la décoration.'),
    (r, 2, 'Épluchez puis coupez les échalotes en rondelles fines.'),
    (r, 3, 'Faites fondre une noisette de beurre dans une casserole, sur feu moyen. Ajoutez les échalotes et faites-les revenir 1 minute, en mélangeant.'),
    (r, 4, 'Ajoutez ensuite les endives.* Mélangez et faites revenir le tout 5 à 6 minutes.'),
    (r, 5, 'Ajoutez 150 ml d''eau par personne et le bouillon cube. Mélangez, couvrez et laissez mijoter 15 minutes, sur feu moyen.'),
    (r, 6, 'Vérifiez la cuisson des endives, puis ajoutez la crème fraîche. Mélangez et re-assaisonnez selon vos goûts.'),
    (r, 7, 'Mixez le tout pour obtenir un velouté onctueux. Si besoin, ajoutez un peu d’eau et mixez à nouveau.'),
    (r, 8, 'Servez le velouté d''endives dans un bol ou une assiette creuse. Ajoutez les feuilles réservés et re-assaisonnez selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Velouté d''endives';
end
$$;

-- Tomato soup
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tomato soup')) then
    raise notice 'Déjà présente, ignorée : %', 'Tomato soup';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tomato soup', '146 kcal/portion · Note 4,5/5 (71 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-04-202309.png_merge_recipes/g7DzusdGA4uclg.png.jpg', 'https://jow.fr/recipes/tomato-soup-8e4z5aj8lapt196f02o3',
          4, 12,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Tomate pelée', 400, 'g', 'Épicerie salée', 0),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Bouillon de légumes (cube)', 0.5, 'pièce', 'Épicerie salée', 2),
    (r, 'Basilic (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 3),
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 4),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Faites fondre une noisette de beurre dans une casserole et ajoutez les oignons et l''ail émincés.'),
    (r, 2, 'Faites revenir 2 minutes à feu vif.'),
    (r, 3, 'Pendant ce temps, préparez le bouillon : diluez le cube avec 200 ml d''eau bouillante/personne.'),
    (r, 4, 'Ajoutez les tomates et le bouillon (200 ml/personne).'),
    (r, 5, 'Salez, poivrez, ajoutez le basilic, mélangez et faites cuire 10 minutes à couvert, à feu moyen.'),
    (r, 6, 'Après 10 minutes de cuisson, ajoutez la crème et mixez la soupe.'),
    (r, 7, 'Versez la soupe dans les bols ajoutez un peu de crème pour le service. C''est prêt !');
  raise notice 'Ajoutée : %', 'Tomato soup';
end
$$;

-- Cabillaud au lard & purée de potimarron
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Cabillaud au lard & purée de potimarron')) then
    raise notice 'Déjà présente, ignorée : %', 'Cabillaud au lard & purée de potimarron';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Cabillaud au lard & purée de potimarron', '215 kcal/portion · Note 4,5/5 (478 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-01-202309.png_merge_recipes/HIL6lwStTu9Q9w.png.jpg', 'https://jow.fr/recipes/cabillaud-au-lard-et-puree-de-potimarron-8fxk3ews7683hi920i47',
          4, 20,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Potimarron', 0.5, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Lard (tranches)', 4, 'tranche', 'Traiteur & Charcuterie', 1),
    (r, 'Cabillaud (frais)', 2, 'pièce', 'Poissonnerie', 2),
    (r, 'Salade (roquette)', 2, 'poignée', 'Fruits & Légumes', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Lavez, évidez puis coupez la courge en deux. Coupez-la ensuite en cubes à l''aide d''un bon couteau.'),
    (r, 2, 'Versez les cubes de courge dans la casserole d''eau bouillante. Laissez cuire 20 minutes à feu moyen.'),
    (r, 3, 'Pendant ce temps, enveloppez chaque dos de cabillaud préalablement salé et poivré dans 2 fines tranches de lard.'),
    (r, 4, 'Faites chauffer une poêle avec une noisette de beurre. Faites dorer le dos de cabillaud sur toutes les faces, couvrez et laissez cuire 6 à 8 minutes sur feu moyen.'),
    (r, 5, 'Égouttez la courge. Ajoutez une noisette de beurre, salez, poivrez puis mixez. Vous devez obtenir une purée lisse.'),
    (r, 6, 'Servez la purée avec le cabillaud, salez, poivrez, c''est prêt ! (Optionnel : vous pouvez ajouter quelques feuilles de roquette).');
  raise notice 'Ajoutée : %', 'Cabillaud au lard & purée de potimarron';
end
$$;

-- Tomato soup & grilled cheese
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tomato soup & grilled cheese')) then
    raise notice 'Déjà présente, ignorée : %', 'Tomato soup & grilled cheese';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tomato soup & grilled cheese', '493 kcal/portion · Note 4,7/5 (119 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-04-202309.png_merge_recipes/iHMV1pO0LEJmRA.png.jpg', 'https://jow.fr/recipes/tomato-soup-et-grilled-cheese-8jgr85040ejkkumm0mwf',
          4, 12,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Tomate pelée', 400, 'g', 'Épicerie salée', 0),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Bouillon de légumes (cube)', 0.5, 'pièce', 'Épicerie salée', 2),
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 3),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 4),
    (r, 'Mozzarella (râpée)', 40, 'g', 'Crémerie', 5),
    (r, 'Cheddar (râpé)', 40, 'g', 'Crémerie', 6),
    (r, 'Pain de mie', 4, 'tranche', 'Pain & Pâtisserie', 7);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez et émincez les oignons jaunes.'),
    (r, 2, 'Faites fondre une noisette de beurre ou versez un filet d''huile d''olive dans une casserole et ajoutez les oignons. Râpez l''ail et faites revenir 2 minutes à feu vif.'),
    (r, 3, 'Ajoutez les tomates, le bouillon de légumes et 200 ml d''eau / personne. Mélangez et couvrez. Faites cuire 10 minutes à couvert, à feu moyen.'),
    (r, 4, 'Pendant ce temps, beurrez deux tranches de pain de mie par personne.'),
    (r, 5, 'Du côté non beurré des tranches, ajoutez les fromages râpés et refermez le sandwich.'),
    (r, 6, 'Dans une poêle à feu vif, faites griller le sandwich 3 minutes sur chaque face jusqu''à ce que le fromage fonde. Réservez au chaud le temps de mixer la soupe.'),
    (r, 7, 'Après 10 minutes de cuisson, salez, poivrez et mixez la soupe.'),
    (r, 8, 'Versez la soupe dans les bols. Ajoutez si vous le souhaitez une cuillère à soupe de crème par personne, et quelques feuilles de basilic si vous en avez. Servez les grilled cheese et trempez-les dans la soupe. C''est prêt !');
  raise notice 'Ajoutée : %', 'Tomato soup & grilled cheese';
end
$$;

-- Risotto aux poivrons
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Risotto aux poivrons')) then
    raise notice 'Déjà présente, ignorée : %', 'Risotto aux poivrons';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Risotto aux poivrons', '345 kcal/portion · Note 4,5/5 (274 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-05-202309.png_merge_recipes/7DcZ0bj9ZWPBqA.png.jpg', 'https://jow.fr/recipes/risotto-aux-poivrons-88fw0plf954hhii00jvd',
          8, 25,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Riz (Arborio)', 140, 'g', 'Épicerie salée', 0),
    (r, 'Poivron rouge', 1, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Bouillon de légumes (cube)', 0.5, 'pièce', 'Épicerie salée', 2),
    (r, 'Parmesan (râpé)', 2, 'c. à s.', 'Crémerie', 3),
    (r, 'Vin blanc', 40, 'ml', 'Boissons', 4),
    (r, 'Échalote', 0.5, 'pièce', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez puis ciselez finement les échalotes.'),
    (r, 2, 'Lavez puis coupez les poivrons en retirant le cœur avec les pépins. Coupez-les en fines lamelles.'),
    (r, 3, 'Faites fondre une noisette de beurre dans une casserole, sur feu moyen. Ajoutez les échalotes et les poivrons. Faites revenir le tout 3 à 4 minutes, en mélangeant.'),
    (r, 4, 'Ajoutez le riz et faites-le dorer 2 à 3 minutes, en mélangeant.'),
    (r, 5, 'Déglacez au vin blanc Mélangez jusqu''à absorption.'),
    (r, 6, 'Préparez le bouillon. Faites bouillir 250 ml d''eau par personne puis faites-y dissoudre le bouillon.'),
    (r, 7, 'Ajoutez le bouillon petit à petit. Mélangez à chaque ajout et laissez le bouillon s''évaporer avant de recommencer l''opération, jusqu''à épuisement du bouillon.'),
    (r, 8, 'Vérifiez la cuisson du riz, puis ajoutez une noisette de beurre (optionnel) et le parmesan râpé. Salez, poivrez et mélangez.'),
    (r, 9, 'Servez le risotto de poivrons avec un peu de poivre et des copeaux de parmesan. C''est prêt !');
  raise notice 'Ajoutée : %', 'Risotto aux poivrons';
end
$$;

-- Burger caprese & frites maison
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Burger caprese & frites maison')) then
    raise notice 'Déjà présente, ignorée : %', 'Burger caprese & frites maison';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Burger caprese & frites maison', '766 kcal/portion · Note 4,6/5 (143 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-03-202309.png_merge_recipes/o2MNpxpTlGE6iQ.png.jpg', 'https://jow.fr/recipes/burger-caprese-et-frites-maison-87qa8ck58pgw6wh21aue',
          9, 40,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Sauce pesto', 1, 'c. à s.', 'Épicerie salée', 0),
    (r, 'Mozzarella (boule)', 1, 'pièce', 'Crémerie', 1),
    (r, 'Bœuf (steak haché frais)', 2, 'pièce', 'Boucherie & Volaille', 2),
    (r, 'Pommes de terre', 300, 'g', 'Fruits & Légumes', 3),
    (r, 'Pain burger', 2, 'pièce', 'Pain & Pâtisserie', 4),
    (r, 'Tomate', 0.5, 'pièce', 'Fruits & Légumes', 5),
    (r, 'Origan (séché)', 2, 'pincée', 'Épicerie salée', 6),
    (r, 'Salade (roquette)', 2, 'poignée', 'Fruits & Légumes', 7);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Si besoin, faites décongeler les steaks hachés. Préchauffez votre four à 200°C. Coupez les pommes de terre en frites.'),
    (r, 2, 'Rincez-les à l''eau froide puis égouttez-les.'),
    (r, 3, 'Placez-les dans le bol avec 1 c. à soupe d''huile d''olive/personne, (optionnel : de l''origan si vous en avez) salez, poivrez, mélangez.'),
    (r, 4, 'Placez les pommes de terre sur une plaque allant au four. Répartissez-les. Si besoin faire plusieurs plaques. Enfournez 40 minutes à 200°C.'),
    (r, 5, 'Pendant ce temps, lavez, puis coupez les tomates en fines tranches.'),
    (r, 6, 'Dans un récipient ajoutez les steaks hachés, salez, poivrez, malaxez puis reformez-les.'),
    (r, 7, '5 minutes avant la fin de la cuisson des frites, cuire les steak dans une poêle bien chaude, 2 minutes sur une face.'),
    (r, 8, 'Retournez-les, ajoutez la mozzarella déchirée sur le dessus. Terminez la cuisson à feu moyen selon vos goûts.'),
    (r, 9, 'Profitez-en pour faire dorer vos pains : 15 à 30 secondes suffisent pour qu''ils soient juste dorés.'),
    (r, 10, 'Retirez les steaks de la poêle et placez-les sur la partie inférieure des pains à burger, ajoutez les rondelles de tomate, la roquette et tartinez la partie supérieure des pains avec le pesto.'),
    (r, 11, 'Refermez les burgers, servez-les avec les frites, c''est prêt !');
  raise notice 'Ajoutée : %', 'Burger caprese & frites maison';
end
$$;

-- Saumon & butternut rôti
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Saumon & butternut rôti')) then
    raise notice 'Déjà présente, ignorée : %', 'Saumon & butternut rôti';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Saumon & butternut rôti', '392 kcal/portion · Note 4,6/5 (552 avis)', 'https://static.jow.fr/1024x1024/patterns/kale-01-202309.png_merge_recipes/ibBnoSKeDT.png.jpg', 'https://jow.fr/recipes/saumon-et-butternut-roti-82e3eqp94ids00sl0wbf',
          6, 30,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Saumon (frais)', 2, 'pièce', 'Poissonnerie', 0),
    (r, 'Courge butternut', 0.5, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Yaourt Grec', 4, 'c. à s.', 'Crémerie', 2),
    (r, 'Moutarde douce', 2, 'c. à c.', 'Épicerie salée', 3),
    (r, 'Estragon (séché)', 0.5, 'c. à c.', 'Épicerie salée', 4),
    (r, 'Sirop d''érable', 2, 'c. à s.', 'Épicerie sucrée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Si besoin, faites décongeler le saumon. Préchauffez le four à 220°C. Lavez puis coupez la courge en deux, puis videz-la. Coupez-la en rondelles fines, puis en bâtonnets d''environ 1 cm d''épaisseur.'),
    (r, 2, 'Sur une plaque recouverte de papier cuisson, disposez les bâtonnets de courge. Badigeonnez-les d''un filet de sirop d''érable et d''huile d''olive. Salez, poivrez puis enfournez 20 minutes à 220°C.'),
    (r, 3, 'Pendant ce temps, préparez la sauce au yaourt. Dans un bol, mélangez : le yaourt grec, la moutarde et l''estragon. Salez et poivrez.'),
    (r, 4, 'Au bout de 20 minutes de cuisson, sortez la plaque du four et ajoutez-y les filets de saumon. Nappez-les d''un filet de sirop d''érable, puis re-enfournez 10 minutes à 220°C.'),
    (r, 5, 'Une fois les légumes bien dorés et le saumon cuit à cœur, sortez la plaque du four et servez le saumon & butternut rôtis dans une assiette. Nappez le tout de la sauce au yaourt et re-assaisonnez selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Saumon & butternut rôti';
end
$$;

-- Blanquette express aux crevettes
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Blanquette express aux crevettes')) then
    raise notice 'Déjà présente, ignorée : %', 'Blanquette express aux crevettes';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Blanquette express aux crevettes', '423 kcal/portion · Note 4,7/5 (1325 avis)', 'https://static.jow.fr/1024x1024/recipes/507w50maMi3wCw.jpg', 'https://jow.fr/recipes/blanquette-express-aux-crevettes-83qk60bnfo5j5oc20pxm',
          10, 25,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Crevette (cuite)', 200, 'g', 'Poissonnerie', 0),
    (r, 'Riz (cuit)', 220, 'g', 'Épicerie salée', 1),
    (r, 'Carotte (frais)', 160, 'g', 'Fruits & Légumes', 2),
    (r, 'Poireau', 160, 'g', 'Fruits & Légumes', 3),
    (r, 'Champignons bruns', 160, 'g', 'Fruits & Légumes', 4),
    (r, 'Bouillon de légumes (cube)', 0.5, 'pièce', 'Épicerie salée', 5),
    (r, 'Crème liquide', 60, 'ml', 'Crémerie', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Si besoin, faites décongeler les crevettes. Épluchez puis coupez les carottes en rondelles.'),
    (r, 2, 'Coupez les extrémités des poireaux pour ne garder que le blanc. Coupez-les en demi-lunes, puis placez-les dans une passoire et rincez abondamment pour retirer les impuretés.'),
    (r, 3, 'Lavez puis coupez les champignons en fines lamelles.'),
    (r, 4, 'Faites chauffer un filet d''huile d''olive dans une grande casserole ou un fait-tout, sur feu moyen. Ajoutez les carottes, les poireaux et les champignons. Salez, poivrez et faites-les revenir 4 à 5 minutes, en mélangeant.'),
    (r, 5, 'Ajoutez les crevettes, le bouillon cube, 80 ml d''eau par personne et la crème liquide. Mélangez bien, puis couvrez et laissez mijoter 15 à 20 minutes, sur feu doux.'),
    (r, 6, 'En fin de cuisson, préparez le riz selon les instructions du paquet. Servez-le avec la blanquette de crevettes. Re-assaisonnez selon vos goûts, c''est prêt !');
  raise notice 'Ajoutée : %', 'Blanquette express aux crevettes';
end
$$;

-- Quiche au comté & poireaux
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Quiche au comté & poireaux')) then
    raise notice 'Déjà présente, ignorée : %', 'Quiche au comté & poireaux';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Quiche au comté & poireaux', '348 kcal/portion · Note 4,7/5 (1435 avis) · Plat entier : 6 parts.', 'https://static.jow.fr/1024x1024/patterns/beet-03-202309.png_merge_recipes/4nw2HzEpgCALCw.png.jpg', 'https://jow.fr/recipes/quiche-au-comte-et-poireaux-8joxkaooivr4k8r401xw',
          15, 58,
          6, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Poireau', 2, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Œuf', 3, 'pièce', 'Crémerie', 1),
    (r, 'Lait', 100, 'ml', 'Crémerie', 2),
    (r, 'Crème liquide', 100, 'ml', 'Crémerie', 3),
    (r, 'Pâte feuilletée', 1, 'pièce', 'Pain & Pâtisserie', 4),
    (r, 'Comté', 130, 'g', 'Crémerie', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Placez la pâte dans votre moule à tarte (le nôtre fait 25 cm de diamètre) et piquez-la à l''aide d''une fourchette. Une fois le four chaud, faites pré-cuire votre pâte pendant 5 minutes.'),
    (r, 2, 'Retirez le vert des poireaux* et lavez-les. Coupez les en 2 dans le sens de la longueur puis en fines lamelles.'),
    (r, 3, 'Dans une poêle chaude, ajoutez une noisette de beurre (ou d''huile d''olive) et faites revenir les poireaux 2 minutes environ. Salez, poivrez puis ajoutez un filet d''eau. Couvrez la poêle. Laissez cuire 6 minutes supplémentaires.'),
    (r, 4, 'Sortez la pâte du four et réservez.'),
    (r, 5, 'Pendant ce temps, dans un saladier, ajoutez les œufs, le lait et la crème. Salez, poivrez, et mélangez avec un fouet jusqu''à l''obtention d''une texture homogène.'),
    (r, 6, 'Une fois que les poireaux sont cuits, versez-les dans le moule à tarte.'),
    (r, 7, 'Ajoutez le comté râpé. Versez ensuite votre préparation à base d''œufs, salez et poivrez selon vos préférences. Enfournez pendant 45 minutes à 180°C. Sortez du four, c''est prêt !');
  raise notice 'Ajoutée : %', 'Quiche au comté & poireaux';
end
$$;

-- Salade pomme pesto, persil & noix
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Salade pomme pesto, persil & noix')) then
    raise notice 'Déjà présente, ignorée : %', 'Salade pomme pesto, persil & noix';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Salade pomme pesto, persil & noix', '566 kcal/portion · Note 4,1/5 (27 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-01-202309.png_merge_recipes/Cv2JNrVE7B.png.jpg', 'https://jow.fr/recipes/salade-pomme-pesto-persil-et-noix-838hihe8bfs30a4c1b91',
          10, 0,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Ail', 0.4, 'gousse', 'Fruits & Légumes', 0),
    (r, 'Persil (frais)', 0.4, 'bouquet', 'Fruits & Légumes', 1),
    (r, 'Salade (Mélange)', 4, 'poignée', 'Fruits & Légumes', 2),
    (r, 'Pomme rouge', 2, 'pièce', 'Fruits & Légumes', 3),
    (r, 'Chèvre frais', 60, 'g', 'Crémerie', 4),
    (r, 'Noix', 20, 'g', 'Épicerie sucrée', 5),
    (r, 'Huile d''olive', 4, 'c. à s.', 'Épicerie salée', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans un blender, ajoutez : les noix, le persil effeuillé, l''ail émincé, sel, poivre et 2 cuillère à soupe d''huile d''olive /personne. Mixer le tout.'),
    (r, 2, 'Lavez puis coupez les pommes en fines lamelles (avec ou sans la peau, selon vos préférences).'),
    (r, 3, 'Dans un saladier ajoutez : la salade, les pommes, le chèvre émietté, le pesto sur le dessus, salez, poivrez, ajoutez un léger filer d''huile d''olive, mélangez, c''est prêt !');
  raise notice 'Ajoutée : %', 'Salade pomme pesto, persil & noix';
end
$$;

-- Saumon & purée de brocolis
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Saumon & purée de brocolis')) then
    raise notice 'Déjà présente, ignorée : %', 'Saumon & purée de brocolis';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Saumon & purée de brocolis', '475 kcal/portion · Note 4,6/5 (337 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-01-202309.png_merge_recipes/3Df09aT4awQAyw.png.jpg', 'https://jow.fr/recipes/saumon-et-puree-de-brocolis-8fiz34n93ma8k8hh0ulp',
          4, 8,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 0),
    (r, 'Saumon (frais)', 2, 'pièce', 'Poissonnerie', 1),
    (r, 'Brocoli (frais)', 500, 'g', 'Fruits & Légumes', 2),
    (r, 'Beurre', 40, 'g', 'Crémerie', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Si besoin, faites décongeler le saumon. Coupez le pied du brocoli puis détachez les fleurettes. Coupez-les en 2 ou en 4 selon leur taille.*'),
    (r, 2, 'Ajoutez les brocolis dans l''eau bouillante et faites cuire 8 minutes.'),
    (r, 3, 'Pendant ce temps, faites fondre la moitié du beurre dans une poêle (soit environ 10g par personne).'),
    (r, 4, 'Ajoutez le pavé de saumon côté peau et laissez saisir pendant 3 minutes à feu vif, salez, poivrez.'),
    (r, 5, 'Râpez une gousse d''ail finement au dessus de la poêle. Arrosez votre saumon puis retournez-le. Faites cuire 5 minutes sur feu doux. Couvrez et gardez au chaud.'),
    (r, 6, 'Égouttez les brocolis. Écrasez-les en purée et ajoutez le reste du beurre (soit 10g par personne), salez, poivrez.'),
    (r, 7, 'Servez la purée de brocolis avec le saumon, c''est prêt !');
  raise notice 'Ajoutée : %', 'Saumon & purée de brocolis';
end
$$;

-- Mont d'Or rôti & pommes grenailles
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Mont d''Or rôti & pommes grenailles')) then
    raise notice 'Déjà présente, ignorée : %', 'Mont d''Or rôti & pommes grenailles';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Mont d''Or rôti & pommes grenailles', '795 kcal/portion · Note 4,8/5 (161 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-03-202309.png_merge_recipes/7OJGtk6dJoTG8A.png.jpg', 'https://jow.fr/recipes/mont-d-or-roti-et-pommes-grenailles-8epn8qukbmes9ws6180c',
          1, 20,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pommes de terre (primeur)', 500, 'g', 'Fruits & Légumes', 0),
    (r, 'Mont d''Or', 400, 'g', 'Crémerie', 1);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Enfournez le Mont d''Or et laissez cuire 20 minutes.'),
    (r, 2, 'Faites chauffer une casserole d''eau bouillante salée. Ajoutez les pommes de terre et faites-les cuire 20 minutes.'),
    (r, 3, 'Une fois bien fondu et doré, sortez le Mont d''Or du four et déposez-le dans une assiette avec les pommes de terres cuites.'),
    (r, 4, 'Découpez le chapeau du Mont d''Or et trempez vos pommes de terre dans le fromage fondu. C''est prêt !');
  raise notice 'Ajoutée : %', 'Mont d''Or rôti & pommes grenailles';
end
$$;

-- Velouté de chou-fleur & lard
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Velouté de chou-fleur & lard')) then
    raise notice 'Déjà présente, ignorée : %', 'Velouté de chou-fleur & lard';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Velouté de chou-fleur & lard', '214 kcal/portion · Note 4,2/5 (210 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-05-202309.png_merge_recipes/7jLcH28aI0.png.jpg', 'https://jow.fr/recipes/veloute-de-chou-fleur-et-lard-82muik7chw5s00y307l5',
          4, 22,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Chou-fleur (frais)', 0.5, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Oignon jaune', 1, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Lard (tranches)', 4, 'tranche', 'Traiteur & Charcuterie', 2),
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 3),
    (r, 'Parmesan (râpé)', 2, 'c. à s.', 'Crémerie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Lavez puis coupez le chou-fleur en sommités. Coupez les sommités en 2 ou en 4 selon leur taille. Coupez le tronc en petits cubes.'),
    (r, 2, 'Épluchez puis émincez les oignons'),
    (r, 3, 'Faites fondre une noisette de beurre dans une casserole, sur feu vif. Ajoutez les oignons et l''ail râpé. Faites-les rissoler 1 à 2 minutes, en mélangeant.'),
    (r, 4, 'Baissez le feu à moyen puis ajoutez le chou-fleur. Faites revenir le tout 5 minutes, jusqu''à ce que le chou-fleur soit légèrement doré.'),
    (r, 5, 'Ajoutez 200ml d''eau par personne. Portez à ébullition, puis baissez le feu et couvrez. Laissez mijoter 15 minutes.'),
    (r, 6, 'Pendant ce temps, préparez les chips de bacon. Dans une poêle bien chaude, ajoutez le lard et faites-le griller 2 minutes sur feu vif. Il doit devenir presque croustillant. Débarrassez ensuite sur une feuille de papier essuie-tout.'),
    (r, 7, 'Ajoutez le parmesan râpé et mixez le tout pour obtenir un velouté onctueux. Ajoutez un peu d’eau, si nécessaire.'),
    (r, 8, 'Servez le velouté de chou-fleur dans un bol. Disposez les chips de bacon sur le dessus et re-assaisonnez selon vos goûts. Ajoutez un peu de crème, pour les plus gourmands. C''est prêt !');
  raise notice 'Ajoutée : %', 'Velouté de chou-fleur & lard';
end
$$;

-- Tarte potimarron & chèvre
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tarte potimarron & chèvre')) then
    raise notice 'Déjà présente, ignorée : %', 'Tarte potimarron & chèvre';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tarte potimarron & chèvre', '387 kcal/portion · Note 4,5/5 (371 avis) · Plat entier : 4 parts.', 'https://static.jow.fr/1024x1024/patterns/powder-03-202309.png_merge_recipes/UDa0955jBHkZvw.png.jpg', 'https://jow.fr/recipes/tarte-potimarron-et-chevre-8dcg9fh16zduew1c09xy',
          10, 45,
          4, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâte feuilletée', 1, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Potimarron', 1, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Oignon rouge', 1, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 3),
    (r, 'Chèvre frais', 100, 'g', 'Crémerie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Placez la pâte feuilletée dans un plat à tarte (le nôtre fait 31 cm de diamètre).'),
    (r, 2, 'Coupez à l''aide d''un couteau le surplus de pâte. Piquez le fond de la tarte.'),
    (r, 3, 'Enfournez la tarte pendant 5 minutes à 200°C pour la pré-cuire.'),
    (r, 4, 'Pendant ce temps, lavez le potimarron, videz-le et coupez-le en tranches fines.'),
    (r, 5, 'Coupez l''oignon en tranches.'),
    (r, 6, 'Placez le potimarron et l''oignon sur une plaque de cuisson. Versez un filet d''huile d''olive, salez, poivrez et mélangez.'),
    (r, 7, 'Sortez le fond de tarte du four après 5 minutes de cuisson.'),
    (r, 8, 'Enfournez les légumes 15 minutes à 200°C.'),
    (r, 9, 'Une fois les légumes cuits, badigeonnez le fond de tarte de crème fraîche.'),
    (r, 10, 'Ajoutez les légumes.'),
    (r, 11, 'Ajoutez le chèvre émietté.'),
    (r, 12, 'Salez, poivrez et enfournez 20 minutes à 200°C.'),
    (r, 13, 'Servez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Tarte potimarron & chèvre';
end
$$;

-- Les classiques coquillettes au jambon
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Les classiques coquillettes au jambon')) then
    raise notice 'Déjà présente, ignorée : %', 'Les classiques coquillettes au jambon';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Les classiques coquillettes au jambon', '386 kcal/portion · Note 4,7/5 (1001 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-01-202309.png_merge_recipes/68gzrlmQUS.png.jpg', 'https://jow.fr/recipes/les-classiques-coquillettes-au-jambon-7w9qimf8htq803qe0sh7',
          0, 7,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (coquillettes)', 200, 'g', 'Épicerie salée', 0),
    (r, 'Jambon blanc', 2, 'tranche', 'Traiteur & Charcuterie', 1);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Mettez les coquillettes à cuire dans un grand volume d''eau bouillante, salée à votre convenance. Laissez cuire le temps indiqué sur le paquet.'),
    (r, 2, 'Découpez le jambon en petits morceaux.'),
    (r, 3, 'Égouttez, ajoutez une noix de beurre généreuse aux coquillettes, les morceaux de jambon.* C''est prêt !');
  raise notice 'Ajoutée : %', 'Les classiques coquillettes au jambon';
end
$$;

-- Chipolatas & légumes rôtis
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Chipolatas & légumes rôtis')) then
    raise notice 'Déjà présente, ignorée : %', 'Chipolatas & légumes rôtis';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Chipolatas & légumes rôtis', '636 kcal/portion · Note 4,6/5 (480 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-04-202309.png_merge_recipes/w20dRveuf9UjTQ.png.jpg', 'https://jow.fr/recipes/chipolatas-et-legumes-rotis-876x1fe96kbp1etn0764',
          8, 45,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Saucisse (chipolata)', 4, 'pièce', 'Boucherie & Volaille', 0),
    (r, 'Pommes de terre (primeur)', 400, 'g', 'Fruits & Légumes', 1),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Ail', 1, 'gousse', 'Fruits & Légumes', 3),
    (r, 'Vin blanc', 40, 'ml', 'Boissons', 4),
    (r, 'Poivron rouge', 1, 'pièce', 'Fruits & Légumes', 5),
    (r, 'Thym (feuilles)', 2, 'pincée', 'Épicerie salée', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez votre four à 200°C. Lavez, coupez les extrémités des poivrons, retirez le centre, puis coupez-les en cubes.'),
    (r, 2, 'Coupez l''oignon en quartiers (coupez-les quartiers si l''oignon est gros).'),
    (r, 3, 'Coupez l''ail en fines tranches.'),
    (r, 4, 'Coupez les saucisses en 3 et piquez-les à l''aide d''une fourchette.'),
    (r, 5, 'Dans un plat allant au four, ajoutez tous les ingrédients. Coupez vos pommes de terre* si elles sont très grosses, sinon gardez-les entières.'),
    (r, 6, 'Salez, poivrez et ajoutez un filet d''huile d''olive et les herbes aromatiques. Mélangez bien et enfournez 30 minutes à 200°C.'),
    (r, 7, 'Après 30 minutes de cuisson, sortez le plat du four et ajoutez le vin blanc. Laissez les chipolatas en haut du plat afin qu''elles ne soit pas dans le jus.'),
    (r, 8, 'Enfournez pendant 15 minutes supplémentaires.'),
    (r, 9, 'Sortez le plat du four, servez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Chipolatas & légumes rôtis';
end
$$;

-- Soupe mexicaine
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Soupe mexicaine')) then
    raise notice 'Déjà présente, ignorée : %', 'Soupe mexicaine';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Soupe mexicaine', '379 kcal/portion · Note 4,7/5 (176 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-04-202309.png_merge_recipes/ZI8haYZDkSniYQ.png.jpg', 'https://jow.fr/recipes/soupe-mexicaine-83qm8r1kmey8fcu8090w',
          6, 21,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Patate douce', 300, 'g', 'Fruits & Légumes', 0),
    (r, 'Tomate (chair)', 200, 'g', 'Fruits & Légumes', 1),
    (r, 'Avocat', 0.5, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Oignon jaune', 1, 'pièce', 'Fruits & Légumes', 3),
    (r, 'Bouillon de légumes (cube)', 0.5, 'pièce', 'Épicerie salée', 4),
    (r, 'Piment d''Espelette', 2, 'pincée', 'Épicerie salée', 5),
    (r, 'Citron vert', 0.5, 'pièce', 'Fruits & Légumes', 6),
    (r, 'Feta', 30, 'g', 'Crémerie', 7),
    (r, 'Coriandre (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 8),
    (r, 'Chips de tortillas', 20, 'g', 'Épicerie salée', 9);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Émincez les oignons finement.'),
    (r, 2, 'Lavez, épluchez puis coupez les patates douces en petits cubes.'),
    (r, 3, 'Dans une casserole, ajoutez un filet d''huile d''olive et les oignons. Faites-les revenir 1 minute à feu vif, puis ajoutez les patates douces.'),
    (r, 4, 'Ajoutez la chair de tomate, 1 tasse d''eau par personne (250 ml), le cube de bouillon de légumes, (optionnel : le piment), mélangez.'),
    (r, 5, 'Baissez le feu et laissez mijoter à couvert pendant 20 minutes.'),
    (r, 6, 'Pendant ce temps, coupez les avocats en cubes.'),
    (r, 7, 'Servir la soupe avec les toppings de votre choix : tortilla, avocat, feta et si vous en avez citron vert et coriandre.'),
    (r, 8, 'C''est prêt ! Si vous aimez la cuisine épicée n''hésitez pas ajouter plus de piment ou un peu de tabasco si vous en avez chez vous.');
  raise notice 'Ajoutée : %', 'Soupe mexicaine';
end
$$;

-- Bun tzatziki & saumon fumé
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Bun tzatziki & saumon fumé')) then
    raise notice 'Déjà présente, ignorée : %', 'Bun tzatziki & saumon fumé';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Bun tzatziki & saumon fumé', '544 kcal/portion · Note 4,8/5 (1067 avis)', 'https://static.jow.fr/1024x1024/recipes/8sYj1VdE0vQbiQ.jpg', 'https://jow.fr/recipes/bun-tzatziki-et-saumon-fume-8i9ba0cplzb4kl8k0iwl',
          5, 3,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pain burger', 2, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Tzatziki', 100, 'g', 'Traiteur & Charcuterie', 1),
    (r, 'Salade (mâche)', 2, 'poignée', 'Fruits & Légumes', 2),
    (r, 'Saumon (fumé)', 2, 'tranche', 'Poissonnerie', 3),
    (r, 'Avocat', 1, 'pièce', 'Fruits & Légumes', 4),
    (r, 'Citron jaune', 2, 'quartier', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Tartinez le dessous des buns avec une noix de beurre et faites-les toaster à la poêle ou sur le grill pendant 3 minutes.'),
    (r, 2, 'Coupez l''avocat en deux, enlevez la peau et le noyau. Coupez-le en fines tranches.'),
    (r, 3, 'Préparez les buns. Tartinez-les de tzatziki sur les deux côtés.'),
    (r, 4, 'Garnissez avec les tranches d''avocat, le saumon fumé, et la mâche. Ajoutez quelques zestes de citron, un filet de jus sur le dessus et un filet d''huile d''olive. Salez, poivrez puis refermez.'),
    (r, 5, 'Dégustez aussitôt ! C''est prêt !'),
    (r, 6, 'Vous pouvez emballer votre bun dans du papier fraîcheur si vous voulez le transporter !');
  raise notice 'Ajoutée : %', 'Bun tzatziki & saumon fumé';
end
$$;

-- Tiramisu
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tiramisu')) then
    raise notice 'Déjà présente, ignorée : %', 'Tiramisu';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tiramisu', '396 kcal/portion · Note 4,8/5 (250 avis) · Plat entier : 8 parts.', 'https://static.jow.fr/1024x1024/recipes/uRSNhDhEy8duKw.jpg', 'https://jow.fr/recipes/tiramisu-8bz95soiat3n6eeb11ok',
          25, 0,
          8, true,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Mascarpone', 500, 'g', 'Crémerie', 0),
    (r, 'Œuf', 4, 'pièce', 'Crémerie', 1),
    (r, 'Sucre (en poudre)', 90, 'g', 'Épicerie sucrée', 2),
    (r, 'Biscuit à la cuillère', 200, 'g', 'Épicerie sucrée', 3),
    (r, 'Café', 21, 'g', 'Épicerie sucrée', 4),
    (r, 'Cacao (en poudre)', 2, 'c. à s.', 'Épicerie sucrée', 5),
    (r, 'Sucre vanillé', 1, 'sachet', 'Épicerie sucrée', 6),
    (r, 'Amaretto', 1, 'c. à s.', 'Boissons', 7);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Séparez les blancs des jaunes dans 2 récipients différents.'),
    (r, 2, 'Dans un saladier, ajoutez les blancs et une pincée de sel. Battez les blancs en neige bien fermes.'),
    (r, 3, 'Dans un second saladier, ajoutez les jaunes d’œufs et le sucre*. Fouettez jusqu''à ce que le mélange blanchisse.'),
    (r, 4, 'Ajoutez le mascarpone, l’amaretto et le sucre vanillé, si vous en avez. Fouettez jusqu''à obtenir un mélange lisse et homogène.'),
    (r, 5, 'Petit à petit, incorporez délicatement les blancs en neige dans la préparation au mascarpone.'),
    (r, 6, 'Préparez le café (350 ml pour 8 portions) et versez-le dans un récipient creux pour qu''il tiédisse. Trempez-y les biscuits à la cuillère. Disposez une première couche de biscuit dans le fond d''un plat haut (le nôtre fait 24 x 19 cm).'),
    (r, 7, 'Étalez une couche de crème mascarpone par-dessus les biscuits. Ajoutez ensuite une seconde couche de biscuits et de mascarpone. Filmez le tiramisu et placez-le au frais 6 heures minimum - l''idéal étant de faire le tiramisu la veille pour le lendemain.'),
    (r, 8, 'Sortez le tiramisu juste avant de le servir et saupoudrez-le de cacao. Dégustez aussitôt, c''est prêt !');
  raise notice 'Ajoutée : %', 'Tiramisu';
end
$$;

-- Tarte aux pommes express
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tarte aux pommes express')) then
    raise notice 'Déjà présente, ignorée : %', 'Tarte aux pommes express';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tarte aux pommes express', '161 kcal/portion · Note 4,5/5 (73 avis) · Plat entier : 8 parts.', 'https://static.jow.fr/1024x1024/patterns/raddish-01-202309.png_merge_recipes/C0CwtYiOc1AR6w.png.jpg', 'https://jow.fr/recipes/tarte-aux-pommes-express-87c805ztjk9j52f40yf1',
          10, 45,
          8, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pomme (à cuire)', 4, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Pâte feuilletée', 1, 'pièce', 'Pain & Pâtisserie', 1),
    (r, 'Sucre (en poudre)', 20, 'g', 'Épicerie sucrée', 2);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Épluchez les pommes puis coupez-les en fines lamelles.'),
    (r, 2, 'Astuce : Afin que vos pommes ne noircissent pas pendant que vous les coupez, plongez-les lamelles dans un bol d''eau avec du citron.'),
    (r, 3, 'Placez la pâte dans un moule à tarte (le nôtre fait 31 cl de diamètre). Froncez la pâte, puis piquez-la à l''aide d''une fourchette. Saupoudrez le fond avec la moitié du sucre*.'),
    (r, 4, 'Disposez les pommes joliment. Gardez les plus petites lamelles pour le centre. Saupoudrez avec le reste du sucre. Ajoutez une pincée de fleur de sel.'),
    (r, 5, 'Optionnel : ajoutez quelques petits morceaux de beurre sur le dessus des pommes et/ou une pincée de cannelle ou même des noisettes/amandes/noix concassées si vous en avez.'),
    (r, 6, 'Si besoin, découpez le papier qui dépasse puis enfournez à 180°C pendant 45 minutes. Sortez une fois les pommes bien dorées. C''est prêt !');
  raise notice 'Ajoutée : %', 'Tarte aux pommes express';
end
$$;

-- Amandes caramélisées
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Amandes caramélisées')) then
    raise notice 'Déjà présente, ignorée : %', 'Amandes caramélisées';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Amandes caramélisées', '270 kcal/portion', 'https://static.jow.fr/1024x1024/patterns/raddish-03-202309.png_merge_recipes/yasROdwRFgrOTA.png.jpg', 'https://jow.fr/recipes/amandes-caramelisees-8h7uls5n99cgkqq50nok',
          2, 10,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Sucre (en poudre)', 40, 'g', 'Épicerie sucrée', 0),
    (r, 'Amandes (entières)', 60, 'g', 'Épicerie sucrée', 1);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole, ajoutez : le sucre (20 g par personne) et la même quantité d''eau (20 g par personne). Faites chauffer à feu vif jusqu''à ce que le mélange fasse des bulles.'),
    (r, 2, 'Ajoutez les amandes et mélangez sans cesse avec une cuillère en bois le temps qu''un caramel se forme et qu''il cristallise autour des amandes (environ 10 minutes).*'),
    (r, 3, 'Étalez les amandes sur une plaque de cuisson anti-adhésive ou sur une feuille de papier sulfurisé préalablement huilée et laissez refroidir.'),
    (r, 4, 'Décollez les amandes caramélisées les unes des autres et hachez-les grossièrement si vous le souhaitez, c''est prêt !');
  raise notice 'Ajoutée : %', 'Amandes caramélisées';
end
$$;

-- Quatre-quarts
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Quatre-quarts')) then
    raise notice 'Déjà présente, ignorée : %', 'Quatre-quarts';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Quatre-quarts', '417 kcal/portion · Note 4,9/5 (61 avis) · Plat entier : 8 parts.', 'https://static.jow.fr/1024x1024/patterns/yolk-01-202309.png_merge_recipes/urFaOgIGjeXnaw.png.jpg', 'https://jow.fr/recipes/quatre-quarts-8aa73eiw49tycswh17ak',
          10, 40,
          8, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Farine de blé', 200, 'g', 'Épicerie salée', 0),
    (r, 'Œuf', 4, 'pièce', 'Crémerie', 1),
    (r, 'Beurre', 200, 'g', 'Crémerie', 2),
    (r, 'Sucre (en poudre)', 200, 'g', 'Épicerie sucrée', 3),
    (r, 'Levure chimique', 1, 'sachet', 'Épicerie sucrée', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four en chaleur tournante à 180°C. Faites ramollir le beurre au micro-ondes 15 à 30 secondes.'),
    (r, 2, 'Dans un saladier, ajoutez : le beurre et le sucre. Mélangez à l''aide d''un fouet, jusqu''à obtenir une texture lisse.'),
    (r, 3, 'Ajoutez les œufs un à un, en mélangeant entre chaque ajout.'),
    (r, 4, 'Ajoutez la farine petit à petit, en mélangeant entre chaque ajout, à l''aide d''un fouet.'),
    (r, 5, 'Ajoutez ensuite la levure et mélangez à nouveau.'),
    (r, 6, 'Beurrez généreusement un moule à cake (le nôtre fait 29 x 10 cm). Versez la préparation dans le moule, puis enfournez 40 min en chaleur tournante à 180°C.'),
    (r, 7, 'Une fois que le cake est bien doré, plantez votre couteau au centre. S''il ressort propre, le cake est prêt, sinon re-enfournez 2 à 3 minutes. Laissez le quatre-quarts refroidir avant de le déguster. C''est prêt !');
  raise notice 'Ajoutée : %', 'Quatre-quarts';
end
$$;

-- Marbré glaçage rocher
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Marbré glaçage rocher')) then
    raise notice 'Déjà présente, ignorée : %', 'Marbré glaçage rocher';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Marbré glaçage rocher', '644 kcal/portion · Note 4,2/5 (45 avis) · Plat entier : 8 parts.', 'https://static.jow.fr/1024x1024/patterns/beet-01-202309.png_merge_recipes/1kNjl0IQM0pR5g.png.jpg', 'https://jow.fr/recipes/marbre-glacage-rocher-8eg82ygc5yv4k8ji01vd',
          15, 40,
          8, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Chocolat à cuire', 200, 'g', 'Épicerie sucrée', 0),
    (r, 'Farine de blé', 200, 'g', 'Épicerie salée', 1),
    (r, 'Beurre demi-sel', 200, 'g', 'Crémerie', 2),
    (r, 'Sucre (en poudre)', 150, 'g', 'Épicerie sucrée', 3),
    (r, 'Œuf', 4, 'pièce', 'Crémerie', 4),
    (r, 'Cacao (en poudre)', 30, 'g', 'Épicerie sucrée', 5),
    (r, 'Amandes (entières)', 50, 'g', 'Épicerie sucrée', 6),
    (r, 'Levure chimique', 1, 'sachet', 'Épicerie sucrée', 7),
    (r, 'Huile de colza', 50, 'ml', 'Épicerie salée', 8);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Dans un saladier, ajoutez : le beurre mou, le sucre* et une pincée de sel. Mélangez, jusqu''à obtenir un beurre pommade.'),
    (r, 2, 'Ajoutez les œufs un à un, tout en mélangeant à l''aide d''un fouet.'),
    (r, 3, 'Ajoutez la levure chimique et la farine. Mélangez jusqu''à obtenir une pâte lisse.'),
    (r, 4, 'Divisez la préparation entre deux saladiers. Dans l''un des deux saladiers, ajoutez le cacao en poudre tamisé. Mélangez, à l''aide d''une spatule.'),
    (r, 5, 'Beurrez généreusement un moule à cake (le nôtre fait 29 x 10 cm). Répartissez les deux pâtes par couches, en alternant entre la pâte au chocolat et la pâte nature. Faites des spirales à l''aide de la pointe d''un couteau pour former les marbrures. Enfournez 40 minutes à 180°C.'),
    (r, 6, 'Pendant ce temps, préparez le glaçage rocher. Concassez le chocolat, puis faites-le fondre au bain-marie ou au micro-ondes.'),
    (r, 7, 'Hachez les amandes.'),
    (r, 8, 'Une fois le chocolat fondu, ajoutez l''huile. Mélangez, jusqu''à obtenir une texture lisse et brillante. Ajoutez ensuite une pincée de sel et les amandes hachées. Mélangez à nouveau.'),
    (r, 9, 'Une fois que le cake est bien doré, plantez votre couteau au centre. S''il ressort propre, le cake est prêt, sinon re-enfournez 2 à 3 minutes. Laissez le marbré refroidir avant de le démouler et de le recouvrir du glaçage rocher. C''est prêt !');
  raise notice 'Ajoutée : %', 'Marbré glaçage rocher';
end
$$;

-- Cake au yaourt
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Cake au yaourt')) then
    raise notice 'Déjà présente, ignorée : %', 'Cake au yaourt';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Cake au yaourt', '281 kcal/portion · Note 4,6/5 (112 avis) · Plat entier : 8 parts.', 'https://static.jow.fr/1024x1024/patterns/beet-03-202309.png_merge_recipes/fqBNCQ13PfcsEQ.png.jpg', 'https://jow.fr/recipes/cake-au-yaourt-8bw652eu2chxjqy30zxg',
          5, 30,
          8, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Yaourt nature', 1, 'pièce', 'Crémerie', 0),
    (r, 'Œuf', 3, 'pièce', 'Crémerie', 1),
    (r, 'Farine de blé', 240, 'g', 'Épicerie salée', 2),
    (r, 'Sucre (en poudre)', 100, 'g', 'Épicerie sucrée', 3),
    (r, 'Huile de tournesol', 60, 'ml', 'Épicerie salée', 4),
    (r, 'Levure chimique', 0.5, 'sachet', 'Épicerie sucrée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four en chaleur tournante à 180°C. Dans un saladier, ajoutez 1 pot de yaourt nature (dosage pour 1 cake). Attention : conservez le pot de yaourt tout au long de la recette car il sera votre outil de mesure.'),
    (r, 2, 'Ajoutez ensuite (dosage pour 1 cake) : 3 pots de farine, 1 pot de sucre, un demi pot d''huile végétale, la levure, 1 pincée de sel et les œufs.*'),
    (r, 3, 'Mélangez le tout énergiquement, à l''aide d''un fouet, jusqu''à obtenir une pâte lisse.'),
    (r, 4, 'Beurrez ou huilez généreusement un moule à cake (le nôtre fait 29 x 10 cm). Versez la préparation dans le moule, puis enfournez 30 min en chaleur tournante à 180°C.'),
    (r, 5, 'Une fois que le cake est bien doré, plantez votre couteau au centre. S''il ressort propre, le cake est prêt, sinon re-enfournez 2 à 3 minutes. Laissez le cake au yaourt refroidir avant de le déguster. C''est prêt !');
  raise notice 'Ajoutée : %', 'Cake au yaourt';
end
$$;

-- Roses des sables
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Roses des sables')) then
    raise notice 'Déjà présente, ignorée : %', 'Roses des sables';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Roses des sables', '371 kcal/portion · Note 4,5/5 (134 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-03-202309.png_merge_recipes/n0Mi36yd2eDbfw.png.jpg', 'https://jow.fr/recipes/roses-des-sables-8aoxhpnf9w3man2a0xid',
          4, 5,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Chocolat à cuire', 100, 'g', 'Épicerie sucrée', 0),
    (r, 'Corn flakes', 50, 'g', 'Épicerie sucrée', 1);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole à feu doux, ajoutez le chocolat concassé et faites-le fondre à la casserole tout doucement en remuant régulièrement.'),
    (r, 2, 'Une fois le chocolat fondu, ajoutez les cornflakes et mélangez jusqu''à ce qu''elles soient bien toutes recouvertes de chocolat.'),
    (r, 3, 'Faites des petits tas sur une plaque (ou un plateau) couverte de papier cuisson et laissez reposer à température ambiante quelques heures jusqu''à ce que le chocolat durcisse. C''est prêt !');
  raise notice 'Ajoutée : %', 'Roses des sables';
end
$$;

-- Yaourt & compote rhubarbe
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Yaourt & compote rhubarbe')) then
    raise notice 'Déjà présente, ignorée : %', 'Yaourt & compote rhubarbe';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Yaourt & compote rhubarbe', '222 kcal/portion · Note 4,8/5 (21 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-04-202309.png_merge_recipes/UsHRxYjt7KFT6Q.png.jpg', 'https://jow.fr/recipes/yaourt-et-compote-rhubarbe-86e3abqriu835o0y0ye7',
          4, 0,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Yaourt Grec', 200, 'g', 'Crémerie', 0),
    (r, 'Compote rhubarbe (frais)', 180, 'g', 'Épicerie sucrée', 1),
    (r, 'Pistaches (grillées)', 20, 'g', 'Épicerie sucrée', 2);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans un bol ajoutez le yaourt puis la compote. Décortiquez puis concassez grossièrement les pistaches et ajoutez-les sur le dessus. Optionnel : ajoutez un filet de miel ou de sirop d''érable au moment de servir. C''est prêt !');
  raise notice 'Ajoutée : %', 'Yaourt & compote rhubarbe';
end
$$;

-- Crumble aux fruits rouges
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Crumble aux fruits rouges')) then
    raise notice 'Déjà présente, ignorée : %', 'Crumble aux fruits rouges';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Crumble aux fruits rouges', '545 kcal/portion · Note 4,6/5 (37 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-01-202309.png_merge_recipes/qj1ADoAWBM4f4A.png.jpg', 'https://jow.fr/recipes/crumble-aux-fruits-rouges-866035dzlopciyly15qn',
          9, 25,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Farine de blé', 100, 'g', 'Épicerie salée', 0),
    (r, 'Sucre (en poudre)', 50, 'g', 'Épicerie sucrée', 1),
    (r, 'Beurre', 60, 'g', 'Crémerie', 2),
    (r, 'Fruits rouges (surgelés)', 200, 'g', 'Surgelés', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Sortir le beurre du frigo pour qu''il soit à température ambiante.'),
    (r, 2, 'Dans un saladier ajoutez : la farine, les 3/4 du sucre*, une pincée de sel et le beurre, mélangez à l''aide de vos doigts jusqu''à obtention d''une pâte sablée.'),
    (r, 3, 'Mélangez les fruits avec le reste du sucre et mélangez. Ajustez la dose de sucre selon vos goûts.'),
    (r, 4, 'Ajoutez les fruits dans un plat allant au four, de taille proportionnelle à la dose de fruits prévue ; l''idéal étant d''avoir minimum 4 à 5 cm d''épaisseur de fruits.'),
    (r, 5, 'Saupoudrez la pâte sur le dessus. Enfournez pendant 20 à 30 minutes.'),
    (r, 6, 'Sortir le crumble lorsque la pâte est bien dorée, surveillez votre four ;) Se déguste froid ou tiède, nature ou avec une boule de glace à la vanille ou une pointe de crème fraîche, c''est prêt !');
  raise notice 'Ajoutée : %', 'Crumble aux fruits rouges';
end
$$;

-- Salade nectarine, parma & mozzarella
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Salade nectarine, parma & mozzarella')) then
    raise notice 'Déjà présente, ignorée : %', 'Salade nectarine, parma & mozzarella';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Salade nectarine, parma & mozzarella', '545 kcal/portion · Note 4,8/5 (120 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-02-202309.png_merge_recipes/VYToigPXIkrGlg.png.jpg', 'https://jow.fr/recipes/salade-nectarine-parma-et-mozzarella-8i99eeyxlzb4kl8k0iqk',
          7, 0,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Nectarine', 2, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Avocat', 1, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Jambon cru (Prosciutto)', 2, 'tranche', 'Traiteur & Charcuterie', 2),
    (r, 'Salade (roquette)', 4, 'poignée', 'Fruits & Légumes', 3),
    (r, 'Crème balsamique', 2, 'c. à s.', 'Épicerie salée', 4),
    (r, 'Mozzarella di bufala', 1, 'pièce', 'Crémerie', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Lavez puis coupez la nectarine en quartiers.'),
    (r, 2, 'Épluchez l''avocat, enlevez le noyau et coupez-le en dés.'),
    (r, 3, 'Dans une assiette, déposez tous les quartiers de nectarine, les dés d''avocat, la roquette, la mozzarella et le jambon cru déchiré en morceaux.'),
    (r, 4, 'Ajoutez un filet d''huile d''olive, la crème de balsamique, salez et poivrez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Salade nectarine, parma & mozzarella';
end
$$;

-- Bruschetta courgette & abricot
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Bruschetta courgette & abricot')) then
    raise notice 'Déjà présente, ignorée : %', 'Bruschetta courgette & abricot';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Bruschetta courgette & abricot', '429 kcal/portion · Note 4,6/5 (75 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-05-202309.png_merge_recipes/xAiaqJ2hIsKHQw.png.jpg', 'https://jow.fr/recipes/bruschetta-courgette-et-abricot-8igdhbua100gkcoe1c1w',
          5, 0,
          2, false,
          array['Jow', 'Express', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pain de campagne (tranché)', 4, 'tranche', 'Pain & Pâtisserie', 0),
    (r, 'Abricot (frais)', 2, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Courgette', 200, 'g', 'Fruits & Légumes', 2),
    (r, 'Basilic (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 3),
    (r, 'Houmous', 80, 'g', 'Épicerie salée', 4),
    (r, 'Amandes (entières)', 20, 'g', 'Épicerie sucrée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Faites toaster les tranches de pain (au grille pain ou au four en mode grill).'),
    (r, 2, 'Lavez les courgettes puis coupez-les en fines lamelles à l''aide d''un économe. Lorsque vous commencez à voir les graines, tournez la courgette d''1/4 et recommencez sur les 4 faces, jusqu''au tronc.'),
    (r, 3, 'Lavez les abricots, retirez les noyaux et coupez-les en quartiers.'),
    (r, 4, 'Une fois les tranches de pain toastées, tartinez-les de houmous. Ajoutez les courgettes, les abricots, les amandes et le basilic.'),
    (r, 5, 'Salez, poivrez, puis ajoutez un filet d''huile d''olive sur le dessus. C''est prêt !');
  raise notice 'Ajoutée : %', 'Bruschetta courgette & abricot';
end
$$;

-- Salade de pâtes, pesto, mozza
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Salade de pâtes, pesto, mozza')) then
    raise notice 'Déjà présente, ignorée : %', 'Salade de pâtes, pesto, mozza';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Salade de pâtes, pesto, mozza', '655 kcal/portion · Note 4,6/5 (1492 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-04-202309.png_merge_recipes/0qdU0At0aV20xQ.png.jpg', 'https://jow.fr/recipes/salade-de-pates-pesto-mozza-8il2j2fbg3eokpaf0p0c',
          3, 10,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (Pipe rigate)', 200, 'g', 'Épicerie salée', 0),
    (r, 'Tomates séchées', 80, 'g', 'Épicerie salée', 1),
    (r, 'Sauce pesto', 2, 'c. à s.', 'Épicerie salée', 2),
    (r, 'Vinaigre balsamique', 2, 'c. à s.', 'Épicerie salée', 3),
    (r, 'Mozzarella (mini)', 120, 'g', 'Crémerie', 4),
    (r, 'Basilic (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole d’eau bouillante salée, faites cuire les pâtes selon les instructions du paquet. En fin de cuisson, égouttez-les.'),
    (r, 2, 'Pendant ce temps, lavez puis coupez les tomates séchées en fines lamelles.'),
    (r, 3, 'Préparez la vinaigrette. Dans un bol, mélangez : le vinaigre balsamique avec le pesto. Poivrez.'),
    (r, 4, 'Dans une assiette, ajoutez les pâtes refroidies, les tomates séchées et les billes de mozzarella. Arrosez le tout de vinaigrette et ajoutez quelques feuilles de basilic, si vous en avez. Mélangez et servez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Salade de pâtes, pesto, mozza';
end
$$;

-- Salade méditerranéenne
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Salade méditerranéenne')) then
    raise notice 'Déjà présente, ignorée : %', 'Salade méditerranéenne';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Salade méditerranéenne', '270 kcal/portion · Note 4,6/5 (129 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-01-202309.png_merge_recipes/8DR5NCJmQXbQVA.png.jpg', 'https://jow.fr/recipes/salade-mediterraneenne-84h206ermfmpez5t0277',
          5, 0,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Salade (mélange mâche-roquette)', 4, 'poignée', 'Fruits & Légumes', 0),
    (r, 'Pois chiches (cuits)', 100, 'g', 'Épicerie salée', 1),
    (r, 'Tomates séchées', 60, 'g', 'Épicerie salée', 2),
    (r, 'Chèvre frais', 40, 'g', 'Crémerie', 3),
    (r, 'Citron jaune', 2, 'quartier', 'Fruits & Légumes', 4),
    (r, 'Noix', 20, 'g', 'Épicerie sucrée', 5),
    (r, 'Vinaigre de cidre', 2, 'c. à c.', 'Épicerie salée', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Égouttez puis rincez les pois chiches à l''eau claire. Hachez grossièrement des tomates séchées.'),
    (r, 2, 'Dans un saladier, réalisez la vinaigrette en mélangeant : 1 cuillère à soupe d''huile d''olive par personne, le jus de citron, (optionnel : le vinaigre de cidre), poivre et sel.'),
    (r, 3, 'Ajoutez dans le saladier, la salade, les pois chiches, les tomates, le chèvre émietté, les noix concassées, mélangez, c''est prêt !');
  raise notice 'Ajoutée : %', 'Salade méditerranéenne';
end
$$;

-- Bun caprese
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Bun caprese')) then
    raise notice 'Déjà présente, ignorée : %', 'Bun caprese';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Bun caprese', '484 kcal/portion · Note 4,7/5 (65 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-04-202309.png_merge_recipes/WX9KxYGcpC0vBQ.png.jpg', 'https://jow.fr/recipes/bun-caprese-8ii5etst480wkmom0ymq',
          6, 2,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pain burger', 2, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Sauce pesto', 2, 'c. à s.', 'Épicerie salée', 1),
    (r, 'Tomate', 1, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Mozzarella di bufala', 1, 'pièce', 'Crémerie', 3),
    (r, 'Basilic (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Ajoutez un filet d''huile d''olive dans une poêle à feu vif et faites-les toaster pendant 1 minute côté mie. (Vous pouvez aussi les faire toaster sur grill pendant 3 minutes).'),
    (r, 2, 'Coupez les tomates en tranches.'),
    (r, 3, 'Coupez la mozzarella en tranches.'),
    (r, 4, 'Garnissez les buns. Tartinez les deux côtés avec le pesto. Ajoutez 2 tranches de tomate, 2 tranches de mozzarella, le basilic sur le dessus. Salez et poivrez.'),
    (r, 5, 'Refermez le bun, servez, c''est prêt !');
  raise notice 'Ajoutée : %', 'Bun caprese';
end
$$;

-- Tarte fine tomate & pesto
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tarte fine tomate & pesto')) then
    raise notice 'Déjà présente, ignorée : %', 'Tarte fine tomate & pesto';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tarte fine tomate & pesto', '304 kcal/portion · Note 4,7/5 (339 avis) · Plat entier : 4 parts.', 'https://static.jow.fr/1024x1024/patterns/yolk-01-202309.png_merge_recipes/bqiPGm6LrF5iBA.png.jpg', 'https://jow.fr/recipes/tarte-fine-tomate-et-pesto-8bqubshvlija9c4001yq',
          10, 25,
          4, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâte feuilletée', 1, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Tomates cerises', 500, 'g', 'Fruits & Légumes', 1),
    (r, 'Sauce pesto', 1, 'c. à s.', 'Épicerie salée', 2),
    (r, 'Chèvre frais', 2, 'c. à s.', 'Crémerie', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez votre four à 200°C. Placez votre pâte sur une plaque de cuisson et étalez le pesto sur toute la surface en laissant 1 à 2 cm sur les bords.'),
    (r, 2, 'Enfournez à 200°C pendant 5 minutes pour pré-cuire la pâte.'),
    (r, 3, 'Pendant ce temps, lavez puis coupez les tomates en 2 (si vous avez des tomates cerises) ou en lamelles (si vous avez des tomates classiques).'),
    (r, 4, 'Une fois la pâte précuite, ajoutez les tomates sur le dessus, salez, poivrez et ajoutez un filet d''huile d''olive. Ré-enfournez la tarte pendant 20 minutes.'),
    (r, 5, 'Une fois bien dorée, sortez la tarte. Ajoutez le chèvre sur le dessus en l''émiettant. C''est prêt !');
  raise notice 'Ajoutée : %', 'Tarte fine tomate & pesto';
end
$$;

-- Poêlée de poulet & légumes d'été
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Poêlée de poulet & légumes d''été')) then
    raise notice 'Déjà présente, ignorée : %', 'Poêlée de poulet & légumes d''été';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Poêlée de poulet & légumes d''été', '236 kcal/portion · Note 4,6/5 (854 avis)', 'https://static.jow.fr/1024x1024/patterns/kale-02-202309.png_merge_recipes/fK50arw4yMreKg.png.jpg', 'https://jow.fr/recipes/poelee-de-poulet-et-legumes-d-ete-8bw946ly2chxjqy310e5',
          6, 15,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Poulet (escalope)', 2, 'pièce', 'Boucherie & Volaille', 0),
    (r, 'Moutarde', 1, 'c. à c.', 'Épicerie salée', 1),
    (r, 'Tomate', 200, 'g', 'Fruits & Légumes', 2),
    (r, 'Courgette', 200, 'g', 'Fruits & Légumes', 3),
    (r, 'Poivron rouge', 1, 'pièce', 'Fruits & Légumes', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Lavez puis coupez les tomates en quartiers.'),
    (r, 2, 'Lavez puis coupez les courgettes en demi-lunes.'),
    (r, 3, 'Lavez puis coupez les poivrons en petits cubes.'),
    (r, 4, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu vif. Ajoutez les légumes. Salez, poivrez, puis laissez cuire 10 minutes, en remuant.'),
    (r, 5, 'Ajoutez le poulet émincé et la moutarde dans la poêle*. Mélangez puis faites revenir le tout 5 minutes supplémentaires.'),
    (r, 6, 'Servez la poêlée de légumes au poulet accompagnée de riz. C''est prêt !');
  raise notice 'Ajoutée : %', 'Poêlée de poulet & légumes d''été';
end
$$;

-- Cabillaud en papillote & agrumes
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Cabillaud en papillote & agrumes')) then
    raise notice 'Déjà présente, ignorée : %', 'Cabillaud en papillote & agrumes';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Cabillaud en papillote & agrumes', '371 kcal/portion · Note 4,2/5 (159 avis)', 'https://static.jow.fr/1024x1024/patterns/kale-04-202309.png_merge_recipes/e3SoLhh7hb92qw.png.jpg', 'https://jow.fr/recipes/cabillaud-en-papillote-et-agrumes-8ek9gb04f3i8kcx70dk7',
          10, 10,
          2, false,
          array['Jow', 'Express', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Cabillaud (frais)', 2, 'pièce', 'Poissonnerie', 0),
    (r, 'Riz', 140, 'g', 'Épicerie salée', 1),
    (r, 'Citron jaune', 0.5, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Orange', 0.5, 'pièce', 'Fruits & Légumes', 3),
    (r, 'Échalote', 1, 'pièce', 'Fruits & Légumes', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Si besoin, faites décongeler le cabillaud. Préchauffez votre four à 200°C. Lavez puis découpez l''orange et le citron en tranches. Réservez.'),
    (r, 2, 'Éplucher puis hachez finement l''échalote. Réservez.'),
    (r, 3, 'Étalez une feuille de papier sulfurisé sur votre plan de travail. Déposez le poisson, ajoutez l''échalote hachée et un bon filet d''huile d''olive, salez et poivrez.'),
    (r, 4, 'Ajoutez les tranches d''agrumes en alternant citron et orange.'),
    (r, 5, 'Fermez la papillote puis enfournez pendant 10 minutes.'),
    (r, 6, 'Pendant ce temps, faites cuire le riz selon les instructions de préparation du paquet. Égouttez.'),
    (r, 7, 'Sortez vos papillotes du four. Servez le riz avec le poisson et son jus de cuisson. Dégustez, c''est prêt !');
  raise notice 'Ajoutée : %', 'Cabillaud en papillote & agrumes';
end
$$;

-- Salade tomates & agrumes
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Salade tomates & agrumes')) then
    raise notice 'Déjà présente, ignorée : %', 'Salade tomates & agrumes';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Salade tomates & agrumes', '563 kcal/portion · Note 4,6/5 (136 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-03-202309.png_merge_recipes/QgQgQdXqOPQIlQ.png.jpg', 'https://jow.fr/recipes/salade-tomates-et-agrumes-87c8b3h5jk9j52f40yrs',
          10, 0,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pamplemousse', 1, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Avocat', 2, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Tomate', 400, 'g', 'Fruits & Légumes', 2),
    (r, 'Échalote', 0.5, 'pièce', 'Fruits & Légumes', 3),
    (r, 'Vinaigre de cidre', 2, 'c. à c.', 'Épicerie salée', 4),
    (r, 'Orange', 1, 'pièce', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Coupez les extrémités du pamplemousse, puis coupez la chair tout autour en le coupant à vif. Extraire les suprêmes à l''aide de la lame d''un couteau. Si besoin, retirez les pépins.'),
    (r, 2, 'Faire de même avec les oranges.'),
    (r, 3, 'Lavez puis coupez les tomates en petits quartiers.'),
    (r, 4, 'Épluchez l''avocat, retirez le noyau puis découpez-le en cubes.'),
    (r, 5, 'Réalisez la vinaigrette en mélangeant : 1 cuillère à soupe d''huile d''olive/personne, le jus d''agrumes restant, le vinaigre, sel, poivre, mélangez.'),
    (r, 6, 'Dans un saladier ajoutez les tomates, l''avocat, les oranges et le pamplemousse, la vinaigrette, les échalotes émincées, salez, poivrez, mélangez, c''est prêt !');
  raise notice 'Ajoutée : %', 'Salade tomates & agrumes';
end
$$;

-- Risotto comté & saucisse à l'ancienne
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Risotto comté & saucisse à l''ancienne')) then
    raise notice 'Déjà présente, ignorée : %', 'Risotto comté & saucisse à l''ancienne';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Risotto comté & saucisse à l''ancienne', '690 kcal/portion · Note 4,6/5 (487 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-03-202309.png_merge_recipes/ZMgDx4H5VWl7fg.png.jpg', 'https://jow.fr/recipes/risotto-comte-et-saucisse-a-l-ancienne-85sjfb0o70qt09up1ca8',
          6, 20,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Riz (Arborio)', 140, 'g', 'Épicerie salée', 0),
    (r, 'Échalote', 0.5, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 2),
    (r, 'Comté', 40, 'g', 'Crémerie', 3),
    (r, 'Saucisse (fumée)', 200, 'g', 'Boucherie & Volaille', 4),
    (r, 'Bouillon de volaille (cube)', 0.5, 'pièce', 'Épicerie salée', 5),
    (r, 'Vin blanc', 40, 'ml', 'Boissons', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez, puis émincez l''ail.'),
    (r, 2, 'Épluchez, puis émincez l''échalote.'),
    (r, 3, 'Coupez les saucisses en tranches.'),
    (r, 4, 'Dans une poêle ou une casserole, ajoutez un filet d''huile d''olive, l''ail, l''échalote, la saucisse et faites revenir 3 minutes.'),
    (r, 5, 'Faire bouillir 25cl d''eau par personne et y dissoudre le bouillon de volaille.'),
    (r, 6, 'Ajoutez ensuite le riz et le vin blanc dans la casserole et laissez rissoler jusqu''à évaporation du vin.'),
    (r, 7, 'Poivrez et ajoutez le bouillon petit à petit, 1 tasse par 1 tasse en le laissant s''évaporer, puis recommencer l''opération jusqu''à épuisement du bouillon.'),
    (r, 8, 'Le riz doit cuire entre 15 à 18 minutes. Vérifiez la cuisson du riz et coupez le feu.'),
    (r, 9, 'Ajoutez le comté râpé et mélangez.'),
    (r, 10, 'Servez dans une assiette et ajoutez quelques copeaux de comté s''il vous en reste. Poivrez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Risotto comté & saucisse à l''ancienne';
end
$$;

-- Salade avocat & crevette
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Salade avocat & crevette')) then
    raise notice 'Déjà présente, ignorée : %', 'Salade avocat & crevette';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Salade avocat & crevette', '267 kcal/portion · Note 4,7/5 (149 avis)', 'https://static.jow.fr/1024x1024/patterns/kale-04-202309.png_merge_recipes/78xpc5TGen115A.png.jpg', 'https://jow.fr/recipes/salade-avocat-et-crevette-8c2nf0jm32f462go0qn8',
          5, 0,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Salade (roquette)', 2, 'poignée', 'Fruits & Légumes', 0),
    (r, 'Crevette (cuite)', 100, 'g', 'Poissonnerie', 1),
    (r, 'Avocat', 1, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Échalote', 0.5, 'pièce', 'Fruits & Légumes', 3),
    (r, 'Citron jaune', 2, 'quartier', 'Fruits & Légumes', 4),
    (r, 'Amandes (entières)', 30, 'g', 'Épicerie sucrée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans un saladier réalisez la sauce en mélangeant le jus (optionnel : et zeste) de citron, les échalotes finement émincées, sel, poivre et 1 cuillère à soupe d''huile d''olive par personne.'),
    (r, 2, 'Épluchez puis coupez les avocats en lamelles.'),
    (r, 3, 'Ajoutez ensuite les crevettes, la salade (optionnel : les amandes concassées) et mélangez le tout, c''est prêt !');
  raise notice 'Ajoutée : %', 'Salade avocat & crevette';
end
$$;

-- Bricks courgette, curry, feta & salade
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Bricks courgette, curry, feta & salade')) then
    raise notice 'Déjà présente, ignorée : %', 'Bricks courgette, curry, feta & salade';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Bricks courgette, curry, feta & salade', '344 kcal/portion · Note 4,6/5 (922 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-01-202309.png_merge_recipes/dPTldvQ0g4B0jA.png.jpg', 'https://jow.fr/recipes/bricks-courgette-curry-feta-et-salade-8hv92xa28j80khvb0me5',
          9, 10,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Feuille de brick', 6, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Courgette', 1, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Feta', 100, 'g', 'Crémerie', 2),
    (r, 'Yaourt Grec', 4, 'c. à s.', 'Crémerie', 3),
    (r, 'Ail', 1, 'gousse', 'Fruits & Légumes', 4),
    (r, 'Curry (poudre)', 2, 'pincée', 'Épicerie salée', 5),
    (r, 'Salade (Mélange)', 4, 'poignée', 'Fruits & Légumes', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Coupez les extrémités des courgettes, puis coupez-les en petits dés.'),
    (r, 2, 'Dans une poêle à feu moyen, ajoutez un filet d''huile d''olive et ajoutez les courgettes. Salez, poivrez et ajoutez le curry. Mélangez.'),
    (r, 3, 'Faites-les revenir à feu vif pendant 5 minutes en remuant régulièrement.'),
    (r, 4, 'Pendant ce temps, dans un bol ajoutez le yaourt grec avec un filet d''huile d''olive. Ajoutez la gousse d''ail râpée ou hachée, salez et poivrez. Mélangez et réservez.'),
    (r, 5, 'Une fois les courgettes revenues, coupez le feu, ajoutez la feta émiettée, puis mélangez.'),
    (r, 6, 'Détachez délicatement les feuilles de brick de leur papier.'),
    (r, 7, 'Prenez une feuille de brick et huilez-la légèrement.'),
    (r, 8, 'Divisez la farce pour que vous en ayez suffisamment pour faire vos bricks : 3 par personne. Ajoutez un peu de farce dans la brick.'),
    (r, 9, 'Roulez la feuille de brick sur 1/3 de la surface, repliez les bords vers l''intérieur, puis continuez de rouler en serrant légèrement.'),
    (r, 10, 'Recommencez autant de fois que de bricks nécessaires.'),
    (r, 11, 'Ajoutez un filet d''huile d''olive dans une poêle à feu moyen et ajoutez les bricks.'),
    (r, 12, 'Faites-les revenir à feu moyen 2 minutes sur chaque face.'),
    (r, 13, 'Une fois bien dorées, servez-les accompagnées de la sauce au yaourt et de la salade. C''est prêt !');
  raise notice 'Ajoutée : %', 'Bricks courgette, curry, feta & salade';
end
$$;

-- Gratin de ravioles aux courgettes
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Gratin de ravioles aux courgettes')) then
    raise notice 'Déjà présente, ignorée : %', 'Gratin de ravioles aux courgettes';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Gratin de ravioles aux courgettes', '742 kcal/portion · Note 4,6/5 (1033 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-04-202309.png_merge_recipes/3qfJCI0wjf1X4w.png.jpg', 'https://jow.fr/recipes/gratin-de-ravioles-aux-courgettes-8haq9syy14ogkjn901hv',
          6, 25,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Courgette', 300, 'g', 'Fruits & Légumes', 0),
    (r, 'Ravioles du Dauphiné', 300, 'g', 'Crémerie', 1),
    (r, 'Crème fraîche', 120, 'g', 'Crémerie', 2),
    (r, 'Moutarde à l''ancienne', 1, 'c. à c.', 'Épicerie salée', 3),
    (r, 'Comté (râpé)', 60, 'g', 'Crémerie', 4),
    (r, 'Herbes de Provence', 2, 'pincée', 'Épicerie salée', 5),
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 220°C. Lavez puis coupez les courgettes en demi-lunes.'),
    (r, 2, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez l''ail râpé et faites-le revenir 30 secondes, en mélangeant.'),
    (r, 3, 'Ajoutez les courgettes. Salez, poivrez et parsemez d''herbes de Provence. Mélangez puis laissez cuire 4 à 5 minutes.'),
    (r, 4, 'Pendant ce temps, dans une bol, mélangez : un tiers de la crème fraîche avec le comté râpé. Salez et poivrez.'),
    (r, 5, 'Ajoutez la moutarde et le reste de la crème fraîche dans la poêle avec les courgettes. Mélangez et poursuivez la cuisson 1 à 2 minutes.'),
    (r, 6, 'Huilez un plat allant au four (le nôtre fait 22 x 14 cm), puis disposez-y une première couche de courgettes crémeuses. Ajoutez la moitié des ravioles crues par-dessus, puis répétez l''opération une seconde fois. Terminez par une couche du mélange crème fraîche / comté râpé. Poivrez, puis enfournez 15 à 20 minutes à 220°C.'),
    (r, 7, 'Une fois le gratin bien doré sur le dessus, sortez-le du four et servez avec une salade verte. C''est prêt !');
  raise notice 'Ajoutée : %', 'Gratin de ravioles aux courgettes';
end
$$;

-- Cake au thon, pesto rouge & olives
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Cake au thon, pesto rouge & olives')) then
    raise notice 'Déjà présente, ignorée : %', 'Cake au thon, pesto rouge & olives';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Cake au thon, pesto rouge & olives', '413 kcal/portion · Note 4,4/5 (66 avis) · Plat entier : 6 parts.', 'https://static.jow.fr/1024x1024/patterns/beet-02-202309.png_merge_recipes/r0RxE0sXBWbJ0Q.png.jpg', 'https://jow.fr/recipes/cake-au-thon-pesto-rouge-et-olives-8i3e2rf2by0gkco61a0x',
          10, 55,
          6, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Thon au naturel', 200, 'g', 'Épicerie salée', 0),
    (r, 'Olives noires (dénoyautées)', 80, 'g', 'Épicerie salée', 1),
    (r, 'Sauce pesto rouge', 60, 'g', 'Épicerie salée', 2),
    (r, 'Fromage râpé', 100, 'g', 'Crémerie', 3),
    (r, 'Farine de blé', 150, 'g', 'Épicerie salée', 4),
    (r, 'Œuf', 3, 'pièce', 'Crémerie', 5),
    (r, 'Lait', 125, 'ml', 'Crémerie', 6),
    (r, 'Huile d''olive', 60, 'ml', 'Épicerie salée', 7),
    (r, 'Levure chimique', 1, 'sachet', 'Épicerie sucrée', 8);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Dans un saladier, ajoutez : les œufs, la farine et la levure. Poivrez, puis mélangez, à l''aide d''un fouet.'),
    (r, 2, 'Ajoutez : l''huile, le lait et le pesto rosso. Mélangez à nouveau, jusqu''à obtenir une texture homogène.'),
    (r, 3, 'Ajoutez : le thon émietté, le fromage râpé et les olives noires (réservez-en pour la décoration du cake). Mélangez le tout, à l''aide d''une spatule.'),
    (r, 4, 'Huilez un moule à cake (le nôtre fait 29 x 10 cm), puis tapissez-le de papier cuisson. Versez-y la pâte, puis décorez le dessus du cake avec les olives réservées. Enfournez 50 à 55 minutes à 180°C.'),
    (r, 5, 'Une fois que le cake est bien doré, plantez votre couteau au centre. S''il ressort propre, le cake est prêt, sinon re-enfournez 2 à 3 minutes. Servez le cake au thon, pesto rouge & olives à l''apéro ou avec une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Cake au thon, pesto rouge & olives';
end
$$;

-- Bricks courgette, curry & feta
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Bricks courgette, curry & feta')) then
    raise notice 'Déjà présente, ignorée : %', 'Bricks courgette, curry & feta';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Bricks courgette, curry & feta', '532 kcal/portion · Note 4,6/5 (308 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-02-202309.png_merge_recipes/FZYO5Gdsccs7jA.png.jpg', 'https://jow.fr/recipes/bricks-courgette-curry-et-feta-8hd43dtc621skrs617l9',
          12, 10,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Feuille de brick', 6, 'pièce', 'Pain & Pâtisserie', 0),
    (r, 'Courgette', 1, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Feta', 100, 'g', 'Crémerie', 2),
    (r, 'Yaourt Grec', 4, 'c. à s.', 'Crémerie', 3),
    (r, 'Ail', 1, 'gousse', 'Fruits & Légumes', 4),
    (r, 'Curry (poudre)', 2, 'pincée', 'Épicerie salée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Coupez les extrémités des courgettes, puis coupez-les en petits dés.'),
    (r, 2, 'Dans une poêle à feu moyen, ajoutez un filet d''huile d''olive et ajoutez les courgettes. Salez, poivrez et ajoutez le curry. Mélangez, faites revenir, à feu vif, pendant 5 minutes, en remuant régulièrement.'),
    (r, 3, 'Pendant ce temps, préparez la sauce au yaourt. Dans un bol ajoutez : le yaourt grec, un filet d''huile d''olive, la gousse d''ail râpée ou hachée, du sel et du poivre. Mélangez et réservez.'),
    (r, 4, 'Une fois les courgettes dorées, coupez le feu et ajoutez la feta émiettée dans la poêle. Mélangez.'),
    (r, 5, 'Détachez délicatement les feuilles de brick de leur papier. Prenez ensuite une feuille de brick et huilez-la légèrement.'),
    (r, 6, 'Divisez la farce pour que vous en ayez suffisamment pour faire vos bricks : 3 par personne. Ajoutez un peu de farce sur la feuille de brick.'),
    (r, 7, 'Roulez la feuille de brick sur 1/3 de la surface. Repliez les bords vers l''intérieur, puis continuez de rouler, en serrant légèrement. Recommencez autant de fois que de bricks nécessaires.'),
    (r, 8, 'Faites chauffer un filet d''huile d''olive dans une poêle à feu moyen. Ajoutez-y les bricks et faites-les revenir 2 minutes sur chaque face.'),
    (r, 9, 'Une fois bien dorées, servez-les accompagnées de la sauce au yaourt. C''est prêt !');
  raise notice 'Ajoutée : %', 'Bricks courgette, curry & feta';
end
$$;

-- Galette Seguin
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Galette Seguin')) then
    raise notice 'Déjà présente, ignorée : %', 'Galette Seguin';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Galette Seguin', '595 kcal/portion · Note 4,7/5 (385 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-04-202309.png_merge_recipes/cqYWxd2nDZKYEA.png.jpg', 'https://jow.fr/recipes/galette-seguin-81pfiebr1lkg00ws06s9',
          2, 5,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Galette bretonne', 2, 'pièce', 'Crémerie', 0),
    (r, 'Jambon blanc', 2, 'tranche', 'Traiteur & Charcuterie', 1),
    (r, 'Chèvre frais', 80, 'g', 'Crémerie', 2),
    (r, 'Crème fraîche', 1, 'c. à s.', 'Crémerie', 3),
    (r, 'Noix', 20, 'g', 'Épicerie sucrée', 4),
    (r, 'Miel (liquide)', 2, 'c. à c.', 'Épicerie sucrée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Faites fondre une noisette de beurre dans une crêpière ou une grande poêle, sur feu moyen. Déposez-y la galette au sarrasin.'),
    (r, 2, 'Étalez la crème au centre de la galette. Poivrez puis ajoutez le chèvre frais en morceaux. Laissez cuire 1 à 2 minutes.'),
    (r, 3, 'Une fois le fromage fondu, ajoutez le jambon et les noix concassées. Repliez la galette en carré ou en demi lune. Poursuivez la cuisson 1 minute supplémentaire.'),
    (r, 4, 'Dans une assiette, servez la galette avec un filet de miel par-dessus. Accompagnez-la d''une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Galette Seguin';
end
$$;

-- Brochette poulet & poivrons
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Brochette poulet & poivrons')) then
    raise notice 'Déjà présente, ignorée : %', 'Brochette poulet & poivrons';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Brochette poulet & poivrons', '429 kcal/portion · Note 4,6/5 (42 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-01-202309.png_merge_recipes/IW0D9W6McDqHGA.png.jpg', 'https://jow.fr/recipes/brochette-poulet-et-poivrons-87dwifwb4dxx1hhj0sbr',
          4, 15,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Poulet (escalope)', 2, 'pièce', 'Boucherie & Volaille', 0),
    (r, 'Poivron rouge', 0.5, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Oignon rouge', 0.5, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Blé (à cuire)', 140, 'g', 'Épicerie salée', 3),
    (r, 'Pics à brochette', 2, 'pièce', 'Entretien & Maison', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Faites cuire le blé dans une casserole d''eau salée pendant 10 minutes. Égouttez le en fin de cuisson.'),
    (r, 2, 'Coupez les poivrons en cubes.'),
    (r, 3, 'Coupez le poulet en cubes.'),
    (r, 4, 'Coupez l''oignon en quartiers et détaillez-les.'),
    (r, 5, 'Embrochez les morceaux de poulet, les oignons et les poivrons en alternant.*'),
    (r, 6, 'Dans une poêle, ajoutez un filet d''huile d''olive et faites revenir les brochettes 2 minutes sur les 4 faces à feu moyen.'),
    (r, 7, 'Puis baissez le feu, couvrez et laissez cuire 5 minutes de plus.'),
    (r, 8, 'Servez le blé et les brochettes, salez, poivrez, ajoutez un filet d''huile d''olive (optionnel : quelques herbes aromatiques). C''est prêt !');
  raise notice 'Ajoutée : %', 'Brochette poulet & poivrons';
end
$$;

-- Chèvre chaud au jambon & salade
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Chèvre chaud au jambon & salade')) then
    raise notice 'Déjà présente, ignorée : %', 'Chèvre chaud au jambon & salade';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Chèvre chaud au jambon & salade', '472 kcal/portion · Note 4,6/5 (825 avis)', 'https://static.jow.fr/1024x1024/recipes/06dRPfEuuX1sPg.jpg', 'https://jow.fr/recipes/chevre-chaud-au-jambon-et-salade-8fxlajp87683hi920iab',
          4, 5,
          2, false,
          array['Jow', 'Express', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Chèvre (bûche)', 100, 'g', 'Crémerie', 0),
    (r, 'Jambon blanc', 4, 'tranche', 'Traiteur & Charcuterie', 1),
    (r, 'Pain de mie', 4, 'tranche', 'Pain & Pâtisserie', 2),
    (r, 'Herbes de Provence', 2, 'pincée', 'Épicerie salée', 3),
    (r, 'Salade (mâche)', 4, 'poignée', 'Fruits & Légumes', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four en mode grill. Sur une plaque de cuisson, disposez les tranches de pain de mie* et le jambon par-dessus.'),
    (r, 2, 'Coupez le chèvre en rondelles et ajoutez-les sur le jambon.'),
    (r, 3, 'Versez un filet d''huile d''olive, salez, poivrez et ajoutez les herbes de Provence. Enfournez 5 minutes en mode grill.'),
    (r, 4, 'Une fois les chèvres chauds dorés, sortez-les du four. Servez-les dans une assiette avec une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Chèvre chaud au jambon & salade';
end
$$;

-- Pâtes aux petits pois & lardons
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Pâtes aux petits pois & lardons')) then
    raise notice 'Déjà présente, ignorée : %', 'Pâtes aux petits pois & lardons';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Pâtes aux petits pois & lardons', '730 kcal/portion · Note 4,6/5 (261 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-02-202309.png_merge_recipes/jkk2G8R1Rt.png.jpg', 'https://jow.fr/recipes/pates-aux-petits-pois-et-lardons-81sxkaju34c000vm1cwp',
          2, 10,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (Pipe rigate)', 200, 'g', 'Épicerie salée', 0),
    (r, 'Petits pois (frais)', 200, 'g', 'Fruits & Légumes', 1),
    (r, 'Lardons', 150, 'g', 'Traiteur & Charcuterie', 2),
    (r, 'Crème liquide', 40, 'ml', 'Crémerie', 3),
    (r, 'Parmesan (râpé)', 4, 'c. à s.', 'Crémerie', 4),
    (r, 'Menthe (feuilles)', 2, 'brin', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole d''eau bouillante salée, faites cuire les pâtes et les petits pois selon les instructions du paquet. En fin de cuisson, égouttez-les et réservez au chaud.'),
    (r, 2, 'Pendant ce temps, dans une poêle chaude, ajoutez les lardons. Faites-les revenir 5 minutes.'),
    (r, 3, 'Ajoutez la crème, le parmesan, les petits pois et les pâtes égouttés. Salez, poivrez et mélangez le tout.'),
    (r, 4, 'Servez les pâtes aux petits pois et lardons dans une assiette. Parsemez de menthe ciselée, si vous en avez et de parmesan râpé, s''il vous en reste. Re-assaisonnez selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Pâtes aux petits pois & lardons';
end
$$;

-- Risotto bianco
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Risotto bianco')) then
    raise notice 'Déjà présente, ignorée : %', 'Risotto bianco';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Risotto bianco', '487 kcal/portion · Note 4,3/5 (104 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-03-202309.png_merge_recipes/xRQYkUVfZ2PUcQ.png.jpg', 'https://jow.fr/recipes/risotto-bianco-8h7uk7gr99cgkqq50n4p',
          4, 20,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Riz (Arborio)', 140, 'g', 'Épicerie salée', 0),
    (r, 'Bouillon de légumes (cube)', 0.5, 'pièce', 'Épicerie salée', 1),
    (r, 'Parmesan (râpé)', 2, 'c. à s.', 'Crémerie', 2),
    (r, 'Vin blanc', 40, 'ml', 'Boissons', 3),
    (r, 'Échalote', 0.5, 'pièce', 'Fruits & Légumes', 4),
    (r, 'Noisette', 50, 'g', 'Épicerie sucrée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Faites bouillir 25cl d''eau par personne et y dissoudre le bouillon de légumes.'),
    (r, 2, 'Pendant ce temps, épluchez et hachez les échalotes.'),
    (r, 3, 'Concassez les noisettes grossièrement et faites-les torréfier au four pendant 4 min à 220°C ou à la poêle à feu vif pendant 3 min tout en remuant.'),
    (r, 4, 'Dans une poêle ou une casserole, ajoutez les échalotes avec une noisette de beurre. Faites-les revenir 1 minute avant d''ajouter le riz. Ajoutez le vin et laissez cuire jusqu''à absorption.'),
    (r, 5, 'Quand le bouillon est prêt, ajoutez une louche de bouillon. Laissez le bouillon s''évaporer puis rajoutez ensuite une nouvelle louche.'),
    (r, 6, 'Faites de même jusqu''à ce qu''il n''y ait plus de bouillon de légumes. Au bout de 18/20 minutes, le riz doit être cuit.'),
    (r, 7, 'Ajoutez le parmesan et une noisette de beurre, salez, poivrez et mélangez.'),
    (r, 8, 'Servez, ajoutez du parmesan râpé, les noisettes concassées et un filet d''huile d''olive. Salez, poivrez, c''est prêt !');
  raise notice 'Ajoutée : %', 'Risotto bianco';
end
$$;

-- Linguine saumon & petits pois
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Linguine saumon & petits pois')) then
    raise notice 'Déjà présente, ignorée : %', 'Linguine saumon & petits pois';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Linguine saumon & petits pois', '532 kcal/portion · Note 4,6/5 (359 avis)', 'https://static.jow.fr/1024x1024/patterns/kale-04-202309.png_merge_recipes/uxAEOw9UmXwuBA.png.jpg', 'https://jow.fr/recipes/linguine-saumon-et-petits-pois-85g9c6xxf176ju3o0alt',
          3, 8,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (Linguine)', 200, 'g', 'Épicerie salée', 0),
    (r, 'Petits pois (frais)', 100, 'g', 'Fruits & Légumes', 1),
    (r, 'Saumon (fumé)', 2, 'tranche', 'Poissonnerie', 2),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 3),
    (r, 'Citron jaune', 0.5, 'pièce', 'Fruits & Légumes', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Faites cuire les pâtes selon les instructions du paquet.'),
    (r, 2, 'Ajoutez les petits pois 7 minutes avant la fin de cuisson des pâtes.'),
    (r, 3, 'Égouttez les pâtes et les petits pois.'),
    (r, 4, 'Replacer les pâtes et les petits pois dans la casserole, ajoutez la crème fraîche, le saumon, zestez le citron, salez, poivrez.'),
    (r, 5, 'Servez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Linguine saumon & petits pois';
end
$$;

-- Gratin de pâtes au jambon
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Gratin de pâtes au jambon')) then
    raise notice 'Déjà présente, ignorée : %', 'Gratin de pâtes au jambon';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Gratin de pâtes au jambon', '624 kcal/portion · Note 4,6/5 (1109 avis)', 'https://static.jow.fr/1024x1024/recipes/b1rz7dBmNyL4jQ.jpg', 'https://jow.fr/recipes/gratin-de-pates-au-jambon-81syk0a234c000vm1d0v',
          4, 30,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (macaroni)', 200, 'g', 'Épicerie salée', 0),
    (r, 'Fromage râpé', 80, 'g', 'Crémerie', 1),
    (r, 'Jambon blanc', 2, 'tranche', 'Traiteur & Charcuterie', 2),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 220°C. Dans une casserole d''eau bouillante salée, faites cuire les pâtes selon les instructions du paquet. En fin de cuisson, réservez une petite louche d''eau de cuisson puis égouttez les pâtes. Réservez au chaud.'),
    (r, 2, 'Coupez le jambon en morceaux.'),
    (r, 3, 'Dans un plat allant au four (le nôtre fait 24 x 19 cm), ajoutez les pâtes égouttées. Salez et poivrez.'),
    (r, 4, 'Ajoutez la crème fraîche, l''eau de cuisson réservée et la moitié du fromage râpé. Mélangez bien.'),
    (r, 5, 'Ajoutez le jambon, mélangez à nouveau, puis parsemez du reste de fromage râpé. Enfournez 15 à 20 minutes à 220°C.'),
    (r, 6, 'Une fois bien doré, sortez le plat du four. Servez le gratin de pâtes avec une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Gratin de pâtes au jambon';
end
$$;

-- Cake aux poivrons, feta & olives
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Cake aux poivrons, feta & olives')) then
    raise notice 'Déjà présente, ignorée : %', 'Cake aux poivrons, feta & olives';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Cake aux poivrons, feta & olives', '446 kcal/portion · Note 4,6/5 (203 avis) · Plat entier : 6 parts.', 'https://static.jow.fr/1024x1024/patterns/beet-03-202309.png_merge_recipes/04KuHUE0MeWAsw.png.jpg', 'https://jow.fr/recipes/cake-aux-poivrons-feta-et-olives-8bs61s2vf07k4zms037k',
          10, 45,
          6, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Poivron rouge', 300, 'g', 'Fruits & Légumes', 0),
    (r, 'Feta', 150, 'g', 'Crémerie', 1),
    (r, 'Olives noires (dénoyautées)', 100, 'g', 'Épicerie salée', 2),
    (r, 'Fromage râpé', 100, 'g', 'Crémerie', 3),
    (r, 'Farine de blé', 150, 'g', 'Épicerie salée', 4),
    (r, 'Œuf', 3, 'pièce', 'Crémerie', 5),
    (r, 'Lait', 100, 'ml', 'Crémerie', 6),
    (r, 'Huile d''olive', 60, 'ml', 'Épicerie salée', 7),
    (r, 'Levure chimique', 1, 'sachet', 'Épicerie sucrée', 8);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Lavez puis coupez les poivrons en retirant le cœur avec les pépins. Coupez-les en fines lamelles, puis en moitiés.'),
    (r, 2, 'Si besoin, dénoyautez les olives.'),
    (r, 3, 'Préparez la pâte à cake. Dans un saladier, ajoutez : les œufs, la farine et la levure. Salez, poivrez, puis mélangez, à l''aide d''un fouet.'),
    (r, 4, 'Ajoutez : le lait et l''huile d''olive. Mélangez, jusqu''à obtenir une pâte lisse et homogène.'),
    (r, 5, 'Ajoutez ensuite : le fromage râpé, les poivrons, les olives noires et la feta émiettée. Mélangez, à l''aide d''une spatule.'),
    (r, 6, 'Huilez un moule à cake (le nôtre fait 29 x 10 cm), puis tapissez-le d''un peu de farine (optionnel). Versez-y la pâte, puis enfournez 45 minutes à 180°C.'),
    (r, 7, 'Une fois que le cake est bien doré, plantez votre couteau au centre. S''il ressort propre, le cake est prêt, sinon re-enfournez 2 à 3 minutes. Servez le cake aux poivrons, feta & olives à l''apéro ou avec une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Cake aux poivrons, feta & olives';
end
$$;

-- Tagliatelle crémeuses au saumon & citron
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Tagliatelle crémeuses au saumon & citron')) then
    raise notice 'Déjà présente, ignorée : %', 'Tagliatelle crémeuses au saumon & citron';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Tagliatelle crémeuses au saumon & citron', '637 kcal/portion · Note 4,7/5 (1360 avis)', 'https://static.jow.fr/1024x1024/recipes/FPTrkKdaauLsEg.jpg', 'https://jow.fr/recipes/tagliatelle-cremeuses-au-saumon-et-citron-89s3i4sdhbjk5s4h140i',
          3, 11,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (Tagliatelle sèches)', 200, 'g', 'Épicerie salée', 0),
    (r, 'Saumon (fumé)', 4, 'tranche', 'Poissonnerie', 1),
    (r, 'Parmesan (morceaux)', 40, 'g', 'Crémerie', 2),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 3),
    (r, 'Citron jaune', 2, 'quartier', 'Fruits & Légumes', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Coupez le saumon fumé en lamelles.'),
    (r, 2, 'Dans une casserole d''eau bouillante salée, faites cuire les pâtes selon les instructions du paquet. En fin de cuisson, réservez une petite louche d''eau de cuisson, puis égouttez-les.'),
    (r, 3, 'Dans la casserole avec les pâtes égouttées, ajoutez : la crème fraîche, le zeste et le jus de citron. Salez et poivrez.'),
    (r, 4, 'Ajoutez le parmesan râpé et l''eau de cuisson réservée. Mélangez bien le tout.'),
    (r, 5, 'Ajoutez le saumon et mélangez à nouveau.'),
    (r, 6, 'Servez les tagliatelle crémeuses au saumon dans une assiette creuse ou un bol. Re-assaisonnez selon vos goûts, c''est prêt !');
  raise notice 'Ajoutée : %', 'Tagliatelle crémeuses au saumon & citron';
end
$$;

-- Bruschetta parma
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Bruschetta parma')) then
    raise notice 'Déjà présente, ignorée : %', 'Bruschetta parma';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Bruschetta parma', '480 kcal/portion · Note 4,7/5 (374 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-05-202309.png_merge_recipes/iBFMY0XR50rGzw.png.jpg', 'https://jow.fr/recipes/bruschetta-parma-8bqufnlt7p7l0ggk09yc',
          5, 0,
          2, false,
          array['Jow', 'Express', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pain de campagne (tranché)', 4, 'tranche', 'Pain & Pâtisserie', 0),
    (r, 'Mozzarella (boule)', 100, 'g', 'Crémerie', 1),
    (r, 'Tomate', 300, 'g', 'Fruits & Légumes', 2),
    (r, 'Basilic (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 3),
    (r, 'Jambon cru', 4, 'tranche', 'Traiteur & Charcuterie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Faites toaster les tranches de pain (au grille pain ou au four en mode grill).'),
    (r, 2, 'Pendant ce temps, lavez puis coupez les tomates en fines lamelles.'),
    (r, 3, 'Une fois les tranches de pain toastées, ajoutez les tomates, quelques morceaux de mozzarella, le jambon, salez, poivrez, puis ajoutez un filet d''huile d''olive sur le dessus. C''est prêt !'),
    (r, 4, 'Optionnel : ajoutez quelques feuilles de basilic si vous en avez.');
  raise notice 'Ajoutée : %', 'Bruschetta parma';
end
$$;

-- Lasagnes végé aux courgettes & champignons
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Lasagnes végé aux courgettes & champignons')) then
    raise notice 'Déjà présente, ignorée : %', 'Lasagnes végé aux courgettes & champignons';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Lasagnes végé aux courgettes & champignons', '525 kcal/portion · Note 4,4/5 (581 avis)', 'https://static.jow.fr/1024x1024/recipes/kfNhA6tyUlAdrA.jpg', 'https://jow.fr/recipes/lasagnes-vege-aux-courgettes-et-champignons-7vgj14mfb7kw03qm0u73',
          15, 40,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Lasagnes (cru)', 100, 'g', 'Crémerie', 0),
    (r, 'Courgette', 300, 'g', 'Fruits & Légumes', 1),
    (r, 'Sauce tomate (basilic)', 300, 'g', 'Épicerie salée', 2),
    (r, 'Champignons de Paris (frais)', 175, 'g', 'Fruits & Légumes', 3),
    (r, 'Mozzarella (à cuire)', 125, 'g', 'Crémerie', 4),
    (r, 'Herbes de Provence', 0.5, 'c. à c.', 'Épicerie salée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Lavez puis coupez les champignons en lamelles.'),
    (r, 2, 'Lavez puis coupez les courgettes en demi-lunes.'),
    (r, 3, 'Coupez la mozzarella en tranches.'),
    (r, 4, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez les courgettes et les champignons. Salez, poivrez. Faites revenir le tout 4 à 5 minutes, en mélangeant.'),
    (r, 5, 'Préchauffez le four à 180°C. Dans un plat allant au four (le nôtre fait 24 x 17 cm), étalez une première couche de sauce tomate suivie des feuilles de lasagnes, d''une couche de légumes et de mozzarella. Répétez l''opération sur deux couches supplémentaires. Terminez par une couche de mozzarella et de sauce tomate.'),
    (r, 6, 'Vérifiez que les pâtes soient bien immergées dans la sauce tomate. Assaisonnez les lasagnes d''herbes de Provence et poivrez. Enfournez 30 à 35 minutes à 180°C.'),
    (r, 7, 'Une fois les lasagnes bien dorées et le fromage fondu, sortez le plat du four. Servez les lasagnes accompagnées d''une salade verte, assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Lasagnes végé aux courgettes & champignons';
end
$$;

-- Grilled cheese à l'italienne
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Grilled cheese à l''italienne')) then
    raise notice 'Déjà présente, ignorée : %', 'Grilled cheese à l''italienne';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Grilled cheese à l''italienne', '813 kcal/portion · Note 4,5/5 (303 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-01-202309.png_merge_recipes/0lJSn3hP8bJdsQ.png.jpg', 'https://jow.fr/recipes/grilled-cheese-a-l-italienne-8cchk1udcm2dindc0pe4',
          4, 4,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pain de mie', 8, 'tranche', 'Pain & Pâtisserie', 0),
    (r, 'Sauce pesto', 4, 'c. à c.', 'Épicerie salée', 1),
    (r, 'Jambon cru (Prosciutto)', 8, 'tranche', 'Traiteur & Charcuterie', 2),
    (r, 'Salade (roquette)', 2, 'poignée', 'Fruits & Légumes', 3),
    (r, 'Mozzarella (boule)', 160, 'g', 'Crémerie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Coupez la mozzarella en rondelles.'),
    (r, 2, 'Étalez le pesto sur les tranches de pain de mie.'),
    (r, 3, 'Sur l''une des deux tranches, ajoutez la mozzarella suivi du jambon cru et de la roquette.'),
    (r, 4, 'Refermez le grilled-cheese avec la seconde tranche de pain de mie, côté pesto vers le bas.'),
    (r, 5, 'Faites fondre une noisette de beurre dans une poêle, sur feu moyen. Faites revenir les grilled cheese 2 minutes sur chaque face, pour qu''ils soient bien dorés. Coupez le feu, couvrez la poêle et laissez reposer hors du feu pendant 1 minute.'),
    (r, 6, 'Coupez les grilled cheese en deux ou en quatre. Dégustez aussitôt, c''est prêt !');
  raise notice 'Ajoutée : %', 'Grilled cheese à l''italienne';
end
$$;

-- Gratin de penne, petit pois & lard
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Gratin de penne, petit pois & lard')) then
    raise notice 'Déjà présente, ignorée : %', 'Gratin de penne, petit pois & lard';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Gratin de penne, petit pois & lard', '607 kcal/portion · Note 4,5/5 (906 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-03-202309.png_merge_recipes/kufUazHtzXfsBw.png.jpg', 'https://jow.fr/recipes/gratin-de-penne-petit-pois-et-lard-8ge0arndl10hj95x0fn9',
          4, 20,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (Penne)', 200, 'g', 'Épicerie salée', 0),
    (r, 'Petits pois (frais)', 160, 'g', 'Fruits & Légumes', 1),
    (r, 'Chèvre frais', 60, 'g', 'Crémerie', 2),
    (r, 'Lard (tranches)', 4, 'tranche', 'Traiteur & Charcuterie', 3),
    (r, 'Crème liquide', 30, 'ml', 'Crémerie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole d’eau bouillante salée, faites cuire les pâtes selon les instructions du paquet.'),
    (r, 2, 'Au bout de 2 minutes, ajoutez les petits pois dans la casserole avec les pâtes et poursuivez la cuisson.'),
    (r, 3, 'Préchauffez le four en mode grill. Faites chauffer une poêle et ajoutez-y les tranches de lard. Faites-les griller 2 minutes de chaque côté.'),
    (r, 4, 'En fin de cuisson des pâtes, égouttez-les avec les petits pois.'),
    (r, 5, 'Ajoutez les pâtes et les petits pois dans un plat allant au four (le nôtre fait 24 x 18 cm). Versez la crème par-dessus. Salez, poivrez et mélangez.'),
    (r, 6, 'Ajoutez les tranches de lard et le chèvre frais en morceaux*, puis enfournez 10 minutes en mode grill.'),
    (r, 7, 'Sortez le gratin du four et servez-le avec une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Gratin de penne, petit pois & lard';
end
$$;

-- Bruschetta tomate mozza
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Bruschetta tomate mozza')) then
    raise notice 'Déjà présente, ignorée : %', 'Bruschetta tomate mozza';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Bruschetta tomate mozza', '345 kcal/portion · Note 4,7/5 (1147 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-03-202309.png_merge_recipes/oFkpHdvkXdSkXA.png.jpg', 'https://jow.fr/recipes/bruschetta-tomate-mozza-8bquev5t7p7l0ggk09y1',
          5, 0,
          2, false,
          array['Jow', 'Express', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pain de campagne (tranché)', 4, 'tranche', 'Pain & Pâtisserie', 0),
    (r, 'Mozzarella (boule)', 100, 'g', 'Crémerie', 1),
    (r, 'Tomate', 300, 'g', 'Fruits & Légumes', 2),
    (r, 'Basilic (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Faites toaster les tranches de pain au grille pain ou au four en mode grill.'),
    (r, 2, 'Pendant ce temps, lavez puis coupez les tomates en fines rondelles.'),
    (r, 3, 'Une fois les tranches de pain toastées, ajoutez les tomates et quelques morceaux de mozzarella déchirée.*'),
    (r, 4, 'Salez, poivrez, puis ajoutez un filet d''huile d''olive sur le dessus et quelques feuilles de basilic, si vous en avez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Bruschetta tomate mozza';
end
$$;

-- Quiche petit pois, lard & mozza
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Quiche petit pois, lard & mozza')) then
    raise notice 'Déjà présente, ignorée : %', 'Quiche petit pois, lard & mozza';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Quiche petit pois, lard & mozza', '367 kcal/portion · Note 4,4/5 (185 avis) · Plat entier : 6 parts.', 'https://static.jow.fr/1024x1024/patterns/beet-04-202309.png_merge_recipes/6WZp5xP7uznBBw.png.jpg', 'https://jow.fr/recipes/quiche-petit-pois-lard-et-mozza-8bs5fk2vf07k4zms033p',
          10, 50,
          6, true,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Petits pois (surgelés)', 300, 'g', 'Surgelés', 0),
    (r, 'Lard (tranches)', 6, 'tranche', 'Traiteur & Charcuterie', 1),
    (r, 'Œuf', 3, 'pièce', 'Crémerie', 2),
    (r, 'Lait', 100, 'ml', 'Crémerie', 3),
    (r, 'Crème liquide', 100, 'ml', 'Crémerie', 4),
    (r, 'Mozzarella (boule)', 1, 'pièce', 'Crémerie', 5),
    (r, 'Pâte brisée', 1, 'pièce', 'Pain & Pâtisserie', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Placez la pâte dans votre moule à tarte (le nôtre fait 31 cm de diamètre) et piquez-la à l''aide d''une fourchette. Une fois le four chaud, faites pré-cuire votre pâte pendant 5 minutes.'),
    (r, 2, 'Pendant ce temps, faites dorer le lard dans une poêle chaude 2 minutes de chaque côté.'),
    (r, 3, 'Dans un récipient, ajoutez : les oeufs, le lait, la crème, sel, poivre et fouettez le tout énergiquement.'),
    (r, 4, 'Une fois la pâte pré-cuite, sortez-la du four, répartissez les petits pois dans le fond avec le lard, puis versez l''appareil à quiche par dessus. Déchirez la mozzarella et répartissez-la sur le dessus.'),
    (r, 5, 'Enfournez votre quiche pendant 45 minutes à 180°C. Laissez reposer 10 minutes avant de déguster, c''est prêt ! À accompagner d''une salade verte.');
  raise notice 'Ajoutée : %', 'Quiche petit pois, lard & mozza';
end
$$;

-- Crumble poivrons & feta
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Crumble poivrons & feta')) then
    raise notice 'Déjà présente, ignorée : %', 'Crumble poivrons & feta';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Crumble poivrons & feta', '559 kcal/portion · Note 4,5/5 (125 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-01-202309.png_merge_recipes/lEiJzwVM5xPiiw.png.jpg', 'https://jow.fr/recipes/crumble-poivrons-et-feta-86lq1t3b8o1y7zoi01yy',
          10, 50,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Poivron rouge', 2, 'pièce', 'Fruits & Légumes', 0),
    (r, 'Tomate', 3, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Feta', 50, 'g', 'Crémerie', 2),
    (r, 'Farine de blé', 80, 'g', 'Épicerie salée', 3),
    (r, 'Beurre', 60, 'g', 'Crémerie', 4),
    (r, 'Parmesan (râpé)', 1, 'c. à s.', 'Crémerie', 5),
    (r, 'Herbes de Provence', 2, 'c. à c.', 'Épicerie salée', 6),
    (r, 'Piment d''Espelette', 2, 'pincée', 'Épicerie salée', 7);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Lavez puis coupez les poivrons en retirant le cœur avec les pépins. Coupez-les en petits dés.'),
    (r, 2, 'Lavez puis coupez les tomates en cubes.'),
    (r, 3, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu vif. Ajoutez les tomates, les poivrons, le piment d''Espelette et les herbes de Provence. Salez, poivrez et faites revenir le tout 4 à 5 minutes, en mélangeant.'),
    (r, 4, 'Pendant ce temps, préparez la pâte à crumble. Dans un saladier, ajoutez : la farine, le parmesan râpé et le beurre mou. Salez et poivrez, puis malaxez le tout avec le bout des doigts afin d''obtenir une pâte sableuse. Ajoutez la feta émiettée et incorporez-la du bout des doigts.'),
    (r, 5, 'Dans un plat allant au four, ajoutez le mélange de tomates et poivrons. s tomates & les poivrons. Ajoutez une petite cuillérée de sucre en poudre (optionnel). Mélangez, puis répartissez la pâte à crumble sur le dessus. Enfournez 45 à 50 minutes à 180°C.'),
    (r, 6, 'Une fois le crumble poivrons et feta bien doré et cuit, sortez-le du four. Servez-le avec une salade verte assaisonnée selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Crumble poivrons & feta';
end
$$;

-- Cabillaud, petits pois & framboises
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Cabillaud, petits pois & framboises')) then
    raise notice 'Déjà présente, ignorée : %', 'Cabillaud, petits pois & framboises';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Cabillaud, petits pois & framboises', '349 kcal/portion · Note 4,3/5 (83 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-04-202309.png_merge_recipes/j6BSqNXtQ25qGw.png.jpg', 'https://jow.fr/recipes/cabillaud-petits-pois-et-framboises-8i3g6b0uby0gkco61bd6',
          6, 8,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Petits pois (surgelés)', 400, 'g', 'Surgelés', 0),
    (r, 'Cabillaud (frais)', 2, 'pièce', 'Poissonnerie', 1),
    (r, 'Fromage blanc', 6, 'c. à s.', 'Crémerie', 2),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 3),
    (r, 'Framboises', 50, 'g', 'Fruits & Légumes', 4),
    (r, 'Ciboulette', 0.2, 'bouquet', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Si besoin, faites décongeler le cabillaud. Épluchez puis coupez l''oignon en tranches.'),
    (r, 2, 'Faites chauffer une sauteuse ou une casserole et ajoutez un morceau de beurre. Ajoutez l''oignon et faites-le revenir pendant 3 minutes en remuant.'),
    (r, 3, 'Ajoutez les petits pois, assaisonnez selon vos goûts. Versez de l''eau jusqu''à hauteur. Couvrez et laissez cuire 5 minutes.'),
    (r, 4, 'En parallèle, dans une poêle, faites cuire le cabillaud avec une noix de beurre 2 minutes sur chaque face. Salez et poivrez.'),
    (r, 5, 'Déposez les petits pois cuits dans un récipient haut, puis mixez le tout en ajoutant 1 cuillère à soupe de fromage blanc par portion. Salez et poivrez. Vous devez obtenir une texture lisse. Si besoin, ajoutez de l''eau de cuisson des petits pois cuillère par cuillère afin d''obtenir la texture souhaitée.'),
    (r, 6, 'Dressez la purée de petits pois dans le fond d''une assiette, déposez le cabillaud et ajoutez les framboises fraîches.'),
    (r, 7, 'Si vous en avez, ajoutez de la ciboulette hachée, salez, poivrez, c''est prêt !');
  raise notice 'Ajoutée : %', 'Cabillaud, petits pois & framboises';
end
$$;

-- Toasts chèvre miel & salade
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Toasts chèvre miel & salade')) then
    raise notice 'Déjà présente, ignorée : %', 'Toasts chèvre miel & salade';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Toasts chèvre miel & salade', '732 kcal/portion · Note 4,7/5 (392 avis)', 'https://static.jow.fr/1024x1024/patterns/beet-01-202309.png_merge_recipes/yyDiMBKoCA.png.jpg', 'https://jow.fr/recipes/toasts-chevre-miel-et-salade-80udkvco0ruo040r1btr',
          3, 10,
          2, false,
          array['Jow', 'Express', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Chèvre (crottin)', 4, 'pièce', 'Crémerie', 0),
    (r, 'Pain de campagne (tranché)', 4, 'tranche', 'Pain & Pâtisserie', 1),
    (r, 'Noix', 20, 'g', 'Épicerie sucrée', 2),
    (r, 'Miel (liquide)', 4, 'c. à c.', 'Épicerie sucrée', 3),
    (r, 'Salade (Mélange)', 2, 'poignée', 'Fruits & Légumes', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Coupez les crottin en deux dans la longueur, disposez en 2 par tranche de pain.'),
    (r, 2, 'Ajoutez les noix concassées, un filet d''huile d''olive et de miel, salez, poivrez. Faire cuire 10 minutes. Servir avec la salade, assaisonnez, dégustez!');
  raise notice 'Ajoutée : %', 'Toasts chèvre miel & salade';
end
$$;

-- Soufflé au fromage
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Soufflé au fromage')) then
    raise notice 'Déjà présente, ignorée : %', 'Soufflé au fromage';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Soufflé au fromage', '324 kcal/portion · Note 4,4/5 (110 avis)', 'https://static.jow.fr/1024x1024/patterns/raddish-03-202309.png_merge_recipes/0opNyRV9lGV70g.png.jpg', 'https://jow.fr/recipes/souffle-au-fromage-8f8xjobulls6gqse0dtc',
          10, 30,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Beurre', 26, 'g', 'Crémerie', 0),
    (r, 'Farine de blé', 26, 'g', 'Épicerie salée', 1),
    (r, 'Lait', 250, 'ml', 'Crémerie', 2),
    (r, 'Fromage râpé', 20, 'g', 'Crémerie', 3),
    (r, 'Œuf', 2, 'pièce', 'Crémerie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Préparez la béchamel. Dans une casserole, ajoutez le beurre et faites-le fondre, sur feu doux. Ajoutez la farine et mélangez rapidement.'),
    (r, 2, 'Ajoutez le lait progressivement et mélangez continuellement, jusqu''à obtenir une texture de pâte à crêpes un peu épaisse. Salez, poivrez et ajoutez de la muscade râpée, si vous en avez, puis réservez.'),
    (r, 3, 'Pendant ce temps, dans deux saladiers, cassez les œuf en séparant les blancs des jaunes.'),
    (r, 4, 'Beurrez un moule allant au four (le nôtre fait 18 cm de diamètre). Réservez.'),
    (r, 5, 'Dans la casserole avec la béchamel tiédie, ajoutez les jaunes d''œuf et le fromage râpé.* Mélangez bien à l''aide d''un fouet, puis réservez.'),
    (r, 6, 'Dans le saladier avec les blancs d''œufs, ajoutez une pincée de sel puis montez les blancs en neige.'),
    (r, 7, 'Dans un grand saladier, ajoutez la béchamel au fromage. Incorporez délicatement et au fur et à mesure les blancs en neige, à l''aide d''une spatule.'),
    (r, 8, 'Versez la préparation dans le moule beurré, puis enfournez 30 minutes à 200°C.'),
    (r, 9, 'Une fois bien doré et gonflé, sortez le soufflé au fromage du four et dégustez aussitôt avec une salade verte. C''est prêt !');
  raise notice 'Ajoutée : %', 'Soufflé au fromage';
end
$$;

-- Spaghetti endives & prosciutto
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Spaghetti endives & prosciutto')) then
    raise notice 'Déjà présente, ignorée : %', 'Spaghetti endives & prosciutto';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Spaghetti endives & prosciutto', '404 kcal/portion · Note 4,3/5 (196 avis)', 'https://static.jow.fr/1024x1024/patterns/powder-03-202309.png_merge_recipes/fGZWCZzDo0WtYQ.png.jpg', 'https://jow.fr/recipes/spaghetti-endives-et-prosciutto-8a0xel9o26d0erov0mdi',
          6, 10,
          2, false,
          array['Jow', 'Express'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (spaghetti)', 200, 'g', 'Épicerie salée', 0),
    (r, 'Endives', 240, 'g', 'Fruits & Légumes', 1),
    (r, 'Jambon cru (Prosciutto)', 2, 'tranche', 'Traiteur & Charcuterie', 2),
    (r, 'Parmesan (râpé)', 1, 'c. à s.', 'Crémerie', 3),
    (r, 'Sucre (en poudre)', 2, 'pincée', 'Épicerie sucrée', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole d''eau bouillante salée, faites cuire les pâtes selon les instructions du paquet. En fin de cuisson, égouttez-les et réservez.'),
    (r, 2, 'Pendant ce temps, lavez puis coupez les endives en rondelles en retirant le cœur.'),
    (r, 3, 'Déchirez le jambon en morceaux.'),
    (r, 4, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez les endives et le sucre. Faites cuire les endives 5 à 6 minutes.'),
    (r, 5, 'Ajoutez les pâtes égouttées et le jambon dans la poêle avec les endives. Assaisonnez selon vos goûts puis ajoutez le parmesan râpé. Mélangez bien le tout.'),
    (r, 6, 'Dans une assiette, servez les pâtes aux endives et prosciutto. Re-assaisonnez selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Spaghetti endives & prosciutto';
end
$$;

-- Soupe brocoli & parmesan
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Soupe brocoli & parmesan')) then
    raise notice 'Déjà présente, ignorée : %', 'Soupe brocoli & parmesan';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Soupe brocoli & parmesan', '214 kcal/portion · Note 4,4/5 (194 avis)', 'https://static.jow.fr/1024x1024/patterns/kale-02-202309.png_merge_recipes/DjV95NNW3J83EQ.png.jpg', 'https://jow.fr/recipes/soupe-brocoli-et-parmesan-87yh6w8g4xvk3apd19ku',
          6, 15,
          2, false,
          array['Jow', 'Four'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Brocoli (frais)', 500, 'g', 'Fruits & Légumes', 0),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 1),
    (r, 'Parmesan (râpé)', 2, 'c. à s.', 'Crémerie', 2),
    (r, 'Bouillon de légumes (cube)', 0.5, 'pièce', 'Épicerie salée', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Préparez le bouillon de légumes. Faites dissoudre le bouillon cube dans 200ml d''eau chaude par personne.'),
    (r, 2, 'Lavez puis coupez le brocoli en sommités. Coupez les sommités en 2 ou en 4 selon leur taille. Coupez le tronc en petits cubes.'),
    (r, 3, 'Dans une casserole, ajoutez le brocoli et le bouillon de légumes. Portez à ébullition puis baissez le feu sur doux. Couvrez et laissez mijoter 15 minutes.'),
    (r, 4, 'Pendant ce temps, préparez les chips de parmesan. Sur une plaque recouverte de papier cuisson, faites des petits tas de parmesan. Poivrez-les et enfournez 5 minutes à 200°C. Surveillez-les bien, elles doivent à peine brunir.'),
    (r, 5, 'En fin de cuisson, ajoutez la crème fraîche et mixez le tout, pour obtenir un velouté onctueux.* Si besoin, ajoutez un peu d’eau et mixez à nouveau.'),
    (r, 6, 'Servez la soupe de brocoli dans un bol ou une assiette creuse. Ajoutez les chips de parmesan et re-assaisonnez selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Soupe brocoli & parmesan';
end
$$;

-- Velouté de céleri & chips de légumes
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Velouté de céleri & chips de légumes')) then
    raise notice 'Déjà présente, ignorée : %', 'Velouté de céleri & chips de légumes';
    return;
  end if;

  insert into public.recipes
    (title, description, image_url, source_url, prep_time, cook_time, servings, is_batch, tags)
  values ('Velouté de céleri & chips de légumes', '164 kcal/portion · Note 4,3/5 (12 avis)', 'https://static.jow.fr/1024x1024/patterns/yolk-01-202309.png_merge_recipes/lSdhud8zAE7E0Q.png.jpg', 'https://jow.fr/recipes/veloute-de-celeri-et-chips-de-legumes-8dy2lz0khf756wxk0x42',
          5, 22,
          2, false,
          array['Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Céleri-rave', 400, 'g', 'Fruits & Légumes', 0),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 1),
    (r, 'Crème liquide', 2, 'c. à s.', 'Crémerie', 2),
    (r, 'Chips de légumes', 20, 'g', 'Épicerie salée', 3);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez puis émincez les oignons.'),
    (r, 2, 'Ajoutez-les dans une casserole avec un filet d''huile d''olive et faites revenir 1 à 2 minutes.'),
    (r, 3, 'Lavez puis épluchez le céleri et coupez-le en cubes.'),
    (r, 4, 'Ajoutez-le dans la casserole et mouillez à hauteur. Salez, poivrez, puis laissez mijoter à couvert pendant 20 minutes.'),
    (r, 5, 'Une fois le céleri tendre, ajoutez la crème et mixez le tout.'),
    (r, 6, 'Ajoutez un peu d''eau si la texture est trop épaisse.'),
    (r, 7, 'Servez la soupe avec les chips de légumes par dessus, c''est prêt !');
  raise notice 'Ajoutée : %', 'Velouté de céleri & chips de légumes';
end
$$;

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
