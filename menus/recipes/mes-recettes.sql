-- 5 recette(s) — généré par scripts/recipes-to-sql.mjs
-- Rejouable : une recette déjà présente (même titre) est ignorée.

-- Nouilles sautées, courgettes & tomates
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Nouilles sautées, courgettes & tomates')) then
    raise notice 'Déjà présente, ignorée : %', 'Nouilles sautées, courgettes & tomates';
    return;
  end if;

  insert into public.recipes (title, description, image_url, source_url, prep_time, cook_time, tags)
  values ('Nouilles sautées, courgettes & tomates', 'Jow · 4,4/5 (727 avis) · 246 kcal/portion · Nutri-score B · pour 2. Astuce : ajouter des crevettes, du poulet ou du tofu mariné.', 'https://static.jow.fr/1024x1024/patterns/yolk-04-202309.png_merge_recipes/p0kGMg006ZgoBQ.png.jpg', 'https://jow.fr/recipes/nouilles-sautees-courgettes-et-tomates-8c666m8wihrq1usb0t4m',
          5, 15,
          array['Express', 'Jow', 'Saison'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Nouilles chinoises (aux œufs)', 120, 'g', 'Épicerie salée', 0),
    (r, 'Tomates cerises', 200, 'g', 'Fruits & Légumes', 1),
    (r, 'Courgette', 200, 'g', 'Fruits & Légumes', 2),
    (r, 'Sauce soja salée', 2, 'c. à s.', 'Épicerie salée', 3),
    (r, 'Ail', 1, 'gousse', 'Fruits & Légumes', 4),
    (r, 'Graines de sésame', 1, 'c. à c.', 'Épicerie salée', 5),
    (r, 'Huile d''olive', 2, 'c. à c.', 'Épicerie salée', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole d''eau bouillante, faites cuire les nouilles selon les instructions du paquet. Égouttez-les en fin de cuisson.'),
    (r, 2, 'Lavez puis coupez les courgettes en demi-lunes.'),
    (r, 3, 'Faites chauffer un filet d''huile d''olive dans une poêle, sur feu moyen. Ajoutez les courgettes et l''ail râpé. Salez, poivrez et faites-les revenir 5 minutes.'),
    (r, 4, 'Ajoutez les tomates cerises et poursuivez la cuisson 4 à 5 minutes.'),
    (r, 5, 'Ajoutez les nouilles égouttées et la sauce soja. Faites sauter le tout 2 minutes supplémentaires.'),
    (r, 6, 'Servez dans une assiette ou un bol et parsemez de graines de sésame, si vous en avez. C''est prêt !');
  raise notice 'Ajoutée : %', 'Nouilles sautées, courgettes & tomates';
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

  insert into public.recipes (title, description, image_url, source_url, prep_time, cook_time, tags)
  values ('Pâtes aux petits pois & lardons', 'Jow · 4,6/5 (261 avis) · 730 kcal/portion · pour 2.', 'https://static.jow.fr/1024x1024/patterns/yolk-02-202309.png_merge_recipes/jkk2G8R1Rt.png.jpg', 'https://jow.fr/recipes/pates-aux-petits-pois-et-lardons-81sxkaju34c000vm1cwp',
          2, 10,
          array['Express', 'Jow', 'Plat unique'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pâtes (pipe rigate)', 200, 'g', 'Épicerie salée', 0),
    (r, 'Petits pois frais', 200, 'g', 'Fruits & Légumes', 1),
    (r, 'Lardons', 150, 'g', 'Traiteur & Charcuterie', 2),
    (r, 'Crème liquide', 40, 'ml', 'Crémerie', 3),
    (r, 'Parmesan râpé', 4, 'c. à s.', 'Crémerie', 4),
    (r, 'Menthe fraîche', 1, 'bouquet', 'Fruits & Légumes', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Dans une casserole d''eau bouillante salée, faites cuire les pâtes et les petits pois selon les instructions du paquet. En fin de cuisson, égouttez-les et réservez au chaud.'),
    (r, 2, 'Pendant ce temps, dans une poêle chaude, ajoutez les lardons. Faites-les revenir 5 minutes.'),
    (r, 3, 'Ajoutez la crème, le parmesan, les petits pois et les pâtes égouttés. Salez, poivrez et mélangez le tout.'),
    (r, 4, 'Servez dans une assiette. Parsemez de menthe ciselée, si vous en avez, et de parmesan râpé, s''il vous en reste. Réassaisonnez selon vos goûts. C''est prêt !');
  raise notice 'Ajoutée : %', 'Pâtes aux petits pois & lardons';
end
$$;

-- Salade lentilles & saumon
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Salade lentilles & saumon')) then
    raise notice 'Déjà présente, ignorée : %', 'Salade lentilles & saumon';
    return;
  end if;

  insert into public.recipes (title, description, image_url, source_url, prep_time, cook_time, tags)
  values ('Salade lentilles & saumon', 'Jow · 4,6/5 (265 avis) · 467 kcal/portion · pour 2.', 'https://static.jow.fr/1024x1024/patterns/powder-05-202309.png_merge_recipes/ycPxbC2fktZ0kQ.png.jpg', 'https://jow.fr/recipes/salade-lentilles-et-saumon-8j2261b3kxsgk9wp19zd',
          6, 8,
          array['Express', 'Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pavés de saumon frais', 2, 'pièce', 'Poissonnerie', 0),
    (r, 'Lentilles cuites', 400, 'g', 'Épicerie salée', 1),
    (r, 'Échalote', 1, 'pièce', 'Fruits & Légumes', 2),
    (r, 'Moutarde à l''ancienne', 1, 'c. à c.', 'Épicerie salée', 3),
    (r, 'Vinaigre balsamique', 1, 'c. à s.', 'Épicerie salée', 4),
    (r, 'Huile d''olive', 2, 'c. à s.', 'Épicerie salée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Si besoin, faites décongeler le saumon. Faites-le cuire dans une poêle bien chaude avec un filet d''huile d''olive.'),
    (r, 2, 'Salez et poivrez. Laissez cuire 6 minutes côté peau.'),
    (r, 3, 'Pendant ce temps, épluchez puis coupez l''échalote en fines lamelles.'),
    (r, 4, 'Réalisez la vinaigrette en mélangeant la moutarde à l''ancienne, le vinaigre balsamique et 1 c. à soupe d''huile d''olive par personne. Salez et poivrez.'),
    (r, 5, 'Retournez le saumon et faites cuire 1 minute de chaque côté. Débarrassez-le de la poêle et émiettez-le à l''aide d''une fourchette.'),
    (r, 6, 'Déposez les lentilles préalablement égouttées et rincées dans une assiette ou un plat. Ajoutez le saumon émietté et les lamelles d''échalote.'),
    (r, 7, 'Arrosez de sauce, mélangez si vous le souhaitez. Salez, poivrez, c''est prêt !');
  raise notice 'Ajoutée : %', 'Salade lentilles & saumon';
end
$$;

-- Galette forestière
do $$
declare r uuid;
begin
  if exists (select 1 from public.recipes where lower(title) = lower('Galette forestière')) then
    raise notice 'Déjà présente, ignorée : %', 'Galette forestière';
    return;
  end if;

  insert into public.recipes (title, description, image_url, source_url, prep_time, cook_time, tags)
  values ('Galette forestière', 'Jow · 4,8/5 (1052 avis) · 518 kcal/portion · pour 2.', 'https://static.jow.fr/1024x1024/patterns/kale-03-202309.png_merge_recipes/L80hdPF7LXqQfw.png.jpg', 'https://jow.fr/recipes/galette-forestiere-7xmx9j2l2rhc03yd0oqv',
          7, 10,
          array['Express', 'Jow'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Galettes de sarrasin', 2, 'pièce', 'Crémerie', 0),
    (r, 'Jambon blanc', 2, 'tranche', 'Traiteur & Charcuterie', 1),
    (r, 'Fromage râpé', 4, 'pincée', 'Crémerie', 2),
    (r, 'Champignons de Paris frais', 160, 'g', 'Fruits & Légumes', 3),
    (r, 'Œufs', 2, 'pièce', 'Crémerie', 4),
    (r, 'Échalote', 0.5, 'pièce', 'Fruits & Légumes', 5),
    (r, 'Beurre', 2, 'c. à c.', 'Crémerie', 6);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Si vous en avez, épluchez puis émincez finement les échalotes.'),
    (r, 2, 'Lavez puis coupez les champignons en fines lamelles.'),
    (r, 3, 'Faites fondre une noisette de beurre dans une poêle, sur feu vif. Ajoutez les échalotes et faites-les revenir 2 à 3 minutes, en remuant.'),
    (r, 4, 'Ajoutez les champignons et poursuivez la cuisson 5 à 6 minutes, jusqu''à ce que l''eau rendue par les champignons s''évapore totalement. Salez et poivrez. Réservez hors du feu.'),
    (r, 5, 'Dans la même poêle, faites fondre une seconde noisette de beurre. Ajoutez la galette de sarrasin.'),
    (r, 6, 'Cassez l''œuf au centre de la galette, en faisant attention de ne pas casser le jaune. Parsemez de fromage râpé, puis ajoutez le jambon déchiré en morceaux et les champignons grillés.'),
    (r, 7, 'Laissez cuire 3 minutes, sur feu moyen, puis repliez la galette en carré ou en demi-lune. C''est prêt !');
  raise notice 'Ajoutée : %', 'Galette forestière';
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

  insert into public.recipes (title, description, image_url, source_url, prep_time, cook_time, tags)
  values ('Bruschetta parma', 'Jow · 4,7/5 (374 avis) · 480 kcal/portion · pour 2. Aucune cuisson.', 'https://static.jow.fr/1024x1024/patterns/beet-05-202309.png_merge_recipes/iBFMY0XR50rGzw.png.jpg', 'https://jow.fr/recipes/bruschetta-parma-8bqufnlt7p7l0ggk09yc',
          8, 0,
          array['Express', 'Jow', 'Saison'])
  returning id into r;

  insert into public.recipe_ingredients (recipe_id, name, quantity, unit, aisle_category, position) values
    (r, 'Pain de campagne tranché', 4, 'tranche', 'Pain & Pâtisserie', 0),
    (r, 'Mozzarella', 100, 'g', 'Crémerie', 1),
    (r, 'Tomates', 300, 'g', 'Fruits & Légumes', 2),
    (r, 'Basilic frais', 1, 'bouquet', 'Fruits & Légumes', 3),
    (r, 'Jambon cru', 4, 'tranche', 'Traiteur & Charcuterie', 4),
    (r, 'Huile d''olive', null, null, 'Épicerie salée', 5);

  insert into public.recipe_steps (recipe_id, step_number, instruction) values
    (r, 1, 'Faites toaster les tranches de pain (au grille-pain ou au four en mode grill).'),
    (r, 2, 'Pendant ce temps, lavez puis coupez les tomates en fines lamelles.'),
    (r, 3, 'Une fois les tranches de pain toastées, ajoutez les tomates, quelques morceaux de mozzarella, le jambon, salez, poivrez, puis ajoutez un filet d''huile d''olive sur le dessus. C''est prêt !'),
    (r, 4, 'Optionnel : ajoutez quelques feuilles de basilic si vous en avez.');
  raise notice 'Ajoutée : %', 'Bruschetta parma';
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
