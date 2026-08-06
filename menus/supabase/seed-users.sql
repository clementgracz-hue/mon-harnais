-- ============================================================================
--  Comptes provisoires — à exécuter APRÈS schema.sql, dans SQL Editor.
--
--  Crée les deux comptes de la maison avec un mot de passe provisoire.
--  À CHANGER dès la première connexion : Authentication > Users > … >
--  « Reset password » (ou « Send magic link »).
--
--  Identifiants créés :
--    clementgracz+clement@gmail.com   /  Menus-q3RzAtDqyO   (Clément)
--    clementgracz+mathilde@gmail.com  /  Menus-r6yHxjwDXe   (Mathilde)
--
--  Les adresses en « +suffixe » arrivent toutes les deux dans la boîte
--  clementgracz@gmail.com : pratique pour les mails de réinitialisation.
--  Remplace-les librement, y compris par deux vraies adresses distinctes.
--
--  Le script est rejouable : un compte déjà présent est laissé tel quel.
-- ============================================================================

-- pgcrypto vit dans `extensions` sur Supabase, dans `public` ailleurs.
set search_path = public, extensions;

do $$
declare
  comptes constant jsonb := jsonb_build_array(
    jsonb_build_object(
      'email',    'clementgracz+clement@gmail.com',
      'password', 'Menus-q3RzAtDqyO',
      'name',     'Clément'
    ),
    jsonb_build_object(
      'email',    'clementgracz+mathilde@gmail.com',
      'password', 'Menus-r6yHxjwDXe',
      'name',     'Mathilde'
    )
  );
  compte   jsonb;
  user_id  uuid;
begin
  for compte in select * from jsonb_array_elements(comptes) loop
    if exists (select 1 from auth.users where email = compte->>'email') then
      raise notice 'Compte déjà présent, ignoré : %', compte->>'email';
      continue;
    end if;

    user_id := gen_random_uuid();

    insert into auth.users (
      instance_id, id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      -- Ces colonnes doivent valoir '' et non NULL : GoTrue les lit comme des
      -- chaînes non nulles, et un NULL fait échouer la connexion avec
      -- « Database error querying schema ».
      confirmation_token, recovery_token, email_change, email_change_token_new
    ) values (
      '00000000-0000-0000-0000-000000000000',
      user_id,
      'authenticated',
      'authenticated',
      compte->>'email',
      crypt(compte->>'password', gen_salt('bf')),
      now(),   -- email confirmé d'office : pas de mail de validation à attendre
      now(),
      now(),
      jsonb_build_object('provider', 'email', 'providers', jsonb_build_array('email')),
      jsonb_build_object(
        'name',       compte->>'name',
        'full_name',  compte->>'name',
        'email',      compte->>'email'
      ),
      '', '', '', ''
    );

    -- Sans cette identité, GoTrue refuse la connexion par mot de passe.
    insert into auth.identities (
      id, user_id, provider, provider_id, identity_data,
      last_sign_in_at, created_at, updated_at
    ) values (
      gen_random_uuid(),
      user_id,
      'email',
      compte->>'email',
      jsonb_build_object(
        'sub',            user_id::text,
        'email',          compte->>'email',
        'email_verified', true,
        'phone_verified', false
      ),
      now(),
      now(),
      now()
    );

    raise notice 'Compte créé : % (%)', compte->>'email', compte->>'name';
  end loop;
end
$$;

-- ---------------------------------------------------------------------------
--  Réparation — à exécuter aussi sur des comptes déjà créés
--
--  GoTrue lit les colonnes de jetons comme des chaînes non nulles. Un compte
--  inséré en SQL sans les renseigner les laisse à NULL, et toute connexion
--  échoue alors avec « Database error querying schema ». Les colonnes
--  n'existent pas toutes selon la version de GoTrue, d'où le test préalable.
-- ---------------------------------------------------------------------------
do $$
declare
  colonne text;
  corrigees integer;
begin
  foreach colonne in array array[
    'confirmation_token', 'recovery_token', 'email_change',
    'email_change_token_new', 'email_change_token_current',
    'phone_change', 'phone_change_token', 'reauthentication_token'
  ] loop
    if exists (
      select 1 from information_schema.columns
      where table_schema = 'auth' and table_name = 'users' and column_name = colonne
    ) then
      execute format('update auth.users set %I = '''' where %I is null', colonne, colonne);
      get diagnostics corrigees = row_count;
      if corrigees > 0 then
        raise notice 'auth.users.% : % NULL remplacés par une chaîne vide', colonne, corrigees;
      end if;
    end if;
  end loop;
end
$$;

-- Vérification
select
  u.email,
  u.raw_user_meta_data->>'name' as prenom,
  u.email_confirmed_at is not null as email_confirme,
  count(i.id) as identites
from auth.users u
left join auth.identities i on i.user_id = u.id
group by u.id, u.email, u.raw_user_meta_data, u.email_confirmed_at
order by u.created_at;
