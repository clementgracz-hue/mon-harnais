/**
 * Borne l'attente d'une promesse. Rend `fallback` si le délai passe, sans
 * attendre la promesse d'origine — elle continue dans le vide, ce qui est
 * exactement ce qu'on veut quand un service ne répond plus.
 *
 * Sert à la middleware : la fonction Vercel est tuée vers 25 s, et une base
 * en veille rendrait alors toute l'application illisible (504) plutôt que de
 * dire ce qui se passe.
 */
export async function withTimeout<T, F>(
  promise: Promise<T>,
  ms: number,
  fallback: F,
): Promise<T | F> {
  let timer: ReturnType<typeof setTimeout> | undefined;

  const expiry = new Promise<F>((resolve) => {
    timer = setTimeout(() => resolve(fallback), ms);
  });

  try {
    return await Promise.race([promise, expiry]);
  } finally {
    clearTimeout(timer);
  }
}
