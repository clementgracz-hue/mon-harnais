import type { Metadata } from "next";

import Link from "next/link";
import { History } from "lucide-react";

import { PageHeader } from "@/components/page-header";
import { Button } from "@/components/ui/button";
import { ShoppingList } from "@/components/shopping-list";
import { createClient } from "@/lib/supabase/server";
import type { RawItem } from "@/lib/shopping";
import type {
  Recipe,
  RecipeIngredient,
  StapleProduct,
  WishlistItem,
} from "@/lib/types/database";
import { scaleQuantity } from "@/lib/servings";
import { displayName } from "@/lib/user";
import { getIsoWeek } from "@/lib/utils";

export const metadata: Metadata = { title: "Courses" };
export const dynamic = "force-dynamic";

type MenuRow = {
  recipes:
    | (Pick<Recipe, "id" | "title" | "servings"> & {
        recipe_ingredients: RecipeIngredient[];
      })
    | null;
};

export default async function ShoppingPage() {
  const supabase = await createClient();
  const { week, year } = getIsoWeek();

  const { data: menu } = await supabase
    .from("weekly_menu")
    .select("id, servings")
    .eq("week_number", week)
    .eq("year", year)
    .maybeSingle();

  const [{ data: menuRows }, { data: wishlist }, { data: staples }] =
    await Promise.all([
      menu
        ? supabase
            .from("weekly_menu_recipes")
            .select("recipes(id, title, servings, recipe_ingredients(*))")
            .eq("menu_id", menu.id)
        : Promise.resolve({ data: [] as MenuRow[] }),
      supabase.from("shopping_wishlist").select("*").eq("is_checked", false),
      supabase.from("staple_products").select("*").eq("is_selected", true),
    ]);

  const {
    data: { user },
  } = await supabase.auth.getUser();

  const servings = menu?.servings ?? 2;

  // Agrégation : ingrédients des recettes + pense-bête + récurrents cochés.
  const items: RawItem[] = [
    ...((menuRows ?? []) as unknown as MenuRow[]).flatMap((row) =>
      (row.recipes?.recipe_ingredients ?? []).map((ingredient) => ({
        name: ingredient.name,
        // Recette écrite pour N parts, panier généré pour le nombre de convives.
        quantity: scaleQuantity(
          ingredient.quantity,
          ingredient.unit,
          row.recipes?.servings ?? 2,
          servings,
        ),
        unit: ingredient.unit,
        aisle: ingredient.aisle_category,
        source: "recette" as const,
        from: row.recipes?.title,
      })),
    ),
    ...((wishlist ?? []) as WishlistItem[]).map((item) => ({
      name: item.item_name,
      quantity: item.quantity,
      unit: item.unit,
      aisle: item.aisle_category,
      source: "pense-bête" as const,
    })),
    ...((staples ?? []) as StapleProduct[]).map((staple) => ({
      name: staple.name,
      quantity: null,
      unit: null,
      aisle: staple.category,
      source: "récurrent" as const,
    })),
  ];

  return (
    <main className="pb-nav">
      <PageHeader
        title="Liste de courses"
        subtitle={`Semaine ${week} · pour ${servings} personne${servings > 1 ? "s" : ""}`}
        action={
          <Button asChild variant="ghost" size="icon" aria-label="Historique des courses">
            <Link href="/courses/historique">
              <History className="h-5 w-5 text-muted-foreground" />
            </Link>
          </Button>
        }
      />
      <ShoppingList
        items={items}
        storageKey={`courses-${year}-${week}`}
        week={week}
        year={year}
        closedBy={displayName(user)}
      />
    </main>
  );
}
