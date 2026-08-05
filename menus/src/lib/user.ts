import type { User } from "@supabase/supabase-js";

type Metadata = { name?: string; full_name?: string };

/**
 * Prénom affiché comme auteur (pense-bête, avis).
 * Vient de `raw_user_meta_data.name`, renseigné à la création du compte ;
 * à défaut, la partie locale de l'email, sans le suffixe « +… ».
 */
export function displayName(user: User | null | undefined) {
  const metadata = (user?.user_metadata ?? {}) as Metadata;
  const fromMetadata = metadata.name?.trim() || metadata.full_name?.trim();
  if (fromMetadata) return fromMetadata;

  const local = user?.email?.split("@")[0]?.split("+")[0]?.trim();
  return local || "Nous";
}
