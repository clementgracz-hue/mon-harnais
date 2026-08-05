const SRC = new URL("../src/", import.meta.url).href;

/** `@/lib/shopping` → `<projet>/src/lib/shopping.ts` */
export function resolve(specifier, context, nextResolve) {
  if (specifier.startsWith("@/")) {
    const target = specifier.slice(2);
    const url = new URL(
      target.endsWith(".ts") ? target : `${target}.ts`,
      SRC,
    ).href;
    return { url, shortCircuit: true, format: "module-typescript" };
  }
  return nextResolve(specifier, context);
}
