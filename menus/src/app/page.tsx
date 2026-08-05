import Link from "next/link";
import { LogOut, ShoppingCart } from "lucide-react";

import { PageHeader } from "@/components/page-header";
import { WeekPlanner, type MenuEntry } from "@/components/week-planner";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/server";
import { displayName } from "@/lib/user";
import { getIsoWeek } from "@/lib/utils";

export const dynamic = "force-dynamic";

export default async function HomePage() {
  const supabase = await createClient();
  const { week, year } = getIsoWeek();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: menu } = await supabase
    .from("weekly_menu")
    .select("id")
    .eq("week_number", week)
    .eq("year", year)
    .maybeSingle();

  const { data: entries } = menu
    ? await supabase
        .from("weekly_menu_recipes")
        .select("*, recipes(*)")
        .eq("menu_id", menu.id)
        .order("created_at")
    : { data: [] };

  return (
    <main className="pb-nav">
      <PageHeader
        title={`Semaine ${week}`}
        subtitle={`Nos repas · connecté en ${displayName(user)}`}
        action={
          <form action="/auth/signout" method="post">
            <Button
              type="submit"
              variant="ghost"
              size="icon"
              aria-label="Se déconnecter"
            >
              <LogOut className="h-5 w-5 text-muted-foreground" />
            </Button>
          </form>
        }
      />

      <WeekPlanner entries={(entries ?? []) as MenuEntry[]} />

      <div className="px-4 pb-4">
        <Button asChild size="lg" className="w-full">
          <Link href="/courses">
            <ShoppingCart className="h-5 w-5" aria-hidden />
            Générer la liste de courses
          </Link>
        </Button>
      </div>
    </main>
  );
}
