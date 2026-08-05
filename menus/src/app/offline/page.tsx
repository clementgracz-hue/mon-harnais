import { WifiOff } from "lucide-react";

export const metadata = { title: "Hors ligne" };

export default function OfflinePage() {
  return (
    <main className="flex min-h-dvh flex-col items-center justify-center gap-3 px-8 text-center">
      <WifiOff className="h-10 w-10 text-muted-foreground" aria-hidden />
      <h1 className="text-xl font-bold">Pas de réseau</h1>
      <p className="text-sm text-muted-foreground">
        Les pages déjà consultées restent disponibles hors ligne. Reviens sur celle-ci
        dès que la connexion revient.
      </p>
    </main>
  );
}
