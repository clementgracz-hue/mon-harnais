"use client";

import { useState } from "react";
import { ClipboardCheck, Copy } from "lucide-react";

import { Button } from "@/components/ui/button";
import { AISLE_EMOJI, aisleRank } from "@/lib/aisles";
import type { Aisle, ShoppingRunItem } from "@/lib/types/database";

/** Liste archivée : figée, avec le même export texte que la liste en cours. */
export function ArchivedList({ items }: { items: ShoppingRunItem[] }) {
  const [copied, setCopied] = useState(false);

  const sections = [
    ...items
      .reduce((map, item) => {
        const list = map.get(item.aisle_category) ?? [];
        list.push(item);
        map.set(item.aisle_category, list);
        return map;
      }, new Map<Aisle, ShoppingRunItem[]>())
      .entries(),
  ].sort(([a], [b]) => aisleRank(a) - aisleRank(b));

  async function copy() {
    const text = sections
      .map(
        ([aisle, list]) =>
          `${AISLE_EMOJI[aisle]} ${aisle.toUpperCase()}\n` +
          list
            .map((item) => (item.amount ? `- ${item.name} — ${item.amount}` : `- ${item.name}`))
            .join("\n"),
      )
      .join("\n\n");

    try {
      await navigator.clipboard.writeText(text);
    } catch {
      const textarea = document.createElement("textarea");
      textarea.value = text;
      textarea.style.position = "fixed";
      textarea.style.opacity = "0";
      document.body.appendChild(textarea);
      textarea.select();
      document.execCommand("copy");
      document.body.removeChild(textarea);
    }
    setCopied(true);
    window.setTimeout(() => setCopied(false), 2000);
  }

  return (
    <div className="space-y-4">
      <Button onClick={copy} variant="outline" className="w-full">
        {copied ? (
          <>
            <ClipboardCheck className="h-4 w-4" aria-hidden />
            Copié
          </>
        ) : (
          <>
            <Copy className="h-4 w-4" aria-hidden />
            Recopier cette liste
          </>
        )}
      </Button>

      {sections.map(([aisle, list]) => (
        <section key={aisle}>
          <h2 className="mb-1.5 text-xs font-semibold uppercase tracking-wide text-muted-foreground">
            {AISLE_EMOJI[aisle]} {aisle}
          </h2>
          <ul className="divide-y rounded-xl border">
            {list.map((item) => (
              <li
                key={item.id}
                className="flex items-center justify-between gap-3 px-3 py-2.5 text-sm"
              >
                <span className="min-w-0">
                  <span className="block truncate">{item.name}</span>
                  {item.sources.length > 0 && (
                    <span className="block truncate text-xs text-muted-foreground">
                      {item.sources.join(" · ")}
                    </span>
                  )}
                </span>
                {item.amount && (
                  <span className="shrink-0 font-medium">{item.amount}</span>
                )}
              </li>
            ))}
          </ul>
        </section>
      ))}
    </div>
  );
}
