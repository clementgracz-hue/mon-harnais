"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

import { RecipeForm } from "@/components/recipe-form";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";

export function AddRecipeDialog({ trigger }: { trigger: React.ReactNode }) {
  const router = useRouter();
  const [open, setOpen] = useState(false);

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>{trigger}</DialogTrigger>

      <DialogContent>
        <DialogHeader>
          <DialogTitle>Nouvelle recette</DialogTitle>
          <DialogDescription>
            Le rayon de chaque ingrédient est deviné automatiquement — ajuste-le si
            besoin, c&apos;est lui qui range la liste de courses.
          </DialogDescription>
        </DialogHeader>

        {/* `key` : le formulaire repart vierge à chaque ouverture. */}
        <RecipeForm
          key={open ? "open" : "closed"}
          onSaved={(recipeId) => {
            setOpen(false);
            router.push(`/recettes/${recipeId}`);
            router.refresh();
          }}
        />
      </DialogContent>
    </Dialog>
  );
}
