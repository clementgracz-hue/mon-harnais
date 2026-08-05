import Link from "next/link";
import { CookingPot } from "lucide-react";

import { Button } from "@/components/ui/button";

export default function NotFound() {
  return (
    <main className="flex min-h-dvh flex-col items-center justify-center gap-3 px-8 text-center">
      <CookingPot className="h-10 w-10 text-muted-foreground" aria-hidden />
      <h1 className="text-xl font-bold">Rien à cette adresse</h1>
      <p className="text-sm text-muted-foreground">
        La page ou la recette que tu cherches n&apos;existe pas (ou plus).
      </p>
      <Button asChild className="mt-2">
        <Link href="/">Retour à la semaine</Link>
      </Button>
    </main>
  );
}
