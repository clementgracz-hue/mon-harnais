import Image from "next/image";
import Link from "next/link";
import { notFound } from "next/navigation";
import { CalendarPlus, ChefHat, Clock, Flame, Leaf, Pencil } from "lucide-react";

import { AddToWeekDialog } from "@/components/add-to-week-dialog";
import { PageHeader } from "@/components/page-header";
import { RecipeComments } from "@/components/recipe-comments";
import { StarRating } from "@/components/star-rating";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { AISLE_EMOJI, aisleRank } from "@/lib/aisles";
import { createClient } from "@/lib/supabase/server";
import type { Aisle, RecipeWithDetails } from "@/lib/types/database";
import { displayName } from "@/lib/user";
import { formatDuration } from "@/lib/utils";
import { deriveVeg } from "@/lib/veg";

export const dynamic = "force-dynamic";

async function getRecipe(id: string) {
  const supabase = await createClient();
  const { data } = await supabase
    .from("recipes")
    .select("*, recipe_ingredients(*), recipe_steps(*), recipe_comments(*)")
    .eq("id", id)
    .maybeSingle();

  return data as RecipeWithDetails | null;
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const recipe = await getRecipe(id);
  return { title: recipe?.title ?? "Recette" };
}

export default async function RecipePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const recipe = await getRecipe(id);
  if (!recipe) notFound();

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  const author = displayName(user);

  const ingredients = [...recipe.recipe_ingredients].sort(
    (a, b) =>
      aisleRank(a.aisle_category) - aisleRank(b.aisle_category) ||
      a.position - b.position,
  );
  const steps = [...recipe.recipe_steps].sort(
    (a, b) => a.step_number - b.step_number,
  );
  const comments = [...(recipe.recipe_comments ?? [])].sort(
    (a, b) => +new Date(b.created_at) - +new Date(a.created_at),
  );

  const groupedIngredients = ingredients.reduce<
    Map<Aisle, typeof ingredients>
  >((map, ingredient) => {
    const list = map.get(ingredient.aisle_category) ?? [];
    list.push(ingredient);
    map.set(ingredient.aisle_category, list);
    return map;
  }, new Map());

  // Déduit du rayon des ingrédients : sert de badge et de valeur par défaut
  // quand la recette est ajoutée à la semaine.
  const verdict = deriveVeg(ingredients);
  const veg = verdict.isVeg && ingredients.length > 0;

  return (
    <main className="pb-nav">
      <PageHeader
        title={recipe.title}
        backHref="/recettes"
        action={
          <Button asChild variant="ghost" size="icon" aria-label="Modifier la recette">
            <Link href={`/recettes/${recipe.id}/modifier`}>
              <Pencil className="h-5 w-5 text-muted-foreground" />
            </Link>
          </Button>
        }
      />

      {recipe.image_url && (
        <div className="relative aspect-[16/10] w-full bg-muted">
          <Image
            src={recipe.image_url}
            alt=""
            fill
            sizes="(max-width: 448px) 100vw, 448px"
            className="object-cover"
            priority
          />
        </div>
      )}

      <div className="space-y-6 p-4">
        <div className="flex flex-wrap items-center gap-x-4 gap-y-2 text-sm text-muted-foreground">
          {recipe.prep_time != null && (
            <span className="inline-flex items-center gap-1.5">
              <Clock className="h-4 w-4" aria-hidden />
              Prépa {formatDuration(recipe.prep_time)}
            </span>
          )}
          {recipe.cook_time != null && (
            <span className="inline-flex items-center gap-1.5">
              <Flame className="h-4 w-4" aria-hidden />
              Cuisson {formatDuration(recipe.cook_time)}
            </span>
          )}
          {recipe.rating != null && <StarRating value={recipe.rating} size="sm" />}
        </div>

        <div className="flex flex-wrap gap-1.5">
          {veg && (
            <Badge variant="veg" className="gap-1">
              <Leaf className="h-3 w-3" aria-hidden />
              100% végétal
            </Badge>
          )}
          {recipe.tags.map((tag) => (
            <Badge key={tag} variant="secondary">
              {tag}
            </Badge>
          ))}
        </div>

        {recipe.description && (
          <p className="text-sm leading-relaxed text-muted-foreground">
            {recipe.description}
          </p>
        )}

        <div className="grid grid-cols-2 gap-3">
          <Button asChild size="lg">
            <Link href={`/recettes/${recipe.id}/cuisine`}>
              <ChefHat className="h-5 w-5" aria-hidden />
              En cuisine
            </Link>
          </Button>
          <AddToWeekDialog
            recipeId={recipe.id}
            defaultVeg={veg}
            blockers={verdict.blockers}
            trigger={
              <Button variant="outline" size="lg">
                <CalendarPlus className="h-5 w-5" aria-hidden />
                Ma semaine
              </Button>
            }
          />
        </div>

        <section className="space-y-3">
          <h2 className="text-lg font-semibold">
            Ingrédients{" "}
            <span className="text-sm font-normal text-muted-foreground">
              ({ingredients.length})
            </span>
          </h2>
          {ingredients.length === 0 ? (
            <p className="text-sm text-muted-foreground">
              Aucun ingrédient renseigné.
            </p>
          ) : (
            <div className="space-y-4">
              {[...groupedIngredients.entries()].map(([aisle, items]) => (
                <div key={aisle}>
                  <p className="mb-1.5 text-xs font-semibold uppercase tracking-wide text-muted-foreground">
                    {AISLE_EMOJI[aisle]} {aisle}
                  </p>
                  <ul className="divide-y rounded-xl border">
                    {items.map((ingredient) => (
                      <li
                        key={ingredient.id}
                        className="flex items-center justify-between gap-3 px-3 py-2.5 text-sm"
                      >
                        <span>{ingredient.name}</span>
                        <span className="shrink-0 text-muted-foreground">
                          {ingredient.quantity != null
                            ? `${ingredient.quantity} ${ingredient.unit ?? ""}`.trim()
                            : "—"}
                        </span>
                      </li>
                    ))}
                  </ul>
                </div>
              ))}
            </div>
          )}
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-semibold">Préparation</h2>
          {steps.length === 0 ? (
            <p className="text-sm text-muted-foreground">Aucune étape renseignée.</p>
          ) : (
            <ol className="space-y-3">
              {steps.map((step) => (
                <li key={step.id} className="flex gap-3">
                  <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">
                    {step.step_number}
                  </span>
                  <p className="pt-0.5 text-sm leading-relaxed">
                    {step.instruction}
                  </p>
                </li>
              ))}
            </ol>
          )}
        </section>

        <RecipeComments
          recipeId={recipe.id}
          comments={comments}
          author={author}
        />
      </div>
    </main>
  );
}
