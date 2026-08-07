"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { Minus, Plus, Users } from "lucide-react";

import { getOrCreateMenu } from "@/lib/menu";
import { createClient } from "@/lib/supabase/client";

type Props = {
  week: number;
  year: number;
  servings: number;
};

/** Convives à table : pilote la mise à l'échelle des quantités du panier. */
export function ServingsSetting({ week, year, servings }: Props) {
  const router = useRouter();
  const [people, setPeople] = useState(servings);

  async function save(value: number) {
    setPeople(value);
    const supabase = createClient();
    const menu = await getOrCreateMenu(supabase, week, year);
    await supabase.from("weekly_menu").update({ servings: value }).eq("id", menu.id);
    router.refresh();
  }

  return (
    <div className="flex items-center gap-3 rounded-xl border bg-card p-3">
      <div className="min-w-0 flex-1">
        <p className="flex items-center gap-1.5 text-sm font-medium">
          <Users className="h-4 w-4" aria-hidden />
          Convives
        </p>
        <p className="text-xs text-muted-foreground">
          Les quantités du panier sont adaptées
        </p>
      </div>

      <div className="flex items-center gap-1">
        <button
          type="button"
          onClick={() => save(Math.max(1, people - 1))}
          disabled={people <= 1}
          aria-label="Un convive de moins"
          className="flex h-9 w-9 items-center justify-center rounded-full border disabled:opacity-40"
        >
          <Minus className="h-4 w-4" />
        </button>
        <span
          aria-live="polite"
          className="w-8 text-center text-lg font-bold tabular-nums"
        >
          {people}
        </span>
        <button
          type="button"
          onClick={() => save(Math.min(12, people + 1))}
          disabled={people >= 12}
          aria-label="Un convive de plus"
          className="flex h-9 w-9 items-center justify-center rounded-full border disabled:opacity-40"
        >
          <Plus className="h-4 w-4" />
        </button>
      </div>
    </div>
  );
}
