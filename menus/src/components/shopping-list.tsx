"use client";

import { useRouter } from "next/navigation";
import { useEffect, useMemo, useState } from "react";
import { Check, CheckCheck, ClipboardCheck, Copy, RotateCcw } from "lucide-react";

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
import { AISLE_EMOJI } from "@/lib/aisles";
import { createClient } from "@/lib/supabase/client";
import {
  consolidate,
  countItems,
  toDriveText,
  type RawItem,
  type ShoppingSource,
} from "@/lib/shopping";
import { cn } from "@/lib/utils";

const SOURCE_LABELS: Record<ShoppingSource, string> = {
  recette: "Recettes",
  "pense-bête": "Pense-bête",
  récurrent: "Récurrents",
};

const SOURCE_ORDER: ShoppingSource[] = ["recette", "pense-bête", "récurrent"];

type Props = {
  items: RawItem[];
  /** Clé de persistance des cases cochées (numéro de semaine). */
  storageKey: string;
};

export function ShoppingList({ items, storageKey }: Props) {
  const router = useRouter();
  const [sources, setSources] = useState<Set<ShoppingSource>>(
    () => new Set(SOURCE_ORDER),
  );
  const [checked, setChecked] = useState<Set<string>>(new Set());
  const [copied, setCopied] = useState(false);
  const [hydrated, setHydrated] = useState(false);
  const [closing, setClosing] = useState(false);

  // Les cases cochées survivent au rechargement : la saisie sur le Drive se
  // fait souvent en plusieurs fois.
  useEffect(() => {
    const stored = window.localStorage.getItem(storageKey);
    if (stored) setChecked(new Set(JSON.parse(stored) as string[]));
    setHydrated(true);
  }, [storageKey]);

  useEffect(() => {
    if (hydrated) {
      window.localStorage.setItem(storageKey, JSON.stringify([...checked]));
    }
  }, [checked, hydrated, storageKey]);

  const sections = useMemo(
    () => consolidate(items.filter((item) => sources.has(item.source))),
    [items, sources],
  );

  const total = countItems(sections);
  const remaining = total - checked.size;

  async function copyList() {
    const text = toDriveText(sections, { skip: checked });
    try {
      await navigator.clipboard.writeText(text);
    } catch {
      // Safari hors contexte sécurisé : repli sur un textarea temporaire.
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

  function toggle(key: string) {
    setChecked((current) => {
      const next = new Set(current);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  }

  /**
   * Fin de courses : le pense-bête est soldé et les récurrents redeviennent
   * inactifs, pour repartir d'une liste propre la semaine suivante.
   */
  async function finishShopping() {
    setClosing(true);
    const supabase = createClient();

    await Promise.all([
      supabase
        .from("shopping_wishlist")
        .update({ is_checked: true })
        .eq("is_checked", false),
      supabase
        .from("staple_products")
        .update({ is_selected: false })
        .eq("is_selected", true),
    ]);

    setChecked(new Set());
    window.localStorage.removeItem(storageKey);
    setClosing(false);
    router.refresh();
  }

  if (total === 0) {
    return (
      <p className="p-8 text-center text-sm text-muted-foreground">
        Rien à acheter&nbsp;: ajoute des recettes à la semaine ou des produits au
        pense-bête.
      </p>
    );
  }

  return (
    <div className="space-y-4 p-4">
      <div className="flex flex-wrap gap-2">
        {SOURCE_ORDER.map((source) => {
          const active = sources.has(source);
          return (
            <button
              key={source}
              type="button"
              onClick={() =>
                setSources((current) => {
                  const next = new Set(current);
                  if (next.has(source)) next.delete(source);
                  else next.add(source);
                  return next;
                })
              }
              aria-pressed={active}
              className={cn(
                "rounded-full border px-3 py-1.5 text-xs font-medium transition-colors",
                active
                  ? "border-primary bg-primary text-primary-foreground"
                  : "text-muted-foreground",
              )}
            >
              {SOURCE_LABELS[source]}
            </button>
          );
        })}
      </div>

      <div className="sticky top-[calc(3.75rem+env(safe-area-inset-top))] z-20 flex items-center gap-2 rounded-xl border bg-background/95 p-3 backdrop-blur">
        <div className="flex-1">
          <p className="text-sm font-medium">
            {remaining} article{remaining > 1 ? "s" : ""} à saisir
          </p>
          <p className="text-xs text-muted-foreground">
            {checked.size} déjà mis dans le Drive
          </p>
        </div>
        {checked.size > 0 && (
          <Button
            variant="ghost"
            size="icon"
            onClick={() => setChecked(new Set())}
            aria-label="Tout décocher"
          >
            <RotateCcw className="h-4 w-4" />
          </Button>
        )}
        <Button onClick={copyList}>
          {copied ? (
            <>
              <ClipboardCheck className="h-4 w-4" aria-hidden />
              Copié
            </>
          ) : (
            <>
              <Copy className="h-4 w-4" aria-hidden />
              Copier
            </>
          )}
        </Button>
      </div>

      {sections.map((section) => (
        <section key={section.aisle}>
          <h2 className="mb-1.5 text-xs font-semibold uppercase tracking-wide text-muted-foreground">
            {AISLE_EMOJI[section.aisle]} {section.aisle}
          </h2>
          <ul className="divide-y rounded-xl border">
            {section.items.map((item) => {
              const isChecked = checked.has(item.key);
              return (
                <li key={item.key}>
                  <button
                    type="button"
                    onClick={() => toggle(item.key)}
                    aria-pressed={isChecked}
                    className="flex w-full items-center gap-3 px-3 py-3 text-left"
                  >
                    <span
                      className={cn(
                        "flex h-6 w-6 shrink-0 items-center justify-center rounded-md border-2",
                        isChecked
                          ? "border-primary bg-primary text-primary-foreground"
                          : "border-input",
                      )}
                    >
                      {isChecked && <Check className="h-4 w-4" strokeWidth={3} />}
                    </span>

                    <span className="min-w-0 flex-1">
                      <span
                        className={cn(
                          "block truncate",
                          isChecked && "text-muted-foreground line-through",
                        )}
                      >
                        {item.name}
                      </span>
                      {item.from.length > 0 && (
                        <span className="block truncate text-xs text-muted-foreground">
                          {item.from.join(" · ")}
                        </span>
                      )}
                    </span>

                    {item.amounts.length > 0 && (
                      <span
                        className={cn(
                          "shrink-0 text-sm font-medium",
                          isChecked && "text-muted-foreground line-through",
                        )}
                      >
                        {item.amounts.join(" + ")}
                      </span>
                    )}
                  </button>
                </li>
              );
            })}
          </ul>
        </section>
      ))}

      <Dialog>
        <DialogTrigger asChild>
          <Button variant="outline" size="lg" className="w-full">
            <CheckCheck className="h-5 w-5" aria-hidden />
            Courses terminées
          </Button>
        </DialogTrigger>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Clore les courses ?</DialogTitle>
            <DialogDescription>
              Le pense-bête sera soldé et les produits récurrents désactivés, pour
              repartir d&apos;une liste vide. Les recettes de la semaine ne bougent
              pas.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button onClick={finishShopping} disabled={closing}>
              {closing ? "En cours…" : "Oui, tout solder"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
