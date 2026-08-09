"use client";

import { useEffect, useRef, useState } from "react";
import { Mic, Square, Wand2 } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { matchProduct, parseDictation } from "@/lib/dictation";
import { formatExpiry } from "@/lib/shelf-life";
import { cn } from "@/lib/utils";

/** L'API de reconnaissance vocale, préfixée sur Safari. */
type Recognition = {
  lang: string;
  continuous: boolean;
  interimResults: boolean;
  start: () => void;
  stop: () => void;
  onresult: ((event: { results: ArrayLike<ArrayLike<{ transcript: string }>> }) => void) | null;
  onerror: (() => void) | null;
  onend: (() => void) | null;
};

type RecognitionWindow = Window & {
  SpeechRecognition?: new () => Recognition;
  webkitSpeechRecognition?: new () => Recognition;
};

function recognitionConstructor() {
  if (typeof window === "undefined") return undefined;
  const scope = window as RecognitionWindow;
  return scope.SpeechRecognition ?? scope.webkitSpeechRecognition;
}

function createRecognition(): Recognition | null {
  const Constructor = recognitionConstructor();
  if (!Constructor) return null;

  const recognition = new Constructor();
  recognition.lang = "fr-FR";
  recognition.continuous = true;
  recognition.interimResults = false;
  return recognition;
}

export type Applied = { name: string; date: string };

type Props = {
  /** Libellés de la livraison, dans l'ordre du formulaire. */
  names: string[];
  /** Reçoit les indices à redater. */
  onApply: (changes: Array<{ index: number; date: string }>) => void;
};

/**
 * Corriger les dates à la voix, en une phrase : « saumon vendredi, yaourts
 * le 15, poulet dans trois jours ». Les dates proposées sont déjà bonnes la
 * plupart du temps — ceci ne sert qu'à reprendre celles qui ne vont pas.
 *
 * Le champ texte reste le socle : le clavier du téléphone a son propre
 * micro, donc la dictée fonctionne même là où l'API vocale manque.
 */
export function DictationBar({ names, onApply }: Props) {
  const [phrase, setPhrase] = useState("");
  const [listening, setListening] = useState(false);
  const [applied, setApplied] = useState<Applied[] | null>(null);
  const [ignored, setIgnored] = useState<string[]>([]);
  // Décidé après l'hydratation : le serveur ne sait pas ce que sait le
  // navigateur, et un rendu différent des deux côtés casse React.
  const [supported, setSupported] = useState(false);
  const recognition = useRef<Recognition | null>(null);

  useEffect(() => setSupported(recognitionConstructor() !== undefined), []);

  function listen() {
    if (listening) {
      recognition.current?.stop();
      return;
    }

    const engine = createRecognition();
    if (!engine) return;

    recognition.current = engine;
    engine.onresult = (event) => {
      const heard = Array.from(event.results, (result) => result[0].transcript).join(
        " ",
      );
      setPhrase((current) => `${current} ${heard}`.trim());
    };
    engine.onerror = () => setListening(false);
    engine.onend = () => setListening(false);

    engine.start();
    setListening(true);
  }

  function apply() {
    const { corrections, unmatched } = parseDictation(phrase);
    const changes: Array<{ index: number; date: string }> = [];
    const done: Applied[] = [];
    const missed = [...unmatched];

    for (const correction of corrections) {
      const index = matchProduct(correction.query, names);
      if (index === null) {
        missed.push(correction.query);
        continue;
      }
      changes.push({ index, date: correction.date });
      done.push({ name: names[index], date: correction.date });
    }

    onApply(changes);
    setApplied(done);
    setIgnored(missed);
    if (changes.length > 0) setPhrase("");
  }

  return (
    <div className="space-y-2 rounded-xl border p-3">
      <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
        Corriger à la voix
      </p>

      <div className="flex gap-2">
        <Input
          value={phrase}
          onChange={(event) => setPhrase(event.target.value)}
          placeholder="saumon vendredi, yaourts le 15…"
          aria-label="Phrase de correction des dates"
          className="h-11 min-w-0 flex-1"
        />
        {supported && (
          <Button
            type="button"
            variant={listening ? "default" : "outline"}
            size="icon"
            onClick={listen}
            aria-label={listening ? "Arrêter la dictée" : "Dicter"}
            className={cn("h-11 w-11 shrink-0", listening && "animate-pulse")}
          >
            {listening ? <Square className="h-4 w-4" /> : <Mic className="h-5 w-5" />}
          </Button>
        )}
      </div>

      <Button
        type="button"
        onClick={apply}
        disabled={!phrase.trim()}
        className="h-11 w-full"
      >
        <Wand2 className="h-4 w-4" aria-hidden />
        Appliquer les dates dictées
      </Button>

      {applied && applied.length === 0 && ignored.length === 0 && (
        <p className="text-xs text-muted-foreground">Rien de reconnu dans cette phrase.</p>
      )}

      {applied && applied.length > 0 && (
        <p role="status" className="text-xs text-primary">
          {applied
            .map((change) => `${change.name} → ${formatExpiry(change.date)}`)
            .join(" · ")}
        </p>
      )}

      {ignored.length > 0 && (
        <p className="text-xs text-amber-700 dark:text-amber-400">
          Non reconnu : {ignored.join(", ")}
        </p>
      )}

      <p className="text-xs text-muted-foreground">
        « demain », « vendredi », « dans trois jours », « le 15 », « 12/08 ». Le
        micro du clavier marche aussi.
      </p>
    </div>
  );
}
