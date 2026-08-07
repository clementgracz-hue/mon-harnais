import type { Metadata } from "next";
import Link from "next/link";
import { ChevronRight, ShoppingBasket } from "lucide-react";

import { PageHeader } from "@/components/page-header";
import { createClient } from "@/lib/supabase/server";
import type { ShoppingRun } from "@/lib/types/database";

export const metadata: Metadata = { title: "Historique des courses" };
export const dynamic = "force-dynamic";

type Row = ShoppingRun & { shopping_run_recipes: { id: string }[] };

export default async function HistoryPage() {
  const supabase = await createClient();
  const { data } = await supabase
    .from("shopping_runs")
    .select("*, shopping_run_recipes(id)")
    .order("created_at", { ascending: false });

  const runs = (data ?? []) as Row[];

  return (
    <main className="pb-nav">
      <PageHeader
        title="Historique"
        subtitle="Les listes déjà commandées"
        backHref="/courses"
      />

      {runs.length === 0 ? (
        <div className="p-8 text-center">
          <ShoppingBasket
            className="mx-auto mb-3 h-8 w-8 text-muted-foreground"
            aria-hidden
          />
          <p className="text-sm text-muted-foreground">
            Aucune liste archivée pour l&apos;instant. Elle le sera au premier
            « Courses terminées ».
          </p>
        </div>
      ) : (
        <ul className="divide-y">
          {runs.map((run) => (
            <li key={run.id}>
              <Link
                href={`/courses/historique/${run.id}`}
                className="flex items-center gap-3 px-4 py-4"
              >
                <div className="min-w-0 flex-1">
                  <p className="font-medium">
                    Semaine {run.week_number}{" "}
                    <span className="font-normal text-muted-foreground">
                      · {run.year}
                    </span>
                  </p>
                  <p className="mt-0.5 text-sm text-muted-foreground">
                    {run.item_count} article{run.item_count > 1 ? "s" : ""} ·{" "}
                    {run.shopping_run_recipes.length} repas ·{" "}
                    {new Date(run.created_at).toLocaleDateString("fr-FR", {
                      day: "numeric",
                      month: "long",
                    })}
                    {run.closed_by && ` · ${run.closed_by}`}
                  </p>
                </div>
                <ChevronRight
                  className="h-5 w-5 shrink-0 text-muted-foreground"
                  aria-hidden
                />
              </Link>
            </li>
          ))}
        </ul>
      )}
    </main>
  );
}
