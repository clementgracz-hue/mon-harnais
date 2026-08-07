import { notFound } from "next/navigation";

import { FridgeForm } from "@/components/fridge-form";
import { PageHeader } from "@/components/page-header";
import { createClient } from "@/lib/supabase/server";
import type { ShoppingRun, ShoppingRunItem } from "@/lib/types/database";

export const metadata = { title: "Ranger au frigo" };
export const dynamic = "force-dynamic";

type Row = ShoppingRun & { shopping_run_items: ShoppingRunItem[] };

export default async function StoragePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const supabase = await createClient();

  const [{ data }, { count }] = await Promise.all([
    supabase
      .from("shopping_runs")
      .select("*, shopping_run_items(*)")
      .eq("id", id)
      .maybeSingle(),
    supabase
      .from("pantry_items")
      .select("*", { count: "exact", head: true })
      .eq("run_id", id),
  ]);

  const run = data as Row | null;
  if (!run) notFound();

  return (
    <main className="pb-nav">
      <PageHeader
        title="Ranger au frigo"
        subtitle={`Semaine ${run.week_number} · ${run.shopping_run_items.length} articles`}
        backHref={`/courses/historique/${run.id}`}
      />

      <div className="space-y-4 p-4">
        <p className="text-sm text-muted-foreground">
          Les dates sont proposées d&apos;après la nature du produit — corrige-les
          avec celles imprimées sur les emballages. Les plus fragiles sont en
          tête. À l&apos;enregistrement, les repas de la semaine sont replacés dans
          l&apos;ordre de ces dates — modifiable ensuite jour par jour.
        </p>

        <FridgeForm
          runId={run.id}
          items={run.shopping_run_items}
          alreadyStored={count ?? 0}
        />
      </div>
    </main>
  );
}
