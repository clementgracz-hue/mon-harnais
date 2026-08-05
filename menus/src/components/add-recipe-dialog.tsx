"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { Plus, Trash2 } from "lucide-react";

import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input, Select, Textarea } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AISLES, guessAisle } from "@/lib/aisles";
import { createClient } from "@/lib/supabase/client";
import type { Aisle } from "@/lib/types/database";

const SUGGESTED_TAGS = [
  "Express",
  "Végé Soir Enfant",
  "Saison",
  "Batch cooking",
  "Four",
  "Plat unique",
];

const UNITS = ["g", "kg", "ml", "cl", "L", "c. à c.", "c. à s.", "pièce", "gousse", "sachet", "boîte", ""];

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

export function AddRecipeDialog({ trigger }: { trigger: React.ReactNode }) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [imageUrl, setImageUrl] = useState("");
  const [prepTime, setPrepTime] = useState("");
  const [cookTime, setCookTime] = useState("");
  const [tags, setTags] = useState<string[]>([]);
  const [ingredients, setIngredients] = useState<IngredientDraft[]>([
    emptyIngredient(),
  ]);
  const [steps, setSteps] = useState<string[]>([""]);

  function reset() {
    setTitle("");
    setDescription("");
    setImageUrl("");
    setPrepTime("");
    setCookTime("");
    setTags([]);
    setIngredients([emptyIngredient()]);
    setSteps([""]);
    setError(null);
  }

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

    const { data: recipe, error: recipeError } = await supabase
      .from("recipes")
      .insert({
        title: title.trim(),
        description: description.trim() || null,
        image_url: imageUrl.trim() || null,
        prep_time: prepTime ? Number(prepTime) : null,
        cook_time: cookTime ? Number(cookTime) : null,
        tags,
      })
      .select()
      .single();

    if (recipeError || !recipe) {
      setError(recipeError?.message ?? "Impossible d'enregistrer la recette.");
      setPending(false);
      return;
    }

    const ingredientRows = ingredients
      .filter((item) => item.name.trim())
      .map((item, index) => ({
        recipe_id: recipe.id,
        name: item.name.trim(),
        quantity: item.quantity ? Number(item.quantity.replace(",", ".")) : null,
        unit: item.unit || null,
        aisle_category: item.aisleTouched ? item.aisle : guessAisle(item.name),
        position: index,
      }));

    const stepRows = steps
      .map((instruction) => instruction.trim())
      .filter(Boolean)
      .map((instruction, index) => ({
        recipe_id: recipe.id,
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
    setOpen(false);
    reset();
    router.push(`/recettes/${recipe.id}`);
    router.refresh();
  }

  return (
    <Dialog
      open={open}
      onOpenChange={(next) => {
        setOpen(next);
        if (!next) reset();
      }}
    >
      <DialogTrigger asChild>{trigger}</DialogTrigger>

      <DialogContent>
        <DialogHeader>
          <DialogTitle>Nouvelle recette</DialogTitle>
          <DialogDescription>
            Le rayon de chaque ingrédient est deviné automatiquement — ajuste-le si
            besoin, c&apos;est lui qui range la liste de courses.
          </DialogDescription>
        </DialogHeader>

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
            <Label htmlFor="image">Photo (URL)</Label>
            <Input
              id="image"
              type="url"
              value={imageUrl}
              onChange={(event) => setImageUrl(event.target.value)}
              placeholder="https://…"
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
                        active
                          ? current.filter((item) => item !== tag)
                          : [...current, tag],
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
                    value={
                      ingredient.aisleTouched
                        ? ingredient.aisle
                        : guessAisle(ingredient.name)
                    }
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
              onClick={() =>
                setIngredients((current) => [...current, emptyIngredient()])
              }
            >
              <Plus className="h-4 w-4" /> Ingrédient
            </Button>
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
                      current.map((item, i) =>
                        i === index ? event.target.value : item,
                      ),
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
                      current.length === 1
                        ? [""]
                        : current.filter((_, i) => i !== index),
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

          <DialogFooter>
            <Button type="submit" size="lg" disabled={pending || !title.trim()}>
              {pending ? "Enregistrement…" : "Enregistrer la recette"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
