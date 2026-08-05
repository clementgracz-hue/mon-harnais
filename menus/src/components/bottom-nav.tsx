"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import {
  BookOpen,
  CalendarDays,
  ShoppingCart,
  StickyNote,
  type LucideIcon,
} from "lucide-react";

import { createClient } from "@/lib/supabase/client";
import { cn } from "@/lib/utils";

type NavItem = {
  href: string;
  label: string;
  icon: LucideIcon;
  /** Affiche le nombre d'articles en attente dans le pense-bête. */
  badge?: "wishlist";
};

const ITEMS: NavItem[] = [
  { href: "/", label: "Semaine", icon: CalendarDays },
  { href: "/recettes", label: "Recettes", icon: BookOpen },
  { href: "/pense-bete", label: "Pense-bête", icon: StickyNote, badge: "wishlist" },
  { href: "/courses", label: "Courses", icon: ShoppingCart },
];

/** Nombre d'articles non cochés du pense-bête, synchronisé en temps réel. */
function useWishlistCount() {
  const [count, setCount] = useState<number | null>(null);

  useEffect(() => {
    const supabase = createClient();
    let cancelled = false;

    async function refresh() {
      const { count: value } = await supabase
        .from("shopping_wishlist")
        .select("*", { count: "exact", head: true })
        .eq("is_checked", false);
      if (!cancelled) setCount(value ?? 0);
    }

    void refresh();

    const channel = supabase
      .channel("nav-wishlist-count")
      .on(
        "postgres_changes",
        { event: "*", schema: "public", table: "shopping_wishlist" },
        () => void refresh(),
      )
      .subscribe();

    return () => {
      cancelled = true;
      void supabase.removeChannel(channel);
    };
  }, []);

  return count;
}

export function BottomNav() {
  const pathname = usePathname();
  const wishlistCount = useWishlistCount();

  // Le mode « En cuisine » et l'écran de connexion sont plein écran.
  if (pathname.endsWith("/cuisine") || pathname.startsWith("/login")) return null;

  return (
    <nav
      aria-label="Navigation principale"
      className="fixed inset-x-0 bottom-0 z-40 border-t border-border bg-background/95 pb-[env(safe-area-inset-bottom)] backdrop-blur supports-[backdrop-filter]:bg-background/80"
    >
      <ul className="mx-auto flex max-w-md items-stretch justify-around">
        {ITEMS.map(({ href, label, icon: Icon, badge }) => {
          const isActive =
            href === "/" ? pathname === "/" : pathname.startsWith(href);
          const count = badge === "wishlist" ? wishlistCount : null;

          return (
            <li key={href} className="flex-1">
              <Link
                href={href}
                aria-current={isActive ? "page" : undefined}
                className={cn(
                  "relative flex h-16 flex-col items-center justify-center gap-1 text-[11px] font-medium transition-colors",
                  isActive
                    ? "text-primary"
                    : "text-muted-foreground hover:text-foreground",
                )}
              >
                <span className="relative">
                  <Icon
                    className="h-6 w-6"
                    strokeWidth={isActive ? 2.4 : 1.8}
                    aria-hidden
                  />
                  {count != null && count > 0 && (
                    <span className="absolute -right-2 -top-1.5 flex h-4 min-w-4 items-center justify-center rounded-full bg-primary px-1 text-[10px] font-bold text-primary-foreground">
                      {count > 9 ? "9+" : count}
                    </span>
                  )}
                </span>
                {label}
                {isActive && (
                  <span
                    aria-hidden
                    className="absolute inset-x-6 top-0 h-0.5 rounded-full bg-primary"
                  />
                )}
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
