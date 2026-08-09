"use client";

import Link from "next/link";
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
  preferenceNote,
  toDriveText,
  PREFERENCES,
  PREFERENCE_LABELS,
  type Preference,
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

/** Les préférences valent pour toutes les semaines, pas seulement celle-ci. */
const PREFERENCES_KEY = "courses:preferences";

function ClosedNotice({ runId }: { runId: string }) {
  return (
    <div
      role="status"
      className="flex items-center justify-between gap-3 rounded-xl bg-primary/10 px-4 py-3 text-sm text-primary"
    >
      <span>Courses closes et archivées.</span>
      <Link
        href={`/courses/historique/${runId}`}
        className="shrink-0 font-semibold underline"
      >
        Revoir la liste
      </Link>
    </div>
  );
}

type Props = {
  items: RawItem[];
  /** Clé de persistance des cases cochées (numéro de semaine). */
  storageKey: string;
  week: number;
  year: number;
  closedBy: string;
};

export function ShoppingList({ items, storageKey, week, year, closedBy }: Props) {
  const router = useRouter();
  const [sources, setSources] = useState<Set<ShoppingSource>>(
    () => new Set(SOURCE_ORDER),
  );
  const [checked, setChecked] = useState<Set<string>>(new Set());
  const [preferences, setPreferences] = useState<Set<Preference>>(new Set());
  const [copied, setCopied] = useState(false);
  const [hydrated, setHydrated] = useState(false);
  const [closing, setClosing] = useState(false);
  const [closingOpen, setClosingOpen] = useState(false);
  const [closingError, setClosingError] = useState<string | null>(null);
  const [done, setDone] = useState<string | null>(null);

  // Les cases cochées survivent au rechargement : la saisie sur le Drive se
  // fait souvent en plusieurs fois.
  useEffect(() => {
    const stored = window.localStorage.getItem(storageKey);
    if (stored) setChecked(new Set(JSON.parse(stored) as string[]));

    const storedPreferences = window.localStorage.getItem(PREFERENCES_KEY);
    if (storedPreferences) {
      const saved = new Set(JSON.parse(storedPreferences) as string[]);
      setPreferences(new Set(PREFERENCES.filter((item) => saved.has(item))));
    }

    setHydrated(true);
  }, [storageKey]);

  useEffect(() => {
    if (hydrated) {
      window.localStorage.setItem(storageKey, JSON.stringify([...checked]));
    }
  }, [checked, hydrated, storageKey]);

  useEffect(() => {
    if (hydrated) {
      window.localStorage.setItem(PREFERENCES_KEY, JSON.stringify([...preferences]));
    }
  }, [hydrated, preferences]);

  const sections = useMemo(
    () => consolidate(items.filter((item) => sources.has(item.source))),
    [items, sources],
  );

  const total = countItems(sections);
  const remaining = total - checked.size;

  async function copyList() {
    const text = toDriveText(sections, {
      skip: checked,
      note: preferenceNote(preferences),
    });
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
   * Fin de courses : archive la liste et les repas, puis vide le panier
   * (pense-bête soldé, récurrents désactivés, repas de la semaine retirés).
   * Tout se joue dans une seule transaction côté base.
   */
  async function finishShopping() {
    setClosing(true);
    const supabase = createClient();

    // On archive la liste complète, sans le filtre d'affichage en cours.
    const archived = consolidate(items).flatMap((section) =>
      section.items.map((item) => ({
        name: item.name,
        amount: item.amounts.join(" + "),
        aisle: section.aisle,
        sources: item.sources,
      })),
    );

    const { data, error } = await supabase.rpc("close_shopping_run", {
      payload: { week, year, closed_by: closedBy, items: archived },
    });

    if (error) {
      setClosingError(error.message);
      setClosing(false);
      return;
    }

    setChecked(new Set());
    window.localStorage.removeItem(storageKey);
    setClosing(false);
    setClosingOpen(false);
    setDone(String(data));
    router.refresh();
  }

  // Les filtres restent visibles en toute circonstance : sans eux, décocher
  // les trois sources rendrait la liste irrécupérable.
  const filters = (
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
  );

  const note = preferenceNote(preferences);

  // Ce qu'on veut au rayon : la consigne part en tête du presse-papier.
  const preferenceBoxes = (
    <div className="rounded-xl border p-3">
      <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground">
        Préférences
      </p>
      <div className="flex flex-wrap gap-2">
        {PREFERENCES.map((preference) => {
          const active = preferences.has(preference);
          return (
            <button
              key={preference}
              type="button"
              role="checkbox"
              aria-checked={active}
              onClick={() =>
                setPreferences((current) => {
                  const next = new Set(current);
                  if (next.has(preference)) next.delete(preference);
                  else next.add(preference);
                  return next;
                })
              }
              className={cn(
                "flex items-center gap-2 rounded-lg border px-3 py-2 text-sm transition-colors",
                active ? "border-primary font-medium" : "text-muted-foreground",
              )}
            >
              <span
                className={cn(
                  "flex h-5 w-5 shrink-0 items-center justify-center rounded border-2",
                  active
                    ? "border-primary bg-primary text-primary-foreground"
                    : "border-input",
                )}
              >
                {active && <Check className="h-3.5 w-3.5" strokeWidth={3} />}
              </span>
              {PREFERENCE_LABELS[preference]}
            </button>
          );
        })}
      </div>
      <p className="mt-2 text-xs text-muted-foreground">
        {note
          ? `En tête du copier : « ${note} »`
          : "Rien en tête de la liste copiée."}
      </p>
    </div>
  );

  if (total === 0) {
    const everythingHidden = sources.size === 0 && items.length > 0;
    return (
      <div className="space-y-4 p-4">
        {/* Le panier vient d'être vidé : le lien vers l'archive doit rester. */}
        {done && <ClosedNotice runId={done} />}
        {filters}
        {preferenceBoxes}
        <p className="p-8 text-center text-sm text-muted-foreground">
          {everythingHidden
            ? "Aucune source sélectionnée : réactive un filtre ci-dessus."
            : "Rien à acheter : ajoute des recettes à la semaine ou des produits au pense-bête."}
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-4 p-4">
      {filters}
      {preferenceBoxes}

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

      {done && <ClosedNotice runId={done} />}

      <Dialog
        open={closingOpen}
        onOpenChange={(next) => {
          setClosingOpen(next);
          if (next) {
            setClosingError(null);
            setDone(null);
          }
        }}
      >
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
              La liste et les repas de la semaine sont archivés, puis le panier
              est vidé&nbsp;: pense-bête soldé, récurrents désactivés, repas de la
              semaine retirés. L&apos;archive reste consultable dans l&apos;historique.
            </DialogDescription>
          </DialogHeader>
          {closingError && (
            <p role="alert" className="text-sm text-destructive">
              {closingError}
            </p>
          )}

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
