"use client";

import { Star } from "lucide-react";

import { cn } from "@/lib/utils";

type Props = {
  value: number | null | undefined;
  onChange?: (value: number) => void;
  size?: "sm" | "md" | "lg";
  className?: string;
};

const SIZES = { sm: "h-3.5 w-3.5", md: "h-5 w-5", lg: "h-8 w-8" } as const;

export function StarRating({ value, onChange, size = "md", className }: Props) {
  const rating = value ?? 0;
  const readOnly = !onChange;

  return (
    <div className={cn("flex items-center gap-0.5", className)}>
      {[1, 2, 3, 4, 5].map((star) => {
        const filled = star <= Math.round(rating);
        const icon = (
          <Star
            className={cn(
              SIZES[size],
              filled ? "fill-amber-400 text-amber-400" : "text-muted-foreground/40",
            )}
          />
        );

        return readOnly ? (
          <span key={star}>{icon}</span>
        ) : (
          <button
            key={star}
            type="button"
            onClick={() => onChange(star)}
            aria-label={`Noter ${star} sur 5`}
            className="p-0.5 transition-transform active:scale-90"
          >
            {icon}
          </button>
        );
      })}
      {readOnly && rating > 0 && (
        <span className="ml-1 text-xs text-muted-foreground">
          {rating.toFixed(1).replace(".", ",")}
        </span>
      )}
    </div>
  );
}
