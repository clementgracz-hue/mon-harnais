"use client";

import { useState } from "react";
import { Leaf, Plus, Trash2 } from "lucide-react";

import { ImageUpload } from "@/components/image-upload";
import { Button } from "@/components/ui/button";
import { Input, Select, Textarea } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AISLES, guessAisle } from "@/lib/aisles";
import { createClient } from "@/lib/supabase/client";
import type { Aisle, RecipeWithDetails } from "@/lib/types/database";
import { deriveVeg } from "@/lib/veg";

const SUGGESTED_TAGS = [
  "Express",
  "Végé Soir Enfant",
  "Saison",
  "Batch cooking",
  "Four",
  "Plat unique",
];

const UNITS = [
  "g", "kg", "ml", "cl", "L", "c. à c.", "c. à s.",
  "pièce", "gousse", "sachet", "boîte", "",
];

type IngredientDraft = {
  name: string;
  quantity: string;
  unit: string;
  aisle: Aisle;
  /** Passe à true dès que le rayon est choisi à la main : plus d'écrasement. */
  aisleTouched: boolean;
};

const emptyIngredient = (): IngredientDraft => ({
  name: "",
  quantity: "",
  unit: "g",
  aisle: "Autres",
  aisleTouched: false,
});

/** Rayon effectif : celui choisi à la main, sinon celui deviné du nom. */
function effectiveAisle(ingredient: IngredientDraft) {
  return ingredient.aisleTouched ? ingredient.aisle : guessAisle(ingredient.name);
}

type Props = {
  /** Fournie en édition, absente en création. */
  recipe?: RecipeWithDetails;
  onSaved: (recipeId: string) => void;
  onCancel?: () => void;
};

export function RecipeForm({ recipe, onSaved, onCancel }: Props) {
  const isEdit = Boolean(recipe);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [title, setTitle] = useState(recipe?.title ?? "");
  const [description, setDescription] = useState(recipe?.description ?? "");
  const [imageUrl, setImageUrl] = useState<string | null>(recipe?.image_url ?? null);
  const [sourceUrl, setSourceUrl] = useState(recipe?.source_url ?? "");
  const [prepTime, setPrepTime] = useState(String(recipe?.prep_time ?? ""));
  const [cookTime, setCookTime] = useState(String(recipe?.cook_time ?? ""));
  const [tags, setTags] = useState<string[]>(recipe?.tags ?? []);

  const [ingredients, setIngredients] = useState<IngredientDraft[]>(() => {
    const rows = [...(recipe?.recipe_ingredients ?? [])].sort(
      (a, b) => a.position - b.position,
    );
    return rows.length
      ? rows.map((row) => ({
          name: row.name,
          quantity: row.quantity != null ? String(row.quantity) : "",
          unit: row.unit ?? "",
          aisle: row.aisle_category,
          aisleTouched: true,
        }))
      : [emptyIngredient()];
  });

  const [steps, setSteps] = useState<string[]>(() => {
    const rows = [...(recipe?.recipe_steps ?? [])].sort(
      (a, b) => a.step_number - b.step_number,
    );
    return rows.length ? rows.map((row) => row.instruction) : [""];
  });

  const verdict = deriveVeg(
    ingredients
      .filter((ingredient) => ingredient.name.trim())
      .map((ingredient) => ({
        name: ingredient.name,
        aisle_category: effectiveAisle(ingredient),
      })),
  );

  function updateIngredient(index: number, patch: Partial<IngredientDraft>) {
    setIngredients((current) =>
      current.map((item, i) => (i === index ? { ...item, ...patch } : item)),
    );
  }

  async function onSubmit(event: React.FormEvent) {
    event.preventDefault();
    setPending(true);
    setError(null);

    const supabase = createClient();
    const payload = {
      title: title.trim(),
      description: description.trim() || null,
      image_url: imageUrl,
      source_url: sourceUrl.trim() || null,
      prep_time: prepTime ? Number(prepTime) : null,
      cook_time: cookTime ? Number(cookTime) : null,
      tags,
    };

    const { data: saved, error: saveError } = isEdit
      ? await supabase
          .from("recipes")
          .update(payload)
          .eq("id", recipe!.id)
          .select()
          .single()
      : await supabase.from("recipes").insert(payload).select().single();

    if (saveError || !saved) {
      setError(saveError?.message ?? "Impossible d'enregistrer la recette.");
      setPending(false);
      return;
    }

    // En édition, on remplace ingrédients et étapes en bloc : plus simple et
    // plus sûr que de diffuser les ajouts, retraits et réordonnancements.
    if (isEdit) {
      await Promise.all([
        supabase.from("recipe_ingredients").delete().eq("recipe_id", saved.id),
        supabase.from("recipe_steps").delete().eq("recipe_id", saved.id),
      ]);
    }

    const ingredientRows = ingredients
      .filter((item) => item.name.trim())
      .map((item, index) => ({
        recipe_id: saved.id,
        name: item.name.trim(),
        quantity: item.quantity ? Number(item.quantity.replace(",", ".")) : null,
        unit: item.unit || null,
        aisle_category: effectiveAisle(item),
        position: index,
      }));

    const stepRows = steps
      .map((instruction) => instruction.trim())
      .filter(Boolean)
      .map((instruction, index) => ({
        recipe_id: saved.id,
        step_number: index + 1,
        instruction,
      }));

    const [{ error: ingredientsError }, { error: stepsError }] = await Promise.all([
      ingredientRows.length
        ? supabase.from("recipe_ingredients").insert(ingredientRows)
        : Promise.resolve({ error: null }),
      stepRows.length
        ? supabase.from("recipe_steps").insert(stepRows)
        : Promise.resolve({ error: null }),
    ]);

    if (ingredientsError || stepsError) {
      setError((ingredientsError ?? stepsError)!.message);
      setPending(false);
      return;
    }

    setPending(false);
    onSaved(saved.id);
  }

  return (
    <form onSubmit={onSubmit} className="space-y-5">
      <div className="space-y-1.5">
        <Label htmlFor="title">Titre</Label>
        <Input
          id="title"
          required
          value={title}
          onChange={(event) => setTitle(event.target.value)}
          placeholder="Dahl de lentilles corail"
        />
      </div>

      <div className="space-y-1.5">
        <Label>Photo</Label>
        <ImageUpload value={imageUrl} onChange={setImageUrl} />
      </div>

      <div className="grid grid-cols-2 gap-3">
        <div className="space-y-1.5">
          <Label htmlFor="prep">Préparation (min)</Label>
          <Input
            id="prep"
            type="number"
            inputMode="numeric"
            min={0}
            value={prepTime}
            onChange={(event) => setPrepTime(event.target.value)}
          />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="cook">Cuisson (min)</Label>
          <Input
            id="cook"
            type="number"
            inputMode="numeric"
            min={0}
            value={cookTime}
            onChange={(event) => setCookTime(event.target.value)}
          />
        </div>
      </div>

      <div className="space-y-1.5">
        <Label htmlFor="source">Lien de la recette (Jow, blog…)</Label>
        <Input
          id="source"
          type="url"
          inputMode="url"
          value={sourceUrl}
          onChange={(event) => setSourceUrl(event.target.value)}
          placeholder="https://jow.fr/recipes/…"
        />
      </div>

      <div className="space-y-1.5">
        <Label htmlFor="description">Description</Label>
        <Textarea
          id="description"
          value={description}
          onChange={(event) => setDescription(event.target.value)}
          placeholder="Le plat qui passe toujours, même le mercredi soir."
        />
      </div>

      <div className="space-y-2">
        <Label>Étiquettes</Label>
        <div className="flex flex-wrap gap-2">
          {SUGGESTED_TAGS.map((tag) => {
            const active = tags.includes(tag);
            return (
              <button
                key={tag}
                type="button"
                onClick={() =>
                  setTags((current) =>
                    active ? current.filter((item) => item !== tag) : [...current, tag],
                  )
                }
                className={
                  active
                    ? "rounded-full bg-primary px-3 py-1.5 text-xs font-medium text-primary-foreground"
                    : "rounded-full border px-3 py-1.5 text-xs font-medium text-muted-foreground"
                }
              >
                {tag}
              </button>
            );
          })}
        </div>
      </div>

      <div className="space-y-2">
        <Label>Ingrédients</Label>
        {ingredients.map((ingredient, index) => (
          <div key={index} className="rounded-lg border p-2">
            <div className="flex gap-2">
              <Input
                aria-label="Ingrédient"
                placeholder="Beurre"
                value={ingredient.name}
                onChange={(event) =>
                  updateIngredient(index, { name: event.target.value })
                }
                className="flex-1"
              />
              <Button
                type="button"
                variant="ghost"
                size="icon"
                aria-label="Supprimer l'ingrédient"
                onClick={() =>
                  setIngredients((current) =>
                    current.length === 1
                      ? [emptyIngredient()]
                      : current.filter((_, i) => i !== index),
                  )
                }
              >
                <Trash2 className="h-4 w-4 text-muted-foreground" />
              </Button>
            </div>
            <div className="mt-2 grid grid-cols-[1fr_1fr_1.4fr] gap-2">
              <Input
                aria-label="Quantité"
                inputMode="decimal"
                placeholder="200"
                value={ingredient.quantity}
                onChange={(event) =>
                  updateIngredient(index, { quantity: event.target.value })
                }
              />
              <Select
                aria-label="Unité"
                value={ingredient.unit}
                onChange={(event) =>
                  updateIngredient(index, { unit: event.target.value })
                }
              >
                {UNITS.map((unit) => (
                  <option key={unit} value={unit}>
                    {unit || "—"}
                  </option>
                ))}
              </Select>
              <Select
                aria-label="Rayon"
                value={effectiveAisle(ingredient)}
                onChange={(event) =>
                  updateIngredient(index, {
                    aisle: event.target.value as Aisle,
                    aisleTouched: true,
                  })
                }
              >
                {AISLES.map((aisle) => (
                  <option key={aisle} value={aisle}>
                    {aisle}
                  </option>
                ))}
              </Select>
            </div>
          </div>
        ))}
        <Button
          type="button"
          variant="outline"
          size="sm"
          onClick={() => setIngredients((current) => [...current, emptyIngredient()])}
        >
          <Plus className="h-4 w-4" /> Ingrédient
        </Button>

        {verdict.isVeg && (
          <p className="flex items-center gap-1.5 rounded-lg bg-emerald-100 px-3 py-2 text-xs text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300">
            <Leaf className="h-3.5 w-3.5" aria-hidden />
            Aucun produit animal détecté — repas proposé comme 100% végétal.
          </p>
        )}
      </div>

      <div className="space-y-2">
        <Label>Étapes</Label>
        {steps.map((step, index) => (
          <div key={index} className="flex gap-2">
            <span className="mt-3 w-5 shrink-0 text-sm font-semibold text-muted-foreground">
              {index + 1}.
            </span>
            <Textarea
              aria-label={`Étape ${index + 1}`}
              value={step}
              onChange={(event) =>
                setSteps((current) =>
                  current.map((item, i) => (i === index ? event.target.value : item)),
                )
              }
              className="min-h-[60px]"
            />
            <Button
              type="button"
              variant="ghost"
              size="icon"
              aria-label={`Supprimer l'étape ${index + 1}`}
              onClick={() =>
                setSteps((current) =>
                  current.length === 1 ? [""] : current.filter((_, i) => i !== index),
                )
              }
            >
              <Trash2 className="h-4 w-4 text-muted-foreground" />
            </Button>
          </div>
        ))}
        <Button
          type="button"
          variant="outline"
          size="sm"
          onClick={() => setSteps((current) => [...current, ""])}
        >
          <Plus className="h-4 w-4" /> Étape
        </Button>
      </div>

      {error && (
        <p role="alert" className="text-sm text-destructive">
          {error}
        </p>
      )}

      <div className="flex flex-col gap-2">
        <Button type="submit" size="lg" disabled={pending || !title.trim()}>
          {pending
            ? "Enregistrement…"
            : isEdit
              ? "Enregistrer les modifications"
              : "Enregistrer la recette"}
        </Button>
        {onCancel && (
          <Button type="button" variant="ghost" onClick={onCancel}>
            Annuler
          </Button>
        )}
      </div>
    </form>
  );
}
