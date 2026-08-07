import Link from "next/link";
import { notFound } from "next/navigation";
import { Beef, Leaf } from "lucide-react";

import { ArchivedList } from "@/components/archived-list";
import { PageHeader } from "@/components/page-header";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/server";
import type {
  ShoppingRun,
  ShoppingRunItem,
  ShoppingRunRecipe,
} from "@/lib/types/database";

export const dynamic = "force-dynamic";

type Row = ShoppingRun & {
  shopping_run_items: ShoppingRunItem[];
  shopping_run_recipes: ShoppingRunRecipe[];
};

export default async function ArchivedRunPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const supabase = await createClient();

  const { data } = await supabase
    .from("shopping_runs")
    .select("*, shopping_run_items(*), shopping_run_recipes(*)")
    .eq("id", id)
    .maybeSingle();

  const run = data as Row | null;
  if (!run) notFound();

  const items = [...run.shopping_run_items].sort((a, b) => a.position - b.position);
  const recipes = [...run.shopping_run_recipes].sort((a, b) =>
    a.title.localeCompare(b.title, "fr"),
  );

  const date = new Date(run.created_at).toLocaleDateString("fr-FR", {
    day: "numeric",
    month: "long",
    year: "numeric",
  });

  return (
    <main className="pb-nav">
      <PageHeader
        title={`Semaine ${run.week_number}`}
        subtitle={`Commandée le ${date}${run.closed_by ? ` par ${run.closed_by}` : ""}`}
        backHref="/courses/historique"
      />

      <div className="space-y-6 p-4">
        {recipes.length > 0 && (
          <section className="space-y-2">
            <h2 className="text-sm font-semibold uppercase tracking-wide text-muted-foreground">
              Les repas de cette semaine
            </h2>
            <ul className="divide-y rounded-xl border">
              {recipes.map((recipe) => (
                <li
                  key={recipe.id}
                  className="flex items-center justify-between gap-3 px-3 py-3"
                >
                  <div className="min-w-0">
                    {/* Le lien saute si la recette a été supprimée depuis. */}
                    {recipe.recipe_id ? (
                      <Link
                        href={`/recettes/${recipe.recipe_id}`}
                        className="block truncate text-sm font-medium underline-offset-4 hover:underline"
                      >
                        {recipe.title}
                      </Link>
                    ) : (
                      <span className="block truncate text-sm font-medium text-muted-foreground">
                        {recipe.title}
                      </span>
                    )}
                    {recipe.day_assigned && (
                      <span className="text-xs capitalize text-muted-foreground">
                        {recipe.day_assigned}
                      </span>
                    )}
                  </div>
                  <Badge
                    variant={recipe.is_kid_friendly_veg ? "veg" : "meat"}
                    className="shrink-0 gap-1"
                  >
                    {recipe.is_kid_friendly_veg ? (
                      <>
                        <Leaf className="h-3 w-3" aria-hidden />
                        Végétal
                      </>
                    ) : (
                      <>
                        <Beef className="h-3 w-3" aria-hidden />
                        Animal
                      </>
                    )}
                  </Badge>
                </li>
              ))}
            </ul>
          </section>
        )}

        <section className="space-y-2">
          <h2 className="text-sm font-semibold uppercase tracking-wide text-muted-foreground">
            La liste commandée ({items.length})
          </h2>
          <ArchivedList items={items} />
        </section>
      </div>
    </main>
  );
}
