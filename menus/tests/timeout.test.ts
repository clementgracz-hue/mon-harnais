import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { withTimeout } from "@/lib/timeout";

const never = new Promise<string>(() => {});
const soon = (value: string, ms: number) =>
  new Promise<string>((resolve) => setTimeout(() => resolve(value), ms));

describe("withTimeout", () => {
  it("rend la valeur quand elle arrive à temps", async () => {
    assert.equal(await withTimeout(soon("ok", 5), 200, "trop tard"), "ok");
  });

  it("rend le repli quand la promesse ne répond pas", async () => {
    assert.equal(await withTimeout(never, 20, "trop tard"), "trop tard");
  });

  it("n'attend pas la promesse d'origine pour rendre la main", async () => {
    const started = Date.now();
    await withTimeout(soon("ok", 10_000), 20, "trop tard");
    assert.ok(Date.now() - started < 500);
  });

  it("laisse remonter une erreur survenue avant le délai", async () => {
    await assert.rejects(
      () => withTimeout(Promise.reject(new Error("boum")), 200, "repli"),
      /boum/,
    );
  });
});
