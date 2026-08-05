"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { Trash2 } from "lucide-react";

import { RecipeForm } from "@/components/recipe-form";
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
import { createClient } from "@/lib/supabase/client";
import type { RecipeWithDetails } from "@/lib/types/database";

export function RecipeEditor({ recipe }: { recipe: RecipeWithDetails }) {
  const router = useRouter();
  const [deleting, setDeleting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function remove() {
    setDeleting(true);
    setError(null);

    const supabase = createClient();
    // Les ingrédients, étapes, commentaires et entrées de menu partent en
    // cascade (ON DELETE CASCADE côté schéma).
    const { error } = await supabase.from("recipes").delete().eq("id", recipe.id);

    if (error) {
      setError(error.message);
      setDeleting(false);
      return;
    }

    router.push("/recettes");
    router.refresh();
  }

  return (
    <div className="space-y-8 p-4">
      <RecipeForm
        recipe={recipe}
        onSaved={(recipeId) => {
          router.push(`/recettes/${recipeId}`);
          router.refresh();
        }}
        onCancel={() => router.back()}
      />

      <div className="border-t pt-6">
        <Dialog>
          <DialogTrigger asChild>
            <Button variant="ghost" className="w-full text-destructive">
              <Trash2 className="h-4 w-4" aria-hidden />
              Supprimer la recette
            </Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Supprimer « {recipe.title} » ?</DialogTitle>
              <DialogDescription>
                Les ingrédients, les étapes, les avis et les repas planifiés liés à
                cette recette seront supprimés. C&apos;est définitif.
              </DialogDescription>
            </DialogHeader>

            {error && (
              <p role="alert" className="text-sm text-destructive">
                {error}
              </p>
            )}

            <DialogFooter>
              <Button variant="destructive" onClick={remove} disabled={deleting}>
                {deleting ? "Suppression…" : "Supprimer définitivement"}
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>
    </div>
  );
}
