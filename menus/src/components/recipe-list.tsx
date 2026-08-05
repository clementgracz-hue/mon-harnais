"use client";

import { useMemo, useState } from "react";
import { Plus, Search } from "lucide-react";

import { AddRecipeDialog } from "@/components/add-recipe-dialog";
import { RecipeCard, type RecipeCardData } from "@/components/recipe-card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export function RecipeList({ recipes }: { recipes: RecipeCardData[] }) {
  const [query, setQuery] = useState("");
  const [activeTag, setActiveTag] = useState<string | null>(null);

  const tags = useMemo(
    () => [...new Set(recipes.flatMap((recipe) => recipe.tags))].sort(),
    [recipes],
  );

  const visible = useMemo(() => {
    const needle = query.trim().toLowerCase();
    return recipes.filter((recipe) => {
      const matchesQuery =
        !needle || recipe.title.toLowerCase().includes(needle);
      const matchesTag = !activeTag || recipe.tags.includes(activeTag);
      return matchesQuery && matchesTag;
    });
  }, [recipes, query, activeTag]);

  return (
    <div className="space-y-4 p-4">
      <div className="relative">
        <Search
          className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground"
          aria-hidden
        />
        <Input
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          placeholder="Chercher une recette"
          aria-label="Chercher une recette"
          className="pl-9"
        />
      </div>

      {tags.length > 0 && (
        <div className="-mx-4 flex gap-2 overflow-x-auto px-4 pb-1">
          {tags.map((tag) => {
            const active = activeTag === tag;
            return (
              <button
                key={tag}
                type="button"
                onClick={() => setActiveTag(active ? null : tag)}
                className={
                  active
                    ? "shrink-0 rounded-full bg-primary px-3 py-1.5 text-xs font-medium text-primary-foreground"
                    : "shrink-0 rounded-full border px-3 py-1.5 text-xs font-medium text-muted-foreground"
                }
              >
                {tag}
              </button>
            );
          })}
        </div>
      )}

      {visible.length === 0 ? (
        <p className="py-12 text-center text-sm text-muted-foreground">
          {recipes.length === 0
            ? "Aucune recette pour l'instant. Ajoute la première !"
            : "Aucune recette ne correspond."}
        </p>
      ) : (
        <ul className="space-y-3">
          {visible.map((recipe) => (
            <li key={recipe.id}>
              <RecipeCard recipe={recipe} />
            </li>
          ))}
        </ul>
      )}

      <AddRecipeDialog
        trigger={
          <Button
            size="icon"
            aria-label="Ajouter une recette"
            className="fixed bottom-[calc(5rem+env(safe-area-inset-bottom))] right-4 z-30 h-14 w-14 rounded-full shadow-lg"
          >
            <Plus className="h-6 w-6" />
          </Button>
        }
      />
    </div>
  );
}
