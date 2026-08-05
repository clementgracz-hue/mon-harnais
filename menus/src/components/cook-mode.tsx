"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { Check, X } from "lucide-react";

import { Checkbox } from "@/components/ui/checkbox";
import { cn } from "@/lib/utils";
import type { RecipeWithDetails } from "@/lib/types/database";

/** Garde l'écran allumé pendant la cuisine (si le navigateur le permet). */
function useWakeLock() {
  useEffect(() => {
    let sentinel: WakeLockSentinel | null = null;
    let released = false;

    async function request() {
      try {
        sentinel = await navigator.wakeLock?.request("screen");
      } catch {
        // Batterie faible ou API indisponible : sans conséquence.
      }
    }

    function onVisibilityChange() {
      if (document.visibilityState === "visible" && !released) void request();
    }

    void request();
    document.addEventListener("visibilitychange", onVisibilityChange);

    return () => {
      released = true;
      document.removeEventListener("visibilitychange", onVisibilityChange);
      void sentinel?.release();
    };
  }, []);
}

export function CookMode({ recipe }: { recipe: RecipeWithDetails }) {
  useWakeLock();

  const ingredients = [...recipe.recipe_ingredients].sort(
    (a, b) => a.position - b.position,
  );
  const steps = [...recipe.recipe_steps].sort(
    (a, b) => a.step_number - b.step_number,
  );

  const [checkedIngredients, setCheckedIngredients] = useState<Set<string>>(
    new Set(),
  );
  const [checkedSteps, setCheckedSteps] = useState<Set<string>>(new Set());

  function toggle(
    setter: React.Dispatch<React.SetStateAction<Set<string>>>,
    id: string,
  ) {
    setter((current) => {
      const next = new Set(current);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }

  const done = checkedSteps.size;
  const progress = steps.length ? Math.round((done / steps.length) * 100) : 0;

  return (
    <div className="min-h-dvh bg-background">
      <header className="sticky top-0 z-30 border-b bg-background px-4 pb-3 pt-[calc(0.75rem+env(safe-area-inset-top))]">
        <div className="flex items-center gap-3">
          <div className="min-w-0 flex-1">
            <p className="text-xs font-medium uppercase tracking-wide text-primary">
              En cuisine
            </p>
            <h1 className="truncate text-lg font-bold">{recipe.title}</h1>
          </div>
          <Link
            href={`/recettes/${recipe.id}`}
            aria-label="Quitter le mode cuisine"
            className="rounded-lg p-2 text-muted-foreground transition-colors hover:bg-accent"
          >
            <X className="h-6 w-6" />
          </Link>
        </div>
        {steps.length > 0 && (
          <div className="mt-3 h-1.5 overflow-hidden rounded-full bg-muted">
            <div
              className="h-full rounded-full bg-primary transition-[width] duration-300"
              style={{ width: `${progress}%` }}
              role="progressbar"
              aria-valuenow={progress}
              aria-valuemin={0}
              aria-valuemax={100}
              aria-label="Progression des étapes"
            />
          </div>
        )}
      </header>

      <div className="space-y-8 px-4 py-6 pb-16">
        <section>
          <h2 className="mb-3 text-base font-semibold uppercase tracking-wide text-muted-foreground">
            Ingrédients
          </h2>
          <ul className="space-y-1">
            {ingredients.map((ingredient) => {
              const checked = checkedIngredients.has(ingredient.id);
              return (
                <li key={ingredient.id}>
                  <label
                    className={cn(
                      "flex cursor-pointer items-center gap-3 rounded-xl px-3 py-3 text-lg transition-colors",
                      checked ? "text-muted-foreground" : "bg-card",
                    )}
                  >
                    <Checkbox
                      checked={checked}
                      onCheckedChange={() =>
                        toggle(setCheckedIngredients, ingredient.id)
                      }
                    />
                    <span className={cn("flex-1", checked && "line-through")}>
                      {ingredient.name}
                    </span>
                    {ingredient.quantity != null && (
                      <span className="shrink-0 text-base font-medium">
                        {ingredient.quantity} {ingredient.unit ?? ""}
                      </span>
                    )}
                  </label>
                </li>
              );
            })}
          </ul>
        </section>

        <section>
          <h2 className="mb-3 text-base font-semibold uppercase tracking-wide text-muted-foreground">
            Étapes
          </h2>
          <ol className="space-y-3">
            {steps.map((step) => {
              const checked = checkedSteps.has(step.id);
              return (
                <li key={step.id}>
                  <label
                    className={cn(
                      "flex cursor-pointer gap-4 rounded-xl border p-4 transition-colors",
                      checked
                        ? "border-transparent bg-muted/50 text-muted-foreground"
                        : "bg-card",
                    )}
                  >
                    <span
                      className={cn(
                        "flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-base font-bold",
                        checked
                          ? "bg-primary text-primary-foreground"
                          : "bg-primary/10 text-primary",
                      )}
                    >
                      {checked ? <Check className="h-5 w-5" /> : step.step_number}
                    </span>
                    <p
                      className={cn(
                        "pt-1 text-lg leading-relaxed",
                        checked && "line-through",
                      )}
                    >
                      {step.instruction}
                    </p>
                    <input
                      type="checkbox"
                      className="sr-only"
                      checked={checked}
                      onChange={() => toggle(setCheckedSteps, step.id)}
                    />
                  </label>
                </li>
              );
            })}
          </ol>
        </section>

        {steps.length > 0 && done === steps.length && (
          <p className="rounded-xl bg-primary/10 p-4 text-center font-medium text-primary">
            C&apos;est prêt&nbsp;! Bon appétit 🍽️
          </p>
        )}
      </div>
    </div>
  );
}
