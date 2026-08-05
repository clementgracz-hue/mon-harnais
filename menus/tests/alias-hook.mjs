/**
 * Résout les imports `@/…` des modules de `src/` quand ils sont exécutés
 * directement par Node (`node --test`), en dehors du bundler Next.
 */
import { register } from "node:module";

register("./alias-resolver.mjs", import.meta.url);
