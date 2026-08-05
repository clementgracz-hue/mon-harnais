import Image from "next/image";
import Link from "next/link";
import { Clock, Leaf, UtensilsCrossed } from "lucide-react";

import { StarRating } from "@/components/star-rating";
import { Badge } from "@/components/ui/badge";
import type { Recipe } from "@/lib/types/database";
import { cn, formatDuration } from "@/lib/utils";

const VEG_TAGS = ["végé", "vege", "végétal", "vegetarien", "végétarien"];

/** Une recette est considérée 100% végétale d'après ses étiquettes. */
export function isVegRecipe(recipe: Pick<Recipe, "tags">) {
  return recipe.tags.some((tag) =>
    VEG_TAGS.some((needle) => tag.toLowerCase().includes(needle)),
  );
}

type Props = {
  recipe: Recipe;
  className?: string;
  /** Contenu additionnel (bouton d'ajout au menu, jour assigné…). */
  action?: React.ReactNode;
};

export function RecipeCard({ recipe, className, action }: Props) {
  const total = (recipe.prep_time ?? 0) + (recipe.cook_time ?? 0);
  const veg = isVegRecipe(recipe);

  return (
    <article
      className={cn(
        "group relative overflow-hidden rounded-xl border bg-card shadow-sm transition-shadow active:shadow-none",
        className,
      )}
    >
      <Link href={`/recettes/${recipe.id}`} className="flex gap-3 p-3">
        <div className="relative h-24 w-24 shrink-0 overflow-hidden rounded-lg bg-muted">
          {recipe.image_url ? (
            <Image
              src={recipe.image_url}
              alt=""
              fill
              sizes="96px"
              className="object-cover"
            />
          ) : (
            <div className="flex h-full items-center justify-center text-muted-foreground">
              <UtensilsCrossed className="h-7 w-7" aria-hidden />
            </div>
          )}
        </div>

        <div className="min-w-0 flex-1">
          <h3 className="line-clamp-2 font-semibold leading-snug">{recipe.title}</h3>

          <div className="mt-1 flex flex-wrap items-center gap-x-3 gap-y-1 text-xs text-muted-foreground">
            {total > 0 && (
              <span className="inline-flex items-center gap-1">
                <Clock className="h-3.5 w-3.5" aria-hidden />
                {formatDuration(total)}
              </span>
            )}
            {recipe.rating != null && <StarRating value={recipe.rating} size="sm" />}
          </div>

          <div className="mt-2 flex flex-wrap gap-1">
            {veg && (
              <Badge variant="veg" className="gap-1">
                <Leaf className="h-3 w-3" aria-hidden />
                100% végétal
              </Badge>
            )}
            {recipe.tags.slice(0, 2).map((tag) => (
              <Badge key={tag} variant="secondary">
                {tag}
              </Badge>
            ))}
          </div>
        </div>
      </Link>

      {action && <div className="absolute bottom-2 right-2">{action}</div>}
    </article>
  );
}
