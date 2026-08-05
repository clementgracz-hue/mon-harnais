import type { Metadata } from "next";

import { PageHeader } from "@/components/page-header";
import { RecipeList } from "@/components/recipe-list";
import { createClient } from "@/lib/supabase/server";

export const metadata: Metadata = { title: "Recettes" };
export const dynamic = "force-dynamic";

export default async function RecipesPage() {
  const supabase = await createClient();
  const { data: recipes } = await supabase
    .from("recipes")
    .select("*")
    .order("created_at", { ascending: false });

  const count = recipes?.length ?? 0;

  return (
    <main className="pb-nav">
      <PageHeader
        title="Recettes"
        subtitle={count > 0 ? `${count} recette${count > 1 ? "s" : ""}` : undefined}
      />
      <RecipeList recipes={recipes ?? []} />
    </main>
  );
}
