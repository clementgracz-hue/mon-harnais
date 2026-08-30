import { NextResponse, type NextRequest } from "next/server";
import { createServerClient } from "@supabase/ssr";

import { withTimeout } from "@/lib/timeout";
import type { Database } from "@/lib/types/database";

const PUBLIC_ROUTES = ["/login", "/auth"];

/**
 * Au-delà, c'est que Supabase ne répond pas — projet en veille sur l'offre
 * gratuite, incident, réseau. La middleware Vercel est tuée vers 25 s : sans
 * cette limite, toute l'application renvoie un 504 illisible au lieu d'un
 * message. On préfère rendre la main et le dire.
 */
const AUTH_TIMEOUT_MS = 5000;

const UNREACHABLE = Symbol("supabase-injoignable");

async function currentUser(
  supabase: ReturnType<typeof createServerClient<Database>>,
) {
  try {
    const result = await withTimeout(
      supabase.auth.getUser(),
      AUTH_TIMEOUT_MS,
      UNREACHABLE,
    );
    if (result === UNREACHABLE) return { user: null, reachable: false };
    return { user: result.data.user, reachable: true };
  } catch {
    // Erreur réseau : même traitement qu'un silence.
    return { user: null, reachable: false };
  }
}

/** Rafraîchit la session Supabase et protège les routes privées. */
export async function updateSession(request: NextRequest) {
  let response = NextResponse.next({ request });

  const supabase = createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value),
          );
          response = NextResponse.next({ request });
          cookiesToSet.forEach(({ name, value, options }) =>
            response.cookies.set(name, value, options),
          );
        },
      },
    },
  );

  const { user, reachable } = await currentUser(supabase);

  const isPublic = PUBLIC_ROUTES.some((route) =>
    request.nextUrl.pathname.startsWith(route),
  );
  const isApi = request.nextUrl.pathname.startsWith("/api/");

  if (!reachable && !isPublic) {
    if (isApi) {
      return NextResponse.json(
        { error: "Base de données injoignable." },
        { status: 503 },
      );
    }

    const url = request.nextUrl.clone();
    url.pathname = "/login";
    url.searchParams.set("indisponible", "1");
    return NextResponse.redirect(url);
  }

  if (!user && !isPublic) {
    // Une requête d'API attend du JSON : la rediriger vers la page de
    // connexion lui renvoie du HTML, que l'appelant ne sait pas lire.
    if (isApi) {
      return NextResponse.json({ error: "Non authentifié." }, { status: 401 });
    }

    const url = request.nextUrl.clone();
    url.pathname = "/login";
    url.searchParams.set("next", request.nextUrl.pathname);
    return NextResponse.redirect(url);
  }

  return response;
}
