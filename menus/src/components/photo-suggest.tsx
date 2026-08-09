"use client";

import { useRef, useState } from "react";
import { Camera, Loader2, X } from "lucide-react";

import { FridgeSuggestions, type SuggestionCard } from "@/components/fridge-suggestions";
import type { RecipeCardData } from "@/components/recipe-card";
import { Button } from "@/components/ui/button";
import type { PlannedRecipe } from "@/lib/planning";
import { suggestFromNames } from "@/lib/suggest";

type Props = {
  recipes: PlannedRecipe[];
  cards: RecipeCardData[];
  selectedIds: string[];
  /** Faux quand la clé API n'est pas configurée : le bouton disparaît. */
  enabled: boolean;
};

/** Réduit la photo avant l'envoi : plus rapide, moins cher, aussi lisible. */
async function shrink(file: File, maxSide = 1024): Promise<{ data: string }> {
  const bitmap = await createImageBitmap(file);
  const scale = Math.min(1, maxSide / Math.max(bitmap.width, bitmap.height));

  const canvas = document.createElement("canvas");
  canvas.width = Math.round(bitmap.width * scale);
  canvas.height = Math.round(bitmap.height * scale);
  canvas.getContext("2d")?.drawImage(bitmap, 0, 0, canvas.width, canvas.height);
  bitmap.close();

  const dataUrl = canvas.toDataURL("image/jpeg", 0.8);
  return { data: dataUrl.slice(dataUrl.indexOf(",") + 1) };
}

/**
 * Photographier le frigo pour en tirer des idées de repas. La lecture de
 * l'image est faite par l'IA ; le rapprochement avec les recettes reste local,
 * avec le même classement que les suggestions issues du frigo rangé.
 */
export function PhotoSuggest({ recipes, cards, selectedIds, enabled }: Props) {
  const input = useRef<HTMLInputElement>(null);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [seen, setSeen] = useState<string[] | null>(null);
  const [unsure, setUnsure] = useState<string[]>([]);

  if (!enabled) return null;

  async function read(file: File) {
    setPending(true);
    setError(null);

    try {
      const { data } = await shrink(file);
      const response = await fetch("/api/frigo/photo", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ image: data, mediaType: "image/jpeg" }),
      });

      const payload = (await response.json()) as {
        items?: string[];
        uncertain?: string[];
        error?: string;
      };

      if (!response.ok) {
        setError(payload.error ?? "Lecture impossible.");
        return;
      }

      setSeen(payload.items ?? []);
      setUnsure(payload.uncertain ?? []);
    } catch {
      setError("Lecture impossible : vérifie ta connexion.");
    } finally {
      setPending(false);
    }
  }

  const byId = new Map(cards.map((card) => [card.id, card]));
  const suggestions: SuggestionCard[] = seen
    ? suggestFromNames(recipes, seen)
        .slice(0, 8)
        .flatMap((suggestion) => {
          const card = byId.get(suggestion.recipe.id);
          return card ? [{ ...suggestion, card }] : [];
        })
    : [];

  return (
    <div className="space-y-3 rounded-xl border p-3">
      <div className="flex items-center justify-between gap-3">
        <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
          Photo du frigo
        </p>
        {seen && (
          <button
            type="button"
            onClick={() => {
              setSeen(null);
              setUnsure([]);
            }}
            className="inline-flex items-center gap-1 text-xs text-muted-foreground"
          >
            <X className="h-3.5 w-3.5" aria-hidden />
            Effacer
          </button>
        )}
      </div>

      <input
        ref={input}
        type="file"
        accept="image/*"
        capture="environment"
        className="sr-only"
        aria-label="Photographier le frigo"
        onChange={(event) => {
          const file = event.target.files?.[0];
          event.target.value = "";
          if (file) void read(file);
        }}
      />

      <Button
        type="button"
        variant="outline"
        className="w-full"
        disabled={pending}
        onClick={() => input.current?.click()}
      >
        {pending ? (
          <>
            <Loader2 className="h-4 w-4 animate-spin" aria-hidden />
            Lecture de la photo…
          </>
        ) : (
          <>
            <Camera className="h-5 w-5" aria-hidden />
            {seen ? "Reprendre une photo" : "Photographier le frigo"}
          </>
        )}
      </Button>

      {error && (
        <p role="alert" className="text-xs text-destructive">
          {error}
        </p>
      )}

      {seen && (
        <div className="space-y-2">
          <p className="text-xs text-muted-foreground">
            {seen.length > 0
              ? `Reconnu : ${seen.join(", ")}`
              : "Aucun aliment reconnu sur cette photo."}
            {unsure.length > 0 && ` · à confirmer : ${unsure.join(", ")}`}
          </p>

          {suggestions.length > 0 ? (
            <FridgeSuggestions
              suggestions={suggestions}
              selectedIds={selectedIds}
              empty="Aucune recette ne reprend ces produits."
            />
          ) : (
            seen.length > 0 && (
              <p className="text-xs text-muted-foreground">
                Aucune de tes recettes ne reprend ces produits.
              </p>
            )
          )}
        </div>
      )}
    </div>
  );
}
