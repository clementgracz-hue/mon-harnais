"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

import { getOrCreateMenu } from "@/lib/menu";
import { createClient } from "@/lib/supabase/client";
import { getIsoWeek } from "@/lib/utils";

type Selectable = { id: string; veg?: boolean };

/**
 * Ajout et retrait d'une recette au menu de la semaine, en un geste.
 * Partagé par la liste des recettes et les suggestions du frigo : les deux
 * écrans doivent se comporter pareil et refléter la même sélection.
 */
export function useWeekSelection(selectedIds: string[]) {
  const router = useRouter();
  const [selected, setSelected] = useState(() => new Set(selectedIds));
  const [pending, setPending] = useState<string | null>(null);

  async function toggle(recipe: Selectable) {
    if (pending) return;
    setPending(recipe.id);

    const isSelected = selected.has(recipe.id);
    setSelected((current) => {
      const next = new Set(current);
      if (isSelected) next.delete(recipe.id);
      else next.add(recipe.id);
      return next;
    });

    try {
      const supabase = createClient();
      const { week, year } = getIsoWeek();
      const menu = await getOrCreateMenu(supabase, week, year);

      if (isSelected) {
        await supabase
          .from("weekly_menu_recipes")
          .delete()
          .eq("menu_id", menu.id)
          .eq("recipe_id", recipe.id);
      } else {
        await supabase.from("weekly_menu_recipes").insert({
          menu_id: menu.id,
          recipe_id: recipe.id,
          is_kid_friendly_veg: recipe.veg ?? false,
        });
      }
      router.refresh();
    } catch {
      // Échec réseau : on rend l'état d'origine plutôt que de mentir.
      setSelected((current) => {
        const next = new Set(current);
        if (isSelected) next.add(recipe.id);
        else next.delete(recipe.id);
        return next;
      });
    } finally {
      setPending(null);
    }
  }

  return { selected, pending, toggle };
}
