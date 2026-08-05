"use client";

import Image from "next/image";
import { useRef, useState } from "react";
import { ImagePlus, Loader2, X } from "lucide-react";

import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/client";

const BUCKET = "recipe-photos";
const MAX_BYTES = 8 * 1024 * 1024;

type Props = {
  value: string | null;
  onChange: (url: string | null) => void;
};

/** Envoie la photo dans le bucket `recipe-photos` et renvoie son URL publique. */
export function ImageUpload({ value, onChange }: Props) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function onFile(event: React.ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0];
    event.target.value = ""; // permet de re-choisir le même fichier
    if (!file) return;

    if (file.size > MAX_BYTES) {
      setError("Photo trop lourde (8 Mo maximum).");
      return;
    }

    setPending(true);
    setError(null);

    const supabase = createClient();
    const extension = file.name.split(".").pop()?.toLowerCase() ?? "jpg";
    const path = `${crypto.randomUUID()}.${extension}`;

    const { error: uploadError } = await supabase.storage
      .from(BUCKET)
      .upload(path, file, { cacheControl: "31536000", upsert: false });

    if (uploadError) {
      setError(uploadError.message);
      setPending(false);
      return;
    }

    const {
      data: { publicUrl },
    } = supabase.storage.from(BUCKET).getPublicUrl(path);

    onChange(publicUrl);
    setPending(false);
  }

  return (
    <div className="space-y-2">
      {value ? (
        <div className="relative aspect-[16/10] overflow-hidden rounded-xl border bg-muted">
          <Image src={value} alt="" fill sizes="448px" className="object-cover" />
          <Button
            type="button"
            variant="secondary"
            size="icon"
            aria-label="Retirer la photo"
            onClick={() => onChange(null)}
            className="absolute right-2 top-2 h-9 w-9"
          >
            <X className="h-4 w-4" />
          </Button>
        </div>
      ) : (
        <button
          type="button"
          onClick={() => inputRef.current?.click()}
          disabled={pending}
          className="flex aspect-[16/10] w-full flex-col items-center justify-center gap-2 rounded-xl border border-dashed text-sm text-muted-foreground transition-colors hover:bg-accent disabled:opacity-60"
        >
          {pending ? (
            <>
              <Loader2 className="h-6 w-6 animate-spin" aria-hidden />
              Envoi…
            </>
          ) : (
            <>
              <ImagePlus className="h-6 w-6" aria-hidden />
              Ajouter une photo
            </>
          )}
        </button>
      )}

      <input
        ref={inputRef}
        type="file"
        accept="image/*"
        capture="environment"
        className="sr-only"
        onChange={onFile}
      />

      {error && (
        <p role="alert" className="text-sm text-destructive">
          {error}
        </p>
      )}
    </div>
  );
}
