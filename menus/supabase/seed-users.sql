-- ============================================================================
--  Comptes provisoires — à exécuter APRÈS schema.sql, dans SQL Editor.
--
--  Crée les deux comptes de la maison avec un mot de passe provisoire.
--  À CHANGER dès la première connexion : Authentication > Users > … >
--  « Reset password » (ou « Send magic link »).
--
--  Identifiants créés :
--    clementgracz+clement@gmail.com  /  Menus-q3RzAtDqyO   (Clément)
--    clementgracz+mathile@gmail.com  /  Menus-r6yHxjwDXe   (Mathile)
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
      'email',    'clementgracz+mathile@gmail.com',
      'password', 'Menus-r6yHxjwDXe',
      'name',     'Mathile'
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
      raw_app_meta_data, raw_user_meta_data
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
      )
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
