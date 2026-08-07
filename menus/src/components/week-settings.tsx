"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { Minus, Plus, Users, UtensilsCrossed } from "lucide-react";

import { createClient } from "@/lib/supabase/client";
import { getOrCreateMenu } from "@/lib/menu";

type Props = {
  week: number;
  year: number;
  targetRecipes: number;
  servings: number;
  /** Repas déjà au menu, pour la jauge. */
  planned: number;
};

/** Deux réglages qui pilotent la semaine : combien de repas, pour combien. */
export function WeekSettings({
  week,
  year,
  targetRecipes,
  servings,
  planned,
}: Props) {
  const router = useRouter();
  const [target, setTarget] = useState(targetRecipes);
  const [people, setPeople] = useState(servings);

  async function save(patch: { target_recipes?: number; servings?: number }) {
    const supabase = createClient();
    const menu = await getOrCreateMenu(supabase, week, year);
    await supabase.from("weekly_menu").update(patch).eq("id", menu.id);
    router.refresh();
  }

  return (
    <div className="space-y-4 rounded-xl border bg-card p-4">
      <Stepper
        icon={<UtensilsCrossed className="h-4 w-4" aria-hidden />}
        label="Repas cette semaine"
        value={target}
        min={1}
        max={14}
        suffix={`${planned} choisi${planned > 1 ? "s" : ""}`}
        onChange={(value) => {
          setTarget(value);
          void save({ target_recipes: value });
        }}
      />

      <div className="flex gap-1">
        {Array.from({ length: Math.max(target, planned) }).map((_, index) => (
          <span
            key={index}
            className={`h-1.5 flex-1 rounded-full ${
              index < planned ? "bg-primary" : "bg-muted"
            }`}
          />
        ))}
      </div>

      <Stepper
        icon={<Users className="h-4 w-4" aria-hidden />}
        label="Convives"
        value={people}
        min={1}
        max={12}
        suffix="quantités adaptées"
        onChange={(value) => {
          setPeople(value);
          void save({ servings: value });
        }}
      />
    </div>
  );
}

function Stepper({
  icon,
  label,
  value,
  min,
  max,
  suffix,
  onChange,
}: {
  icon: React.ReactNode;
  label: string;
  value: number;
  min: number;
  max: number;
  suffix: string;
  onChange: (value: number) => void;
}) {
  return (
    <div className="flex items-center gap-3">
      <div className="min-w-0 flex-1">
        <p className="flex items-center gap-1.5 text-sm font-medium">
          {icon}
          {label}
        </p>
        <p className="text-xs text-muted-foreground">{suffix}</p>
      </div>

      <div className="flex items-center gap-1">
        <button
          type="button"
          onClick={() => onChange(Math.max(min, value - 1))}
          disabled={value <= min}
          aria-label={`Diminuer : ${label}`}
          className="flex h-9 w-9 items-center justify-center rounded-full border disabled:opacity-40"
        >
          <Minus className="h-4 w-4" />
        </button>
        <span
          aria-live="polite"
          className="w-8 text-center text-lg font-bold tabular-nums"
        >
          {value}
        </span>
        <button
          type="button"
          onClick={() => onChange(Math.min(max, value + 1))}
          disabled={value >= max}
          aria-label={`Augmenter : ${label}`}
          className="flex h-9 w-9 items-center justify-center rounded-full border disabled:opacity-40"
        >
          <Plus className="h-4 w-4" />
        </button>
      </div>
    </div>
  );
}
