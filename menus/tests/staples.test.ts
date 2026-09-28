import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { parseStapleList } from "@/lib/staples";

describe("parseStapleList", () => {
  it("lit une liste nue", () => {
    const { staples } = parseStapleList("Petits suisses\nLime\nJus de citron bio");

    assert.deepEqual(
      staples.map((s) => s.name),
      ["Petits suisses", "Lime", "Jus de citron bio"],
    );
  });

  it("devine le rayon de chaque produit", () => {
    const { staples } = parseStapleList("Petits suisses\nMouchoirs\nRiz de Camargue");

    assert.deepEqual(
      staples.map((s) => s.aisle),
      ["Crémerie", "Hygiène & Beauté", "Épicerie salée"],
    );
  });

  it("enlève puces, numéros et quantités", () => {
    const { staples } = parseStapleList(
      ["- Feta — 80 g", "* Beurre demi-sel", "1. Lait 500 ml", "• Kiwi jaune"].join("\n"),
    );

    assert.deepEqual(
      staples.map((s) => s.name),
      ["Feta", "Beurre demi-sel", "Lait", "Kiwi jaune"],
    );
  });

  it("saute les titres de section et les lignes vides", () => {
    const { staples } = parseStapleList(
      ["CRÉMERIE", "", "Beurre demi-sel", "Mes habitudes :", "Petits suisses"].join("\n"),
    );

    assert.deepEqual(
      staples.map((s) => s.name),
      ["Beurre demi-sel", "Petits suisses"],
    );
  });

  it("signale ce qui existe déjà plutôt que de le dupliquer", () => {
    const { staples, duplicates } = parseStapleList(
      "Beurre demi-sel\nPetits suisses",
      ["beurre demi-sel"],
    );

    assert.deepEqual(staples.map((s) => s.name), ["Petits suisses"]);
    assert.deepEqual(duplicates, ["Beurre demi-sel"]);
  });

  it("dédoublonne le collage lui-même", () => {
    const { staples, duplicates } = parseStapleList("Lime\nlime\nLime");

    assert.equal(staples.length, 1);
    assert.equal(duplicates.length, 2);
  });

  it("ne rend rien sur un texte vide", () => {
    assert.deepEqual(parseStapleList("   \n\n"), { staples: [], duplicates: [] });
  });
});
