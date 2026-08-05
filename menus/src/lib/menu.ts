import type { SupabaseClient } from "@supabase/supabase-js";

import type { Database, WeeklyMenu } from "@/lib/types/database";

type Client = SupabaseClient<Database>;

/**
 * Récupère le menu d'une semaine, en le créant au besoin.
 * `upsert` + contrainte unique (year, week_number) : deux téléphones qui
 * planifient en même temps retombent sur le même menu.
 */
export async function getOrCreateMenu(
  supabase: Client,
  week: number,
  year: number,
): Promise<WeeklyMenu> {
  const { data: existing } = await supabase
    .from("weekly_menu")
    .select("*")
    .eq("week_number", week)
    .eq("year", year)
    .maybeSingle();

  if (existing) return existing;

  const { data, error } = await supabase
    .from("weekly_menu")
    .upsert(
      { week_number: week, year },
      { onConflict: "year,week_number", ignoreDuplicates: false },
    )
    .select()
    .single();

  if (error) throw error;
  return data;
}
