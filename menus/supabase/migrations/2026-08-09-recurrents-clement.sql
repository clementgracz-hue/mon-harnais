-- Produits récurrents (fond de roulement) : remplace la liste installée par
-- défaut par les 20 achats les plus fréquents relevés sur le Drive.
--
-- Rejouable : la table est vidée puis reremplie à l'identique.
-- Aucune autre table ne référence staple_products — rien d'autre n'est touché.

begin;

delete from public.staple_products;

insert into public.staple_products (name, category, is_frequent, is_selected) values
  ('Beurre demi-sel',                                       'Crémerie',          true, false),
  ('Fromage râpé emmental bio',                             'Crémerie',          true, false),
  ('Feta AOP grecque',                                      'Crémerie',          true, false),
  ('Skyr protéiné 0% MG',                                   'Crémerie',          true, false),
  ('Bananes Max Havelaar bio',                              'Fruits & Légumes',  true, false),
  ('Kiwi jaune',                                            'Fruits & Légumes',  true, false),
  ('Lime',                                                  'Fruits & Légumes',  true, false),
  ('Sauce pesto genovese au basilic frais',                 'Épicerie salée',    true, false),
  ('Chips pommes de terre au chèvre piment d''Espelette',   'Épicerie salée',    true, false),
  ('Riz long de Camargue IGP',                              'Épicerie salée',    true, false),
  ('Confiture framboise intense',                           'Épicerie sucrée',   true, false),
  ('Tablette de chocolat lait Excellence',                  'Épicerie sucrée',   true, false),
  ('Biscuits La Grande Galette',                            'Épicerie sucrée',   true, false),
  ('Biscuit bio petit fondant cœur chocolat',               'Épicerie sucrée',   true, false),
  ('Dessert fruitier multi-variétés sans sucres ajoutés bio','Épicerie sucrée',  true, false),
  ('Café soluble cappuccino café viennois',                 'Épicerie sucrée',   true, false),
  ('Jus d''orange avec pulpe',                              'Boissons',          true, false),
  ('Soda Indian Tonic zéro sucres',                         'Boissons',          true, false),
  ('Lait bébé en poudre 3ème âge bio',                      'Bébé',              true, false),
  ('Mouchoirs en papier confort ultra soft',                'Hygiène & Beauté',  true, false);

commit;

-- Contrôle : 20 lignes, dans l'ordre du parcours du Drive.
select category, count(*) as produits, string_agg(name, ' · ' order by name) as liste
  from public.staple_products
 group by category
 order by min(
   array_position(enum_range(null::aisle_category), category)
 );
