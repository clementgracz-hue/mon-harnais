"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { Send } from "lucide-react";

import { StarRating } from "@/components/star-rating";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import type { RecipeComment } from "@/lib/types/database";

type Props = {
  recipeId: string;
  comments: RecipeComment[];
  /** Prénom affiché comme auteur (dérivé de l'email du compte connecté). */
  author: string;
};

export function RecipeComments({ recipeId, comments, author }: Props) {
  const router = useRouter();
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState("");
  const [pending, setPending] = useState(false);

  async function onSubmit(event: React.FormEvent) {
    event.preventDefault();
    if (!rating && !comment.trim()) return;

    setPending(true);
    const supabase = createClient();
    await supabase.from("recipe_comments").insert({
      recipe_id: recipeId,
      author,
      rating: rating || null,
      comment: comment.trim() || null,
    });

    setRating(0);
    setComment("");
    setPending(false);
    router.refresh();
  }

  return (
    <section className="space-y-4">
      <h2 className="text-lg font-semibold">Nos avis</h2>

      <form onSubmit={onSubmit} className="space-y-3 rounded-xl border p-3">
        <StarRating value={rating} onChange={setRating} size="lg" />
        <Textarea
          value={comment}
          onChange={(event) => setComment(event.target.value)}
          placeholder="Trop de piment pour le petit, moitié la prochaine fois…"
          aria-label="Commentaire"
        />
        <Button
          type="submit"
          size="sm"
          disabled={pending || (!rating && !comment.trim())}
        >
          <Send className="h-4 w-4" aria-hidden />
          Publier
        </Button>
      </form>

      {comments.length > 0 && (
        <ul className="space-y-3">
          {comments.map((item) => (
            <li key={item.id} className="rounded-xl border p-3">
              <div className="flex items-center justify-between gap-2">
                <span className="text-sm font-medium">{item.author}</span>
                <span className="text-xs text-muted-foreground">
                  {new Date(item.created_at).toLocaleDateString("fr-FR", {
                    day: "numeric",
                    month: "short",
                  })}
                </span>
              </div>
              {item.rating != null && (
                <StarRating value={item.rating} size="sm" className="mt-1" />
              )}
              {item.comment && <p className="mt-2 text-sm">{item.comment}</p>}
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}
