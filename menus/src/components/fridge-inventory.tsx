"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { Check, Refrigerator } from "lucide-react";

import { AISLE_EMOJI } from "@/lib/aisles";
import { byUrgency } from "@/lib/planning";
import { daysUntil, formatExpiry } from "@/lib/shelf-life";
import { createClient } from "@/lib/supabase/client";
import type { PantryItem } from "@/lib/types/database";
import { cn } from "@/lib/utils";

type Props = { items: PantryItem[] };

/**
 * Ce qu'il y a au frigo, le plus pressé en tête. Les produits sans date
 * ferment la marche : ils ne commandent rien, mais on veut les voir pour
 * savoir ce dont on dispose.
 */
export function FridgeInventory({ items }: Props) {
  const router = useRouter();
  const [rows, setRows] = useState(items);

  async function markUsed(item: PantryItem) {
    setRows((current) => current.filter((row) => row.id !== item.id));
    const supabase = createClient();
    await supabase.from("pantry_items").update({ is_used: true }).eq("id", item.id);
    router.refresh();
  }

  if (rows.length === 0) {
    return (
      <section className="rounded-xl border p-4 text-center">
        <Refrigerator className="mx-auto mb-2 h-6 w-6 text-muted-foreground" aria-hidden />
        <p className="text-sm text-muted-foreground">
          Frigo vide. Range une livraison pour suivre les dates.
        </p>
      </section>
    );
  }

  const ordered = byUrgency(
    rows,
    (item) => item.expires_on,
    (item) => item.name,
  );

  return (
    <section className="space-y-2">
      <h2 className="flex items-baseline justify-between px-0.5">
        <span className="font-semibold">Dans le frigo</span>
        <span className="text-xs text-muted-foreground">{rows.length} produits</span>
      </h2>

      <ul className="divide-y rounded-xl border">
        {ordered.map((item) => {
          const days = item.expires_on ? daysUntil(item.expires_on) : null;
          const urgent = days !== null && days <= 2;

          return (
            <li key={item.id} className="flex items-center gap-3 px-3 py-2.5">
              <span className="min-w-0 flex-1">
                <span className="block truncate text-sm">{item.name}</span>
                <span className="block truncate text-xs text-muted-foreground">
                  {AISLE_EMOJI[item.aisle_category]} {item.amount ?? item.aisle_category}
                </span>
              </span>

              <span
                className={cn(
                  "shrink-0 text-xs",
                  urgent
                    ? "font-semibold text-amber-700 dark:text-amber-400"
                    : "text-muted-foreground",
                )}
              >
                {item.expires_on ? formatExpiry(item.expires_on) : "sans date"}
              </span>

              <button
                type="button"
                onClick={() => markUsed(item)}
                aria-label={`Sortir ${item.name} du frigo`}
                className="shrink-0 rounded-full border p-1.5 text-muted-foreground"
              >
                <Check className="h-4 w-4" />
              </button>
            </li>
          );
        })}
      </ul>
    </section>
  );
}
