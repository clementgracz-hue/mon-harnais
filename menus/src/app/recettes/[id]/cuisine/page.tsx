import { notFound } from "next/navigation";

import { CookMode } from "@/components/cook-mode";
import { createClient } from "@/lib/supabase/server";
import type { RecipeWithDetails } from "@/lib/types/database";

export const dynamic = "force-dynamic";

export default async function CookModePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const supabase = await createClient();

  const { data } = await supabase
    .from("recipes")
    .select("*, recipe_ingredients(*), recipe_steps(*)")
    .eq("id", id)
    .maybeSingle();

  const recipe = data as RecipeWithDetails | null;
  if (!recipe) notFound();

  return <CookMode recipe={recipe} />;
}
