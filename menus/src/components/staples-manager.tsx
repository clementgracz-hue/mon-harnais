"use client";

import { useState } from "react";
import { ClipboardPaste, Plus, Settings2, Star, Trash2 } from "lucide-react";

import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input, Select, Textarea } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AISLES, AISLE_EMOJI, aisleRank, guessAisle } from "@/lib/aisles";
import { createClient } from "@/lib/supabase/client";
import { parseStapleList } from "@/lib/staples";
import type { Aisle, StapleProduct } from "@/lib/types/database";
import { cn } from "@/lib/utils";

type Props = {
  staples: StapleProduct[];
  /** Rejoue la lecture après une modification. */
  onChanged: () => void | Promise<void>;
};

/**
 * Gestion du fonds de roulement : ajouter, ranger, mettre en avant, supprimer.
 * L'activation d'un produit pour la semaine se fait ailleurs, en un clic.
 */
export function StaplesManager({ staples, onChanged }: Props) {
  const [open, setOpen] = useState(false);
  const [name, setName] = useState("");
  const [aisle, setAisle] = useState<Aisle | null>(null);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [pasted, setPasted] = useState("");
  const [imported, setImported] = useState<string | null>(null);

  const effectiveAisle = aisle ?? guessAisle(name);

  async function add(event: React.FormEvent) {
    event.preventDefault();
    const trimmed = name.trim();
    if (!trimmed) return;

    setPending(true);
    setError(null);

    const supabase = createClient();
    const { error } = await supabase
      .from("staple_products")
      .insert({ name: trimmed, category: effectiveAisle, is_frequent: true });

    if (error) {
      setError(
        error.code === "23505"
          ? `« ${trimmed} » est déjà dans la liste.`
          : error.message,
      );
      setPending(false);
      return;
    }

    setName("");
    setAisle(null);
    setPending(false);
    await onChanged();
  }

  /**
   * Collage en masse : la liste que Cowork rapporte du Drive, ou n'importe
   * quelle liste recopiée. Les rayons sont devinés, les doublons écartés.
   */
  async function importList(event: React.FormEvent) {
    event.preventDefault();
    const { staples: parsed, duplicates } = parseStapleList(
      pasted,
      staples.map((staple) => staple.name),
    );

    if (parsed.length === 0) {
      setImported(null);
      setError(
        duplicates.length > 0
          ? "Tous ces produits sont déjà dans la liste."
          : "Rien de lisible dans ce collage.",
      );
      return;
    }

    setPending(true);
    setError(null);

    const supabase = createClient();
    const { error } = await supabase.from("staple_products").insert(
      parsed.map((staple) => ({
        name: staple.name,
        category: staple.aisle,
        is_frequent: true,
      })),
    );

    setPending(false);
    if (error) {
      setError(error.message);
      return;
    }

    setPasted("");
    setImported(
      `${parsed.length} produit${parsed.length > 1 ? "s" : ""} ajouté${parsed.length > 1 ? "s" : ""}` +
        (duplicates.length > 0
          ? ` · ${duplicates.length} déjà connu${duplicates.length > 1 ? "s" : ""}`
          : ""),
    );
    await onChanged();
  }

  async function remove(staple: StapleProduct) {
    const supabase = createClient();
    const { error } = await supabase
      .from("staple_products")
      .delete()
      .eq("id", staple.id);
    if (error) setError(error.message);
    await onChanged();
  }

  async function setAisleOf(staple: StapleProduct, category: Aisle) {
    const supabase = createClient();
    await supabase.from("staple_products").update({ category }).eq("id", staple.id);
    await onChanged();
  }

  async function toggleFrequent(staple: StapleProduct) {
    const supabase = createClient();
    await supabase
      .from("staple_products")
      .update({ is_frequent: !staple.is_frequent })
      .eq("id", staple.id);
    await onChanged();
  }

  const sorted = [...staples].sort(
    (a, b) =>
      aisleRank(a.category) - aisleRank(b.category) ||
      a.name.localeCompare(b.name, "fr"),
  );

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button variant="ghost" size="sm">
          <Settings2 className="h-4 w-4" aria-hidden />
          Gérer
        </Button>
      </DialogTrigger>

      <DialogContent>
        <DialogHeader>
          <DialogTitle>Produits récurrents</DialogTitle>
          <DialogDescription>
            Le catalogue des articles que vous rachetez régulièrement. L&apos;étoile
            les remonte en tête de liste ; le rayon décide de leur place dans la
            liste de courses.
          </DialogDescription>
        </DialogHeader>

        <form onSubmit={add} className="space-y-2 rounded-xl border p-3">
          <Label htmlFor="staple-name">Ajouter un produit</Label>
          <div className="flex gap-2">
            <Input
              id="staple-name"
              value={name}
              onChange={(event) => setName(event.target.value)}
              placeholder="Papier cuisson"
              className="flex-1"
            />
            <Button type="submit" size="icon" disabled={pending || !name.trim()}>
              <Plus className="h-5 w-5" aria-hidden />
              <span className="sr-only">Ajouter</span>
            </Button>
          </div>
          <Select
            aria-label="Rayon du nouveau produit"
            value={effectiveAisle}
            onChange={(event) => setAisle(event.target.value as Aisle)}
          >
            {AISLES.map((value) => (
              <option key={value} value={value}>
                {AISLE_EMOJI[value]} {value}
              </option>
            ))}
          </Select>
          <p className="text-xs text-muted-foreground">
            Rayon deviné d&apos;après le nom — modifiable.
          </p>
        </form>

        <form onSubmit={importList} className="mt-3 space-y-2 rounded-xl border p-3">
          <Label htmlFor="staple-paste">Coller une liste</Label>
          <Textarea
            id="staple-paste"
            rows={4}
            value={pasted}
            onChange={(event) => setPasted(event.target.value)}
            placeholder={"Petits suisses\nCompote pomme sans sucre bio\nJus de citron bio"}
          />
          <Button
            type="submit"
            variant="outline"
            className="w-full"
            disabled={pending || !pasted.trim()}
          >
            <ClipboardPaste className="h-4 w-4" aria-hidden />
            Ajouter la liste
          </Button>
          <p className="text-xs text-muted-foreground">
            Un produit par ligne. Puces, numéros et quantités sont ignorés, les
            rayons devinés, les doublons écartés.
          </p>
          {imported && (
            <p role="status" className="text-xs font-medium text-primary">
              {imported}
            </p>
          )}
        </form>

        {error && (
          <p role="alert" className="mt-3 text-sm text-destructive">
            {error}
          </p>
        )}

        <ul className="mt-4 divide-y rounded-xl border">
          {sorted.map((staple) => (
            <li key={staple.id} className="flex items-center gap-2 px-2 py-2">
              <button
                type="button"
                onClick={() => toggleFrequent(staple)}
                aria-pressed={staple.is_frequent}
                aria-label={
                  staple.is_frequent
                    ? `Ne plus mettre ${staple.name} en avant`
                    : `Mettre ${staple.name} en avant`
                }
                className="shrink-0 p-1"
              >
                <Star
                  className={cn(
                    "h-5 w-5",
                    staple.is_frequent
                      ? "fill-amber-400 text-amber-400"
                      : "text-muted-foreground/40",
                  )}
                />
              </button>

              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-medium">{staple.name}</p>
                <Select
                  aria-label={`Rayon de ${staple.name}`}
                  value={staple.category}
                  onChange={(event) =>
                    setAisleOf(staple, event.target.value as Aisle)
                  }
                  className="mt-1 h-8 border-none bg-transparent px-0 text-xs text-muted-foreground"
                >
                  {AISLES.map((value) => (
                    <option key={value} value={value}>
                      {AISLE_EMOJI[value]} {value}
                    </option>
                  ))}
                </Select>
              </div>

              <Button
                variant="ghost"
                size="icon"
                onClick={() => remove(staple)}
                aria-label={`Supprimer ${staple.name}`}
              >
                <Trash2 className="h-4 w-4 text-muted-foreground" />
              </Button>
            </li>
          ))}
        </ul>

        {sorted.length === 0 && (
          <p className="mt-4 text-center text-sm text-muted-foreground">
            Aucun produit récurrent pour l&apos;instant.
          </p>
        )}
      </DialogContent>
    </Dialog>
  );
}
