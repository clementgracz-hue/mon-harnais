import type { Metadata, Viewport } from "next";

import { BottomNav } from "@/components/bottom-nav";

import "./globals.css";

export const metadata: Metadata = {
  title: { default: "Menus & Courses", template: "%s · Menus & Courses" },
  description:
    "Nos repas de la semaine, nos recettes et la liste de courses prête pour le Leclerc Drive.",
  manifest: "/manifest.json",
  appleWebApp: {
    capable: true,
    statusBarStyle: "default",
    title: "Menus",
  },
  icons: {
    icon: "/icons/icon-192.png",
    apple: "/icons/apple-touch-icon.png",
  },
  formatDetection: { telephone: false },
};

export const viewport: Viewport = {
  themeColor: "#0d9268",
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  viewportFit: "cover",
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="fr">
      <body>
        <div className="mx-auto min-h-dvh w-full max-w-md">{children}</div>
        <BottomNav />
      </body>
    </html>
  );
}
