/**
 * Résout les imports `@/…` des modules de `src/` quand ils sont exécutés
 * directement par Node (`node --test`), en dehors du bundler Next.
 */
import { register } from "node:module";

register("./ts-alias-resolver.mjs", import.meta.url);
