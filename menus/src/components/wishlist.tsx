"use client";

import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { Check, Plus, Trash2, Wifi, WifiOff } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { AISLE_EMOJI, guessAisle } from "@/lib/aisles";
import { createClient } from "@/lib/supabase/client";
import type { StapleProduct, WishlistItem } from "@/lib/types/database";
import { cn } from "@/lib/utils";

type Props = {
  initialItems: WishlistItem[];
  initialStaples: StapleProduct[];
  author: string;
};

export function Wishlist({ initialItems, initialStaples, author }: Props) {
  const supabase = useMemo(() => createClient(), []);
  const [items, setItems] = useState(initialItems);
  const [staples, setStaples] = useState(initialStaples);
  const [live, setLive] = useState(false);
  const [draft, setDraft] = useState("");
  const inputRef = useRef<HTMLInputElement>(null);

  const refresh = useCallback(async () => {
    const [{ data: wishlist }, { data: stapleRows }] = await Promise.all([
      supabase
        .from("shopping_wishlist")
        .select("*")
        .order("created_at", { ascending: false }),
      supabase.from("staple_products").select("*").order("name"),
    ]);
    if (wishlist) setItems(wishlist);
    if (stapleRows) setStaples(stapleRows);
  }, [supabase]);

  // Une seule souscription pour les deux tables : le pense-bête et les
  // récurrents doivent apparaître instantanément sur les deux téléphones.
  useEffect(() => {
    const channel = supabase
      .channel("pense-bete")
      .on(
        "postgres_changes",
        { event: "*", schema: "public", table: "shopping_wishlist" },
        () => void refresh(),
      )
      .on(
        "postgres_changes",
        { event: "*", schema: "public", table: "staple_products" },
        () => void refresh(),
      )
      .subscribe((status) => setLive(status === "SUBSCRIBED"));

    return () => {
      void supabase.removeChannel(channel);
    };
  }, [supabase, refresh]);

  async function addItem(event: React.FormEvent) {
    event.preventDefault();
    const name = draft.trim();
    if (!name) return;

    const optimistic: WishlistItem = {
      id: `temp-${Date.now()}`,
      item_name: name,
      quantity: null,
      unit: null,
      aisle_category: guessAisle(name),
      is_checked: false,
      added_by: author,
      created_at: new Date().toISOString(),
    };

    setItems((current) => [optimistic, ...current]);
    setDraft("");
    inputRef.current?.focus();

    const { data, error } = await supabase
      .from("shopping_wishlist")
      .insert({
        item_name: name,
        aisle_category: optimistic.aisle_category,
        added_by: author,
      })
      .select()
      .single();

    setItems((current) =>
      error
        ? current.filter((item) => item.id !== optimistic.id)
        : current.map((item) => (item.id === optimistic.id ? data! : item)),
    );
  }

  async function toggleItem(item: WishlistItem) {
    setItems((current) =>
      current.map((row) =>
        row.id === item.id ? { ...row, is_checked: !row.is_checked } : row,
      ),
    );
    await supabase
      .from("shopping_wishlist")
      .update({ is_checked: !item.is_checked })
      .eq("id", item.id);
  }

  async function removeItem(id: string) {
    setItems((current) => current.filter((row) => row.id !== id));
    await supabase.from("shopping_wishlist").delete().eq("id", id);
  }

  async function clearChecked() {
    setItems((current) => current.filter((row) => !row.is_checked));
    await supabase.from("shopping_wishlist").delete().eq("is_checked", true);
  }

  async function toggleStaple(staple: StapleProduct) {
    setStaples((current) =>
      current.map((row) =>
        row.id === staple.id ? { ...row, is_selected: !row.is_selected } : row,
      ),
    );
    await supabase
      .from("staple_products")
      .update({ is_selected: !staple.is_selected })
      .eq("id", staple.id);
  }

  async function addStaple() {
    const name = window.prompt("Nouveau produit récurrent ?")?.trim();
    if (!name) return;
    await supabase
      .from("staple_products")
      .insert({ name, category: guessAisle(name), is_frequent: true });
    await refresh();
  }

  const pending = items.filter((item) => !item.is_checked);
  const checked = items.filter((item) => item.is_checked);
  const selectedStaples = staples.filter((staple) => staple.is_selected).length;

  return (
    <div className="space-y-6 p-4">
      <form onSubmit={addItem} className="flex gap-2">
        <Input
          ref={inputRef}
          value={draft}
          onChange={(event) => setDraft(event.target.value)}
          placeholder="Ajouter un produit manquant…"
          aria-label="Ajouter un produit"
          enterKeyHint="done"
        />
        <Button type="submit" size="icon" aria-label="Ajouter" disabled={!draft.trim()}>
          <Plus className="h-5 w-5" />
        </Button>
      </form>

      <p className="flex items-center gap-1.5 text-xs text-muted-foreground">
        {live ? (
          <>
            <Wifi className="h-3.5 w-3.5 text-primary" aria-hidden />
            Synchronisé en direct
          </>
        ) : (
          <>
            <WifiOff className="h-3.5 w-3.5" aria-hidden />
            Hors ligne — les ajouts partiront à la reconnexion
          </>
        )}
      </p>

      <section className="space-y-2">
        <h2 className="text-sm font-semibold uppercase tracking-wide text-muted-foreground">
          Pense-bête ({pending.length})
        </h2>
        {pending.length === 0 ? (
          <p className="py-6 text-center text-sm text-muted-foreground">
            Rien à ajouter pour l&apos;instant. 🎉
          </p>
        ) : (
          <ul className="divide-y rounded-xl border">
            {pending.map((item) => (
              <ItemRow
                key={item.id}
                item={item}
                onToggle={() => toggleItem(item)}
                onRemove={() => removeItem(item.id)}
              />
            ))}
          </ul>
        )}
      </section>

      <section className="space-y-2">
        <div className="flex items-center justify-between">
          <h2 className="text-sm font-semibold uppercase tracking-wide text-muted-foreground">
            Fonds de roulement{selectedStaples > 0 && ` (${selectedStaples})`}
          </h2>
          <Button variant="ghost" size="sm" onClick={addStaple}>
            <Plus className="h-4 w-4" /> Ajouter
          </Button>
        </div>
        <p className="text-xs text-muted-foreground">
          Un clic suffit&nbsp;: les produits activés partent dans la liste de courses.
        </p>
        <div className="flex flex-wrap gap-2">
          {staples.map((staple) => (
            <button
              key={staple.id}
              type="button"
              onClick={() => toggleStaple(staple)}
              aria-pressed={staple.is_selected}
              className={cn(
                "inline-flex items-center gap-1.5 rounded-full border px-3 py-2 text-sm transition-colors",
                staple.is_selected
                  ? "border-primary bg-primary text-primary-foreground"
                  : "text-muted-foreground",
              )}
            >
              {staple.is_selected && <Check className="h-3.5 w-3.5" aria-hidden />}
              {staple.name}
            </button>
          ))}
        </div>
      </section>

      {checked.length > 0 && (
        <section className="space-y-2">
          <div className="flex items-center justify-between">
            <h2 className="text-sm font-semibold uppercase tracking-wide text-muted-foreground">
              Déjà pris ({checked.length})
            </h2>
            <Button variant="ghost" size="sm" onClick={clearChecked}>
              <Trash2 className="h-4 w-4" /> Vider
            </Button>
          </div>
          <ul className="divide-y rounded-xl border opacity-60">
            {checked.map((item) => (
              <ItemRow
                key={item.id}
                item={item}
                onToggle={() => toggleItem(item)}
                onRemove={() => removeItem(item.id)}
              />
            ))}
          </ul>
        </section>
      )}
    </div>
  );
}

function ItemRow({
  item,
  onToggle,
  onRemove,
}: {
  item: WishlistItem;
  onToggle: () => void;
  onRemove: () => void;
}) {
  return (
    <li className="flex items-center gap-3 px-3 py-3">
      <button
        type="button"
        onClick={onToggle}
        aria-pressed={item.is_checked}
        aria-label={item.is_checked ? "Décocher" : "Cocher"}
        className={cn(
          "flex h-6 w-6 shrink-0 items-center justify-center rounded-md border-2",
          item.is_checked
            ? "border-primary bg-primary text-primary-foreground"
            : "border-input",
        )}
      >
        {item.is_checked && <Check className="h-4 w-4" strokeWidth={3} />}
      </button>

      <div className="min-w-0 flex-1">
        <p className={cn("truncate", item.is_checked && "line-through")}>
          {item.item_name}
        </p>
        <p className="text-xs text-muted-foreground">
          {AISLE_EMOJI[item.aisle_category]} {item.aisle_category}
          {item.added_by && ` · ${item.added_by}`}
        </p>
      </div>

      <Button
        variant="ghost"
        size="icon"
        onClick={onRemove}
        aria-label={`Supprimer ${item.item_name}`}
      >
        <Trash2 className="h-4 w-4 text-muted-foreground" />
      </Button>
    </li>
  );
}
