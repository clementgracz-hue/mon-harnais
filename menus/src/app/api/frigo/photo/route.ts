import Anthropic from "@anthropic-ai/sdk";

import { createClient } from "@/lib/supabase/server";

/**
 * Lecture d'une photo de frigo : renvoie la liste des aliments visibles.
 *
 * L'IA ne fait que nommer ce qu'elle voit — le rapprochement avec les
 * recettes reste local et testable (`suggestFromNames`). La clé API ne quitte
 * jamais le serveur ; sans elle, la route se déclare indisponible et le bouton
 * photo disparaît de l'écran.
 */

const MEDIA_TYPES = ["image/jpeg", "image/png", "image/webp"] as const;

type MediaType = (typeof MEDIA_TYPES)[number];

/** 5 Mo : au-delà, c'est que la photo n'a pas été réduite côté navigateur. */
const MAX_BYTES = 5 * 1024 * 1024;

const SCHEMA = {
  type: "object",
  properties: {
    produits: {
      type: "array",
      description: "Aliments visibles, un par entrée, au singulier.",
      items: {
        type: "object",
        properties: {
          nom: {
            type: "string",
            description: "Nom courant en français, sans marque ni quantité.",
          },
          confiance: {
            type: "string",
            enum: ["sûr", "probable", "incertain"],
          },
        },
        required: ["nom", "confiance"],
        additionalProperties: false,
      },
    },
  },
  required: ["produits"],
  additionalProperties: false,
} as const;

const PROMPT = `Liste les aliments visibles sur cette photo de frigo ou de plan de travail.

Règles :
- un produit par entrée, en français courant et au singulier (« courgette », pas « des courgettes bio ») ;
- pas de marque, pas de quantité, pas de contenant (« yaourt », pas « pot de yaourt Danone ») ;
- ce qui est emballé et lisible compte ; ce que tu devines sans le voir, non ;
- marque « incertain » plutôt que d'inventer ;
- ignore la vaisselle, les bouteilles vides et le décor.`;

export async function POST(request: Request) {
  // Même porte que le reste de l'application : la session Supabase.
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return Response.json({ error: "Non authentifié." }, { status: 401 });
  }

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return Response.json(
      { error: "Lecture de photo non configurée sur ce déploiement." },
      { status: 501 },
    );
  }

  let body: { image?: unknown; mediaType?: unknown };
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: "Requête illisible." }, { status: 400 });
  }

  const image = typeof body.image === "string" ? body.image : "";
  const mediaType = String(body.mediaType ?? "image/jpeg") as MediaType;

  if (!image) {
    return Response.json({ error: "Aucune image reçue." }, { status: 400 });
  }
  if (!MEDIA_TYPES.includes(mediaType)) {
    return Response.json({ error: "Format d'image non accepté." }, { status: 400 });
  }
  // Le base64 pèse 4/3 de l'original : on compare sur la taille décodée.
  if (image.length * 0.75 > MAX_BYTES) {
    return Response.json({ error: "Photo trop lourde." }, { status: 413 });
  }

  const client = new Anthropic({ apiKey });

  try {
    const response = await client.messages.create({
      model: "claude-opus-5",
      max_tokens: 2000,
      output_config: { effort: "low", format: { type: "json_schema", schema: SCHEMA } },
      messages: [
        {
          role: "user",
          content: [
            { type: "image", source: { type: "base64", media_type: mediaType, data: image } },
            { type: "text", text: PROMPT },
          ],
        },
      ],
    });

    if (response.stop_reason === "refusal") {
      return Response.json({ error: "Photo non analysable." }, { status: 422 });
    }

    const text = response.content.find((block) => block.type === "text")?.text ?? "";
    const parsed = JSON.parse(text) as {
      produits: Array<{ nom: string; confiance: string }>;
    };

    return Response.json({
      items: parsed.produits
        .filter((item) => item.confiance !== "incertain")
        .map((item) => item.nom.trim())
        .filter(Boolean),
      uncertain: parsed.produits
        .filter((item) => item.confiance === "incertain")
        .map((item) => item.nom.trim())
        .filter(Boolean),
    });
  } catch (error) {
    const message =
      error instanceof Anthropic.APIError
        ? `Lecture impossible (${error.status}).`
        : "Lecture impossible.";
    return Response.json({ error: message }, { status: 502 });
  }
}
