-- 20 recette(s) — généré par scripts/recipes-to-sql.mjs
-- Rejouable : une recette déjà présente (même titre) est ignorée.

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
    (r, 'Muscade', 2, 'pincée', 'Épicerie sucrée', 9);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Lavez puis coupez les aubergines en très fines lamelles dans le sens de la longueur.'),
    (r, 2, 'Disposez les tranches d''aubergines sur une plaque recouverte de papier cuisson. Salez, poivrez puis badigeonnez-les d''huile d''olive. Enfournez 15 à 20 minutes à 180°C.'),
    (r, 3, 'Pendant ce temps, épluchez puis émincez finement l''oignon.'),
    (r, 4, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez la viande haché, salez et poivrez puis faites-la revenir 5 minutes.'),
    (r, 5, 'Ajoutez les oignons et l''ail râpé puis poursuivez la cuisson 5 minutes.'),
    (r, 6, 'Ajoutez la moitié de la muscade et la sauce tomate. Mélangez puis poursuivez la cuisson 5 minutes à couvert sur feu doux.'),
    (r, 7, 'Pendant ce temps, préparez la béchamel : dans une casserole, ajoutez le beurre et faites-le fondre sur feu doux. Ajoutez la farine et mélangez rapidement.'),
    (r, 8, 'Ajoutez progressivement le lait en mélangeant jusqu''à obtenir une texture un peu épaisse. Salez, poivrez et ajoutez de la muscade puis mélangez.'),
    (r, 9, 'Vérifier la cuisson de la viande.'),
    (r, 10, 'Vérifiez la cuisson des aubergines puis sortez-les du four.'),
    (r, 11, 'Dans un plat à gratin, ajoutez un filet d''huile d''olive puis disposer la moitié des aubergines. Recouvrez-les avec la moitié de la viande. Répétez une seconde fois.'),
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
    (r, 'Chou blanc', 200, 'g', 'Fruits & Légumes', 4),
    (r, 'Coriandre (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 5),
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole d''eau bouillante, faite cuire le riz selon les instructions du paquet. Égouttez en fin de cuisson.'),
    (r, 2, 'Émincez très finement le chou.'),
    (r, 3, 'Dans une poêle chaude, ajoutez un filet d''huile d''olive. Ajoutez le chou et faites le cuire 5 minutes à feu moyen.'),
    (r, 4, 'Ajoutez la viande, le gingembre râpé, l''ail émincé, la sauce soja, salez, poivrez. Mélangez et faites revenir 5 minutes à feu vif pour faire griller la viande.'),
    (r, 5, 'Servez le riz avec le bœuf sauté. C''est prêt !');
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
    (r, 5, 'Enlevez l''eau et le sel des aubergines, en les épongeant avec du papier absorbant.'),
    (r, 6, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez les aubergines et faites-les dorer 5 à 6 minutes. Réservez sur du papier absorbant.'),
    (r, 7, 'Dans la même poêle, faites chauffer un petit filet d''huile d''olive, sur feu doux. Ajoutez le gingembre et l''ail râpés et faites-les revenir 30 secondes, en remuant.'),
    (r, 8, 'Ajoutez ensuite la chair à saucisse et faites revenir le tout 1 minute, sur feu moyen, en mélangeant pour détacher les morceaux.'),
    (r, 9, 'Ajoutez la sauce par-dessus le tout et poivrez généreusement. Mélangez bien.'),
    (r, 10, 'Rajoutez les aubergines dans la poêle, puis versez-y environ 30 ml d''eau par portion. Baissez le feu et laissez mijoter 10 minutes, en remuant de temps en temps.'),
    (r, 11, 'Pendant ce temps, dans une casserole d''eau bouillante salée, faites cuire le riz selon les indications du paquet.'),
    (r, 12, 'Vérifiez la cuisson des aubergines. Hors du feu, parsemez le tout de ciboulette ciselée.'),
    (r, 13, 'En fin de cuisson, égouttez le riz.'),
    (r, 14, 'Servez le riz dans une assiette avec les aubergines braisées au porc. C''est prêt !');
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
    (r, 5, 'Ajoutez les tomates cerises et les blocs de feta coupés en deux. Salez, poivrez et arrosez le tout d''un filet d''huile d''olive. Enfournez 25 à 30 minutes à 200°C.'),
    (r, 6, 'Pendant ce temps, dans une casserole d''eau bouillante salée, faites cuire les pâtes selon les instructions du paquet. En fin de cuisson, égouttez-les puis réservez au chaud.'),
    (r, 7, 'Une fois les légumes bien dorés, sortez le plat du four. Servez les pâtes orzo avec les légumes et la feta rôtis. C''est prêt !');
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
    (r, 2, 'Placez la pâte brisée dans un moule à tarte. Piquez-la et faites-la précuire 5 minutes à 180°C.'),
    (r, 3, 'Pendant ce temps, coupez la moitié du chèvre en rondelles.'),
    (r, 4, 'Préparez l''appareil à quiche. Dans un saladier, ajoutez : les œufs et la crème fraîche. Salez, poivrez puis fouettez le tout énergiquement.'),
    (r, 5, 'Ajoutez les épinards et le reste du chèvre préalablement émietté. Mélangez le tout délicatement.'),
    (r, 6, 'Une fois la pâte précuite, sortez-la du four.'),
    (r, 7, 'Versez l''appareil à quiche dans le fond de tarte et ajoutez les rondelles de chèvre par-dessus. Enfournez 40 à 45 minutes à 180°C.'),
    (r, 8, 'Une fois cuite et bien dorée, sortez la quiche du four. Servez-la chaude ou froide avec une salade verte. C''est prêt !');
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
    (r, 5, 'Parsemez la tarte de pistaches concassées. Servez-la avec une salade verte. C''est prêt !');
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
    (r, 5, 'Faites bouillir 250 ml d''eau par personne et y dissoudre le bouillon. Ajoutez l''équivalent d''une louche de bouillon et l''ail râpé. Mélangez jusqu''à absorption, puis rajoutez une louche. Recommencez jusqu''à ce que les coquillettes soient cuites.'),
    (r, 6, 'Une fois les coquillettes cuites, ajoutez le râpé végétal. Salez, poivrez, puis mélangez bien le tout.'),
    (r, 7, 'Servez le risotto de coquillettes & brocolis dans une assiette creuse. C''est prêt !');
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
    (r, 1, 'Si besoin, faites décongeler les noix de Saint-Jacques. Épluchez la pomme de terre et coupez-la en petits dés. Lavez puis coupez le brocoli en sommités.'),
    (r, 2, 'Faites bouillir une casserole d''eau chaude, versez-y la pomme de terre et laissez-la cuire 5 minutes. Ajoutez le brocoli après 5 minutes, pour 10 minutes supplémentaires.'),
    (r, 3, 'Stoppez la cuisson après avoir vérifié que les légumes soient tendres. À l''aide d''une fourchette, écrasez-les. Ajoutez le cheddar, salez, poivrez.'),
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
    (r, 'Salade (mélange)', 100, 'g', 'Fruits & Légumes', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 200°C. Épluchez les pommes de terre, puis coupez-les en fines rondelles.'),
    (r, 2, 'Dans une casserole d''eau bouillante salée, ajoutez les pommes de terre. Faites-les cuire 10 minutes, sur feu moyen.'),
    (r, 3, 'Pendant ce temps, coupez les extrémités des poireaux pour ne garder que le blanc, puis émincez-les finement. Rincez abondamment.'),
    (r, 4, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu vif. Ajoutez les poireaux émincés. Salez, poivrez, puis faites-les revenir 2 à 3 minutes. Couvrez et poursuivez la cuisson 8 à 10 minutes, sur feu doux.'),
    (r, 5, 'Vérifiez la cuisson des pommes de terre, puis égouttez-les.'),
    (r, 6, 'Préparez la béchamel. Faites fondre le beurre dans une casserole, sur feu doux. Ajoutez la farine et mélangez rapidement.'),
    (r, 7, 'Ajoutez progressivement le lait, en mélangeant, jusqu''à obtenir une texture de pâte à crêpes un peu épaisse. Salez, poivrez puis mélangez. Réservez hors du feu.'),
    (r, 8, 'Dans un plat à gratin, ajoutez une première couche de pommes de terre. Poivrez puis ajoutez une couche de poireaux, de la béchamel et une couche de fromage à raclette. Répétez jusqu''à épuisement des ingrédients. Enfournez 25 minutes à 200°C.'),
    (r, 9, 'Une fois le gratin bien doré, sortez le plat du four. Servez-le accompagné de la salade verte. C''est prêt !');
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
    (r, 'Salade (mélange)', 2, 'poignée', 'Fruits & Légumes', 2),
    (r, 'Ketchup', 2, 'c. à c.', 'Épicerie salée', 3),
    (r, 'Moutarde', 2, 'c. à c.', 'Épicerie salée', 4),
    (r, 'Origan (séché)', 2, 'pincée', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Lavez puis coupez les pommes de terre en quartiers.'),
    (r, 2, 'Disposez les potatoes dans le panier du air-fryer avec la grille. Ajoutez un filet d''huile d''olive. Salez, poivrez et assaisonnez d''origan. Faites cuire 15 à 20 minutes à 200°C.'),
    (r, 3, 'Sortez les potatoes du air-fryer et remuez-les. Poursuivez la cuisson 10 minutes à 200°C.'),
    (r, 4, 'En parallèle, ajoutez les chipolatas dans le panier du air-fryer. Piquez-les, puis faites-les cuire 10 minutes à 200°C.'),
    (r, 5, 'Une fois les potatoes dorées et les saucisses cuites, sortez-les du air-fryer.'),
    (r, 6, 'Servez les chipolatas dans une assiette avec les potatoes, la salade verte, le ketchup et la moutarde. C''est prêt !');
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
    (r, 4, 'En fin de cuisson des pâtes, ajoutez les petits pois dans la casserole. Poursuivez la cuisson 4 à 5 minutes, puis égouttez le tout.'),
    (r, 5, 'Préparez la vinaigrette. Dans un bol, mélangez : le vinaigre balsamique et une cuillère à soupe d''huile d''olive par personne. Salez et poivrez.'),
    (r, 6, 'Dans un saladier, ajoutez : les pâtes et les petits pois, les allumettes de jambon, les cubes de fromage et les échalotes. Versez la vinaigrette puis mélangez bien.'),
    (r, 7, 'Servez la salade de macaroni dans une assiette creuse. C''est prêt !');
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
    (r, 3, 'Dans un plat allant au four, ajoutez les carottes. Assaisonnez-les de paprika, poivrez et ajoutez un filet d''huile d''olive. Enfournez 20 minutes à 200°C.'),
    (r, 4, 'Dans un bol, mélangez : le yaourt grec, la feta émiettée et les échalotes. Salez, poivrez et ajoutez un filet d''huile d''olive. Réservez au frais.'),
    (r, 5, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez les hachés de veau. Salez, poivrez et faites-les revenir 5 à 6 minutes.'),
    (r, 6, 'Une fois les carottes dorées et tendres, sortez-les du four.'),
    (r, 7, 'Étalez la crème de feta dans une assiette. Ajoutez les lentilles, les carottes rôties et le haché de veau. C''est prêt !');
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
    (r, 'Thym (feuilles)', 2, 'pincée', 'Fruits & Légumes', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 190°C. Lavez et découpez les pommes de terre en très fines lamelles.'),
    (r, 2, 'Dans un plat allant au four, ajoutez les rondelles de pomme de terre. Assaisonnez de sel, poivre, thym et d''un filet d''huile d''olive. Enfournez 15 à 20 minutes à 190°C.'),
    (r, 3, 'Sortez le plat du four et ajoutez-y le filet mignon. Badigeonnez-le de moutarde et assaisonnez. Enfournez de nouveau 20 à 25 minutes à 190°C.'),
    (r, 4, 'Pendant ce temps, lavez et coupez le brocoli en sommités. Faites-les pré-cuire quelques minutes à la vapeur.'),
    (r, 5, 'Sortez le plat du four et ajoutez les brocolis. Assaisonnez et enfournez à nouveau 10 minutes à 190°C.'),
    (r, 6, 'À la sortie du four, laissez le filet mignon reposer avant de le couper en tranches.'),
    (r, 7, 'Servez les tranches de filet mignon avec les pommes de terre croustillantes et le brocoli. C''est prêt !');
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
    (r, 'Fromage à trous', 2, 'tranche', 'Crémerie', 2),
    (r, 'Salade (cœur de laitue)', 2, 'poignée', 'Fruits & Légumes', 3),
    (r, 'Moutarde', 2, 'c. à c.', 'Épicerie salée', 4),
    (r, 'Miel (liquide)', 1, 'c. à c.', 'Épicerie sucrée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une poêle chaude, ajoutez les poulets panés. Faites-les griller 3 minutes de chaque côté. Réservez au chaud.'),
    (r, 2, 'Dans la même poêle, faites chauffer un filet d''huile d''olive, sur feu moyen. Faites toaster les pains burger 1 à 2 minutes.'),
    (r, 3, 'Préparez la sauce miel moutarde. Dans un bol, mélangez : la moutarde et le miel.'),
    (r, 4, 'Garnissez vos burgers en tartinant les pains de la sauce. Ajoutez le poulet pané, le fromage en tranches et les feuilles de laitue. Refermez et dégustez aussitôt. C''est prêt !');
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
    (r, 1, 'Préchauffez le four à 180°C. Lavez puis coupez le brocoli en sommités.'),
    (r, 2, 'Dans une casserole d''eau bouillante salée, ajoutez le brocoli. Laissez cuire 9 minutes.'),
    (r, 3, 'Une fois les brocolis cuits, égouttez-les. Réduisez-les en purée, à l''aide d''une fourchette.'),
    (r, 4, 'Ajoutez la béchamel puis mélangez pour l''incorporer.'),
    (r, 5, 'Ajoutez le pesto et la moitié du parmesan. Salez, poivrez et mélangez à nouveau.'),
    (r, 6, 'Dans un plat allant au four, étalez une première couche du mélange aux brocolis. Disposez les feuilles de lasagnes, puis répétez jusqu''à épuisement des ingrédients.'),
    (r, 7, 'Terminez par une couche de brocolis, puis parsemez du reste de parmesan râpé. Enfournez 35 minutes à 180°C.'),
    (r, 8, 'Une fois dorées et cuites à cœur, sortez les lasagnes du four et servez-les avec une salade verte. C''est prêt !');
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
    (r, 'Ravioli (ricotta-épinards)', 300, 'g', 'Crémerie', 0),
    (r, 'Tomates séchées', 40, 'g', 'Épicerie salée', 1),
    (r, 'Crème fraîche', 2, 'c. à s.', 'Crémerie', 2),
    (r, 'Épinard (frais)', 4, 'poignée', 'Fruits & Légumes', 3),
    (r, 'Parmesan (râpé)', 2, 'c. à s.', 'Crémerie', 4),
    (r, 'Ail', 0.5, 'gousse', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Égouttez puis émincez les tomates séchées.'),
    (r, 2, 'Dans une casserole d''eau bouillante salée, faites cuire les ravioli selon les instructions du paquet. En fin de cuisson, égouttez-les.'),
    (r, 3, 'Pendant ce temps, faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez l''ail râpé et faites-le revenir 30 secondes.'),
    (r, 4, 'Ajoutez les tomates séchées et la crème fraîche, puis mélangez bien.'),
    (r, 5, 'Ajoutez les épinards et un filet d''eau. Poursuivez la cuisson 2 minutes, en remuant.'),
    (r, 6, 'Ajoutez les ravioli et le parmesan râpé. Poivrez, puis mélangez délicatement 1 à 2 minutes.'),
    (r, 7, 'Servez les ravioles à la toscane dans une assiette. C''est prêt !');
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
    (r, 'Brie', 60, 'g', 'Crémerie', 4);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Étalez le fromage frais sur chaque tranche.'),
    (r, 2, 'Ajoutez le brie coupé en tranche sur l''une et la confiture sur l''autre.'),
    (r, 3, 'Salez, poivrez. Ajoutez quelques pousses d''épinards. Refermez le sandwich.'),
    (r, 4, 'Dans une poêle à feu moyen, ajoutez une noisette de beurre et faire revenir les grilled cheese 2 minutes sur chaque face.'),
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
    (r, 1, 'Concassez grossièrement les noisettes, puis toastez-les à sec dans une poêle chaude. Réservez.'),
    (r, 2, 'Préparez la vinaigrette. Dans un petit bol, mélangez : la moutarde, le vinaigre de cidre et 1 cuillère à soupe d''huile d''olive par personne. Salez et poivrez.'),
    (r, 3, 'Lavez puis émincez les endives grossièrement.'),
    (r, 4, 'Lavez puis coupez les pommes en fines lamelles, puis en petits dés.'),
    (r, 5, 'Coupez l''avocat en deux. Retirez la peau, puis coupez-le en petits dés.'),
    (r, 6, 'Coupez le comté en petits cubes.'),
    (r, 7, 'Dans une assiette creuse, servez les endives avec la pomme, l''avocat, le comté et les noisettes toastées. Versez la vinaigrette, puis mélangez. C''est prêt !');
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
    (r, 'Lard', 2, 'tranche', 'Traiteur & Charcuterie', 2),
    (r, 'Beurre', 40, 'g', 'Crémerie', 3),
    (r, 'Oignon jaune', 0.5, 'pièce', 'Fruits & Légumes', 4),
    (r, 'Persil (frais)', 0.2, 'bouquet', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Épluchez puis coupez l''oignon en fines tranches.'),
    (r, 2, 'Épluchez puis coupez le panais en morceaux.'),
    (r, 3, 'Faites chauffer une casserole et ajoutez un filet d''huile d''olive. Ajoutez l''oignon et le panais. Salez, poivrez et laissez cuire 3 minutes sur feu moyen.'),
    (r, 4, 'Ajoutez de l''eau à hauteur. Couvrez et laissez cuire 25 minutes sur feu moyen.'),
    (r, 5, 'Faites chauffer une casserole d''eau. Ajoutez une cuillère à soupe de vinaigre. Portez à petite ébullition et formez un tourbillon.'),
    (r, 6, 'Cassez votre œuf dans un petit récipient. Versez-le délicatement dans l''eau et faites cuire 3 minutes. Réservez.'),
    (r, 7, 'Faites griller les tranches de lard dans une poêle bien chaude jusqu''à ce qu''elles deviennent croustillantes.'),
    (r, 8, 'Une fois les panais cuits, retirez la casserole du feu.'),
    (r, 9, 'Mixez-les avec du beurre jusqu''à obtenir une purée lisse.'),
    (r, 10, 'Dans une assiette creuse, déposez la crème de panais, l''œuf poché et les morceaux de lard. C''est prêt !');
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
    (r, 'Pain de mie', 1, 'tranche', 'Pain & Pâtisserie', 1),
    (r, 'Tomate (concentré)', 25, 'g', 'Épicerie salée', 2),
    (r, 'Échalote', 0.5, 'pièce', 'Fruits & Légumes', 3),
    (r, 'Œuf', 2, 'pièce', 'Crémerie', 4),
    (r, 'Persil (frais)', 2, 'brin', 'Fruits & Légumes', 5),
    (r, 'Salade (mélange)', 4, 'poignée', 'Fruits & Légumes', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Préchauffez le four à 180°C. Épluchez puis émincez finement les échalotes.'),
    (r, 2, 'Déchirez le pain de mie en gros morceaux.'),
    (r, 3, 'Dans un saladier, ajoutez : les échalotes, le pain de mie, le thon émietté, le concentré de tomates et les œufs. Salez, poivrez puis ajoutez le persil. Mixez le tout.'),
    (r, 4, 'Tapissez un moule à cake de papier cuisson. Versez-y la pâte, puis enfournez 35 à 40 minutes à 180°C.'),
    (r, 5, 'Une fois le pain de thon bien doré, servez-le accompagné de la salade verte. C''est prêt !');
  raise notice 'Ajoutée : %', 'Pain de thon à la tomate';
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
