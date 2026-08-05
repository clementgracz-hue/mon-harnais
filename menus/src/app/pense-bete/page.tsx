import type { Metadata } from "next";

import { PageHeader } from "@/components/page-header";
import { Wishlist } from "@/components/wishlist";
import { createClient } from "@/lib/supabase/server";

export const metadata: Metadata = { title: "Pense-bête" };
export const dynamic = "force-dynamic";

export default async function WishlistPage() {
  const supabase = await createClient();

  const [{ data: items }, { data: staples }, { data: auth }] = await Promise.all([
    supabase
      .from("shopping_wishlist")
      .select("*")
      .order("created_at", { ascending: false }),
    supabase
      .from("staple_products")
      .select("*")
      .order("is_frequent", { ascending: false })
      .order("name"),
    supabase.auth.getUser(),
  ]);

  return (
    <main className="pb-nav">
      <PageHeader
        title="Pense-bête"
        subtitle="Partagé en temps réel avec ta moitié"
      />
      <Wishlist
        initialItems={items ?? []}
        initialStaples={staples ?? []}
        author={auth.user?.email?.split("@")[0] ?? "Nous"}
      />
    </main>
  );
}
