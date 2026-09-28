import assert from "node:assert/strict";
import { describe, it } from "node:test";

import {
  consolidate,
  countItems,
  normalizeName,
  preferenceNote,
  sameProduct,
  toCoworkBrief,
  toDriveText,
  PREFERENCES,
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

  it("place la consigne tout en haut", () => {
    const text = toDriveText(sections, { note: "Préférences : bio de préférence" });
    assert.equal(text.split("\n")[0], "Préférences : bio de préférence");
  });

  it("n'ajoute pas de ligne vide quand il n'y a pas de consigne", () => {
    assert.equal(toDriveText(sections, { note: "" }), toDriveText(sections));
    assert.equal(toDriveText(sections, { note: "   " }), toDriveText(sections));
  });
});

describe("formats de copie", () => {
  const sections = consolidate([
    recipeItem("Carottes", 500, "g", "Fruits & Légumes"),
    recipeItem("Beurre", 250, "g", "Crémerie"),
    recipeItem("Sel", null, null, "Épicerie salée"),
  ]);

  it("« noms seuls » ne sort que des libellés", () => {
    const text = toDriveText(sections, { format: "noms", note: "Préférences : bio" });

    assert.deepEqual(text.split("\n").sort(), ["Beurre", "Carottes", "Sel"]);
    // Ni tiret, ni quantité, ni rayon, ni consigne : le champ d'ajout en
    // masse ne cherche que le libellé.
    assert.doesNotMatch(text, /[-—]|500|LÉGUMES|Préférences/);
  });

  it("« noms seuls » ouvre les parenthèses, qu'une recherche ne digère pas", () => {
    const avecPrécision = consolidate([
      recipeItem("Bœuf (haché surgelé)", 250, "g", "Surgelés"),
      recipeItem("Salade (mélange)", 4, "poignée", "Fruits & Légumes"),
    ]);
    const text = toDriveText(avecPrécision, { format: "noms" });

    assert.deepEqual(text.split("\n").sort(), [
      "Bœuf haché surgelé",
      "Salade mélange",
    ]);
  });

  it("« noms seuls » respecte les articles déjà saisis", () => {
    const skip = new Set([sections[0].items[0].key]);
    const text = toDriveText(sections, { format: "noms", skip });

    assert.doesNotMatch(text, /Carottes/);
    assert.match(text, /Beurre/);
  });

  it("« assistant » ouvre par une consigne et garde les quantités", () => {
    const text = toDriveText(sections, {
      format: "assistant",
      note: "Préférences : bio de préférence",
    });
    const [first, ...rest] = text.split("\n");

    assert.equal(first, "Ajoute ces produits à mon panier (bio de préférence) :");
    assert.ok(rest.includes("Carottes — 500 g"));
    assert.ok(rest.includes("Sel"));
  });

  it("« assistant » se passe de préférences", () => {
    const text = toDriveText(sections, { format: "assistant" });
    assert.equal(text.split("\n")[0], "Ajoute ces produits à mon panier :");
  });

  it("« par rayon » reste le format par défaut", () => {
    assert.equal(toDriveText(sections), toDriveText(sections, { format: "rayons" }));
  });
});

describe("sameProduct", () => {
  it("reconnaît une référence plus précise", () => {
    assert.ok(sameProduct("Feta", "Feta AOP grecque"));
    assert.ok(sameProduct("Mouchoirs", "Mouchoirs en papier confort ultra soft"));
    assert.ok(sameProduct("Pavé de saumon", "Pavés de saumon frais"));
    assert.ok(sameProduct("Courgette", "Courgettes"));
  });

  it("refuse un produit dont le nom commence autrement", () => {
    // Les mots de « pommes de terre » sont bien tous là, et pourtant.
    assert.equal(
      sameProduct("Pommes de terre", "Chips pommes de terre au chèvre"),
      false,
    );
    assert.equal(sameProduct("Pâtes", "Patate douce"), false);
    assert.equal(sameProduct("Crème fraîche", "Crème liquide"), false);
  });

  it("refuse un libellé sans mot significatif", () => {
    assert.equal(sameProduct("", "Feta"), false);
    assert.equal(sameProduct("de la", "Feta"), false);
  });
});

describe("toCoworkBrief", () => {
  const sections = consolidate([
    recipeItem("Carottes", 500, "g", "Fruits & Légumes"),
    recipeItem("Beurre demi-sel", null, null, "Crémerie"),
  ]);

  const habits = ["Beurre demi-sel", "Skyr protéiné 0% MG", "Lime"];

  it("porte la liste, les quantités et le décompte", () => {
    const brief = toCoworkBrief(sections, { habits });

    assert.match(brief, /À acheter \(2 articles\) :/);
    assert.match(brief, /^Carottes — 500 g$/m);
  });

  it("ne propose que les habitués absents du panier", () => {
    const brief = toCoworkBrief(sections, { habits });
    const suggestions = brief
      .split("\n\n")
      .find((block) => block.startsWith("À me proposer"))!;

    // Le beurre est déjà à acheter : le proposer serait un doublon.
    assert.doesNotMatch(suggestions, /Beurre demi-sel/);
    assert.match(suggestions, /Skyr protéiné 0% MG/);
    assert.match(suggestions, /Lime/);
  });

  it("demande de faire valider les cas douteux et de ne pas commander", () => {
    const brief = toCoworkBrief(sections, { habits });

    assert.match(brief, /attends que je valide/);
    assert.match(brief, /Ne valide pas la commande/);
    assert.match(brief, /Préviens-moi dès que le panier est complet/);
    assert.match(brief, /ce que tu n'as pas trouvé/);
  });

  it("demande de relever les habitudes gardées par le Drive", () => {
    const brief = toCoworkBrief(sections, { habits });

    assert.match(brief, /« mes favoris »/);
    assert.match(brief, /propose\s*\n?\s*chacun avant de l'ajouter/);
    // Ramenée sous une forme que l'application sait ravaler.
    assert.match(brief, /un par ligne et sans\n\s*quantité/);
  });

  it("reprend les préférences pour le choix des produits", () => {
    const brief = toCoworkBrief(sections, {
      habits,
      note: "Préférences : bio de préférence",
    });

    assert.match(brief, /Mes préférences : bio de préférence\./);
  });

  it("dit quelle référence prendre quand la ligne est plus vague", () => {
    const brief = toCoworkBrief(consolidate([recipeItem("Feta", 80, "g", "Crémerie")]), {
      habits: ["Feta AOP grecque", "Petits suisses"],
    });
    const suggestions = brief
      .split("\n\n")
      .find((block) => block.startsWith("À me proposer"))!;

    assert.match(brief, /Feta → Feta AOP grecque/);
    // Le produit habituel n'est alors plus à proposer : il est déjà au panier.
    assert.doesNotMatch(suggestions, /Feta AOP grecque/);
    assert.match(suggestions, /Petits suisses/);
  });

  it("ne se paraphrase pas quand le libellé est déjà le bon", () => {
    const brief = toCoworkBrief(sections, { habits: ["Beurre demi-sel"] });
    assert.doesNotMatch(brief, /référence que j'achète/);
  });

  it("se passe d'habitudes", () => {
    const brief = toCoworkBrief(sections);

    assert.doesNotMatch(brief, /À me proposer/);
    assert.doesNotMatch(brief, /habituels/);
    assert.match(brief, /À acheter \(2 articles\) :/);
  });

  it("omet les articles déjà mis dans le panier", () => {
    const skip = new Set([sections[0].items[0].key]);
    const brief = toCoworkBrief(sections, { skip, habits });

    assert.doesNotMatch(brief, /^Carottes/m);
    assert.match(brief, /À acheter \(1 article\) :/);
  });
});

describe("preferenceNote", () => {
  it("ne dit rien quand rien n'est coché", () => {
    assert.equal(preferenceNote([]), "");
  });

  it("écrit la consigne dans l'ordre des cases", () => {
    assert.equal(
      preferenceNote(["économique", "bio"]),
      "Préférences : bio de préférence · premiers prix",
    );
  });

  it("accepte les trois à la fois", () => {
    assert.equal(
      preferenceNote(PREFERENCES),
      "Préférences : bio de préférence · marques connues · premiers prix",
    );
  });
});
