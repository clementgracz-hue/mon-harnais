"use client";

import Link from "next/link";
import { Check, Loader2, Plus } from "lucide-react";

import { RecipeCard, type RecipeCardData } from "@/components/recipe-card";
import { useWeekSelection } from "@/components/use-week-selection";
import type { Suggestion } from "@/lib/suggest";
import { cn } from "@/lib/utils";

export type SuggestionCard = Suggestion & { card: RecipeCardData };

type Props = {
  suggestions: SuggestionCard[];
  selectedIds: string[];
  /** Message affiché quand il n'y a rien à proposer. */
  empty: string;
};

function urgencyLabel(days: number | null) {
  if (days === null) return null;
  if (days < 0) return "date dépassée";
  if (days === 0) return "à consommer aujourd'hui";
  if (days === 1) return "à consommer demain";
  return `à consommer sous ${days} jours`;
}

/** Les recettes que le frigo permet, la plus urgente en tête. */
export function FridgeSuggestions({ suggestions, selectedIds, empty }: Props) {
  const { selected, pending, toggle } = useWeekSelection(selectedIds);

  if (suggestions.length === 0) {
    return <p className="py-12 text-center text-sm text-muted-foreground">{empty}</p>;
  }

  return (
    <ul className="space-y-3">
      {suggestions.map((suggestion) => {
        const isSelected = selected.has(suggestion.card.id);
        const isPending = pending === suggestion.card.id;
        const urgency = urgencyLabel(suggestion.urgencyDays);

        return (
          <li key={suggestion.card.id} className="space-y-1.5">
            <RecipeCard
              recipe={suggestion.card}
              action={
                <button
                  type="button"
                  onClick={(event) => {
                    event.preventDefault();
                    void toggle(suggestion.card);
                  }}
                  disabled={isPending}
                  aria-pressed={isSelected}
                  aria-label={
                    isSelected
                      ? `Retirer ${suggestion.card.title} de la semaine`
                      : `Ajouter ${suggestion.card.title} à la semaine`
                  }
                  className={cn(
                    "mr-3 flex h-12 w-12 items-center justify-center rounded-full border-2 transition-colors active:scale-95",
                    isSelected
                      ? "border-primary bg-primary text-primary-foreground"
                      : "border-dashed border-input bg-background text-muted-foreground",
                  )}
                >
                  {isPending ? (
                    <Loader2 className="h-5 w-5 animate-spin" />
                  ) : isSelected ? (
                    <Check className="h-5 w-5" strokeWidth={3} />
                  ) : (
                    <Plus className="h-6 w-6" />
                  )}
                </button>
              }
            />

            <p className="px-1 text-xs text-muted-foreground">
              <span className="font-medium text-foreground">
                {suggestion.uses.length} produit
                {suggestion.uses.length > 1 ? "s" : ""} déjà là
              </span>{" "}
              — {suggestion.uses.join(", ")}
              {urgency && (
                <span className="text-amber-700 dark:text-amber-400">
                  {" "}
                  · {urgency}
                </span>
              )}
            </p>

            {suggestion.missing.length > 0 && (
              <p className="px-1 text-xs text-muted-foreground">
                À acheter&nbsp;: {suggestion.missing.join(", ")}
              </p>
            )}
          </li>
        );
      })}

      <li className="pt-2">
        <Link
          href="/"
          className="block rounded-xl border bg-card px-4 py-3 text-center text-sm font-medium text-primary"
        >
          Voir la semaine →
        </Link>
      </li>
    </ul>
  );
}
