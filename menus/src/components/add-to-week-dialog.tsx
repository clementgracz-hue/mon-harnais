"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { CalendarPlus, Leaf } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { getOrCreateMenu } from "@/lib/menu";
import { createClient } from "@/lib/supabase/client";
import { DAYS, type Day } from "@/lib/types/database";
import { getIsoWeek } from "@/lib/utils";

type Props = {
  recipeId: string;
  /** Pré-coche « 100% végétal » d'après les ingrédients de la recette. */
  defaultVeg?: boolean;
  /** Ingrédients d'origine animale détectés, affichés en justification. */
  blockers?: string[];
  trigger: React.ReactNode;
};

export function AddToWeekDialog({
  recipeId,
  defaultVeg = false,
  blockers = [],
  trigger,
}: Props) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [day, setDay] = useState<Day | null>(null);
  const [veg, setVeg] = useState(defaultVeg);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function onSubmit(event: React.FormEvent) {
    event.preventDefault();
    setPending(true);
    setError(null);

    try {
      const supabase = createClient();
      const { week, year } = getIsoWeek();
      const menu = await getOrCreateMenu(supabase, week, year);

      const { error } = await supabase.from("weekly_menu_recipes").insert({
        menu_id: menu.id,
        recipe_id: recipeId,
        day_assigned: day,
        is_kid_friendly_veg: veg,
      });

      if (error) throw error;

      setOpen(false);
      router.push("/");
      router.refresh();
    } catch (cause) {
      setError(
        cause instanceof Error ? cause.message : "Impossible d'ajouter la recette.",
      );
    } finally {
      setPending(false);
    }
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>{trigger}</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Ajouter à la semaine</DialogTitle>
          <DialogDescription>
            Choisis un jour (facultatif) et indique si le repas du soir convient à
            un enfant en bas âge.
          </DialogDescription>
        </DialogHeader>

        <form onSubmit={onSubmit} className="space-y-5">
          <div className="grid grid-cols-4 gap-2">
            {DAYS.map((value) => {
              const active = day === value;
              return (
                <button
                  key={value}
                  type="button"
                  onClick={() => setDay(active ? null : value)}
                  className={
                    active
                      ? "rounded-lg bg-primary px-2 py-2 text-xs font-medium capitalize text-primary-foreground"
                      : "rounded-lg border px-2 py-2 text-xs font-medium capitalize text-muted-foreground"
                  }
                >
                  {value.slice(0, 3)}
                </button>
              );
            })}
          </div>

          <div className="space-y-2 rounded-lg border p-3">
            <div className="flex items-center gap-3">
              <Checkbox
                id="veg"
                checked={veg}
                onCheckedChange={(checked) => setVeg(checked === true)}
              />
              <Label
                htmlFor="veg"
                className="flex items-center gap-1.5 text-foreground"
              >
                <Leaf className="h-4 w-4 text-emerald-600" aria-hidden />
                Repas 100% végétal
              </Label>
            </div>
            {blockers.length > 0 && (
              <p className="text-xs text-muted-foreground">
                Produits animaux détectés&nbsp;: {blockers.slice(0, 4).join(", ")}
                {blockers.length > 4 && "…"}
              </p>
            )}
          </div>

          {error && (
            <p role="alert" className="text-sm text-destructive">
              {error}
            </p>
          )}

          <DialogFooter>
            <Button type="submit" size="lg" disabled={pending}>
              <CalendarPlus className="h-5 w-5" aria-hidden />
              {pending ? "Ajout…" : "Ajouter au menu"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
