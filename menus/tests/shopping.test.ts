import assert from "node:assert/strict";
import { describe, it } from "node:test";

import {
  consolidate,
  countItems,
  normalizeName,
  toDriveText,
  type RawItem,
} from "@/lib/shopping";

const recipeItem = (
  name: string,
  quantity: number | null,
  unit: string | null,
  aisle: RawItem["aisle"],
  from = "Recette",
): RawItem => ({ name, quantity, unit, aisle, source: "recette", from });

describe("normalizeName", () => {
  it("ignore la casse, les accents, les espaces et le pluriel", () => {
    assert.equal(normalizeName("  Crème   Fraîche "), normalizeName("creme fraiche"));
    assert.equal(normalizeName("Œufs"), normalizeName("œuf"));
    assert.equal(normalizeName("Tomates"), "tomate");
  });
});

describe("consolidate", () => {
  it("additionne les doublons dans une même dimension", () => {
    const sections = consolidate([
      recipeItem("Beurre", 200, "g", "Crémerie"),
      recipeItem("beurre", 100, "g", "Crémerie"),
      recipeItem("Beurres", 0.5, "kg", "Crémerie"),
    ]);

    assert.equal(sections.length, 1);
    assert.deepEqual(sections[0].items[0].amounts, ["800 g"]);
  });

  it("convertit les volumes et bascule vers l'unité lisible", () => {
    const sections = consolidate([
      recipeItem("Lait", 50, "cl", "Crémerie"),
      recipeItem("Lait", 1, "L", "Crémerie"),
    ]);

    assert.deepEqual(sections[0].items[0].amounts, ["1,5 L"]);
  });

  it("garde séparées deux unités non convertibles entre elles", () => {
    const sections = consolidate([
      recipeItem("Ail", 2, "gousse", "Fruits & Légumes"),
      recipeItem("Ail", 1, "pièce", "Fruits & Légumes"),
    ]);

    assert.deepEqual(sections[0].items[0].amounts, ["2 gousses", "1 pièce"]);
  });

  it("repasse en cuillères à soupe quand le total y correspond", () => {
    const sections = consolidate([
      recipeItem("Parmesan râpé", 2, "c. à s.", "Crémerie"),
      recipeItem("Parmesan râpé", 2, "c. à s.", "Crémerie"),
    ]);

    assert.deepEqual(sections[0].items[0].amounts, ["4 c. à s."]);
  });

  it("garde les cuillères à café quand la conversion tomberait juste", () => {
    const sections = consolidate([
      recipeItem("Huile d'olive", 2, "c. à c.", "Épicerie salée"),
      recipeItem("Huile d'olive", 2, "c. à s.", "Épicerie salée"),
    ]);

    assert.deepEqual(sections[0].items[0].amounts, ["8 c. à c."]);
  });

  it("ne confond pas une tranche avec une pièce", () => {
    const sections = consolidate([
      recipeItem("Jambon blanc", 2, "tranche", "Traiteur & Charcuterie"),
      recipeItem("Jambon blanc", 2, "tranches", "Traiteur & Charcuterie"),
    ]);

    assert.deepEqual(sections[0].items[0].amounts, ["4 tranches"]);
  });

  it("accorde les pincées au pluriel", () => {
    const sections = consolidate([
      recipeItem("Fromage râpé", 4, "pincée", "Crémerie"),
    ]);

    assert.deepEqual(sections[0].items[0].amounts, ["4 pincées"]);
  });

  it("conserve les articles sans quantité", () => {
    const sections = consolidate([
      recipeItem("Sel", null, null, "Épicerie salée"),
    ]);

    assert.deepEqual(sections[0].items[0].amounts, []);
    assert.equal(countItems(sections), 1);
  });

  it("range les rayons dans l'ordre de parcours du Drive", () => {
    const sections = consolidate([
      recipeItem("Croquettes chat", 1, "sachet", "Animalerie"),
      recipeItem("Carottes", 500, "g", "Fruits & Légumes"),
      recipeItem("Pâtes", 500, "g", "Épicerie salée"),
    ]);

    assert.deepEqual(
      sections.map((section) => section.aisle),
      ["Fruits & Légumes", "Épicerie salée", "Animalerie"],
    );
  });

  it("préfère un rayon explicite au rayon par défaut", () => {
    const sections = consolidate([
      recipeItem("Curry", 1, "c. à c.", "Autres"),
      recipeItem("Curry", 1, "c. à c.", "Épicerie salée"),
    ]);

    assert.equal(sections[0].aisle, "Épicerie salée");
    assert.deepEqual(sections[0].items[0].amounts, ["2 c. à c."]);
  });

  it("fusionne les trois origines sur une seule ligne", () => {
    const sections = consolidate([
      recipeItem("Lait", 20, "cl", "Crémerie", "Crêpes"),
      {
        name: "Lait",
        quantity: null,
        unit: null,
        aisle: "Crémerie",
        source: "récurrent",
      },
    ]);

    const line = sections[0].items[0];
    assert.deepEqual(line.sources.sort(), ["recette", "récurrent"]);
    assert.deepEqual(line.from, ["Crêpes"]);
  });
});

describe("toDriveText", () => {
  const sections = consolidate([
    recipeItem("Carottes", 500, "g", "Fruits & Légumes"),
    recipeItem("Beurre", 250, "g", "Crémerie"),
    recipeItem("Sel", null, null, "Épicerie salée"),
  ]);

  it("écrit un article par ligne, groupé par rayon", () => {
    const text = toDriveText(sections);
    assert.match(text, /FRUITS & LÉGUMES\n- Carottes — 500 g/);
    assert.match(text, /- Sel$/m);
  });

  it("omet les articles déjà saisis sur le Drive", () => {
    const skip = new Set([sections[0].items[0].key]);
    const text = toDriveText(sections, { skip });
    assert.doesNotMatch(text, /Carottes/);
    assert.match(text, /Beurre/);
  });

  it("peut sortir la liste sans les titres de rayon", () => {
    const text = toDriveText(sections, { withAisles: false });
    assert.doesNotMatch(text, /CRÉMERIE/);
    assert.match(text, /- Beurre — 250 g/);
  });
});
