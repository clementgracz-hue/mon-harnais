import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { suggestFromNames, suggestFromPantry } from "@/lib/suggest";

// Lundi 3 août 2026.
const LUNDI = new Date("2026-08-03T10:00:00");

const pantry = [
  { id: "1", name: "Pavés de saumon frais", expires_on: "2026-08-04", is_used: false },
  { id: "2", name: "Courgettes", expires_on: "2026-08-10", is_used: false },
  { id: "3", name: "Crème fraîche", expires_on: "2026-08-12", is_used: false },
  { id: "4", name: "Riz basmati", expires_on: "2027-01-01", is_used: false },
];

const recipes = [
  {
    id: "a",
    title: "Pâtes au saumon",
    ingredients: ["Pâtes", "Pavé de saumon", "Crème fraîche"],
  },
  {
    id: "b",
    title: "Risotto aux courgettes",
    ingredients: ["Riz basmati", "Courgette", "Parmesan", "Oignon"],
  },
  { id: "c", title: "Tarte aux pommes", ingredients: ["Pomme", "Pâte feuilletée"] },
];

describe("suggestFromPantry", () => {
  it("ne propose que des recettes qui utilisent le frigo", () => {
    const suggestions = suggestFromPantry(recipes, pantry, LUNDI);
    assert.deepEqual(
      suggestions.map((s) => s.recipe.id),
      ["a", "b"],
    );
  });

  it("fait passer devant ce qui périme le plus tôt", () => {
    // Le saumon périme demain : sa recette passe avant le risotto, qui
    // utilise pourtant deux produits du frigo lui aussi.
    const [first] = suggestFromPantry(recipes, pantry, LUNDI);
    assert.equal(first.recipe.id, "a");
    assert.equal(first.urgencyDays, 1);
  });

  it("dit ce qu'elle utilise et ce qu'il reste à acheter", () => {
    const [pates] = suggestFromPantry(recipes, pantry, LUNDI);

    assert.deepEqual(pates.uses.sort(), ["Crème fraîche", "Pavés de saumon frais"]);
    assert.deepEqual(pates.missing, ["Pâtes"]);
  });

  it("ignore ce qui a déjà été consommé", () => {
    const vidé = pantry.map((item) =>
      item.name === "Pavés de saumon frais" ? { ...item, is_used: true } : item,
    );
    const suggestions = suggestFromPantry(recipes, vidé, LUNDI);

    assert.equal(suggestions[0].recipe.id, "b");
    assert.deepEqual(
      suggestions.find((s) => s.recipe.id === "a")?.uses,
      ["Crème fraîche"],
    );
  });

  it("préfère la recette qui demande le moins de courses, à urgence égale", () => {
    const sansDates = pantry.map((item) => ({ ...item, expires_on: null }));
    const suggestions = suggestFromPantry(recipes, sansDates, LUNDI);

    // Deux produits utilisés chacune, mais « Pâtes au saumon » n'en manque
    // qu'un contre deux au risotto.
    assert.equal(suggestions[0].recipe.id, "a");
    assert.equal(suggestions[0].urgencyDays, null);
  });

  it("ne rend rien quand le frigo est vide", () => {
    assert.deepEqual(suggestFromPantry(recipes, [], LUNDI), []);
  });
});

describe("suggestFromNames", () => {
  it("classe les recettes à partir de simples noms de produits", () => {
    const suggestions = suggestFromNames(recipes, ["courgette", "riz"], LUNDI);

    assert.equal(suggestions.length, 1);
    assert.equal(suggestions[0].recipe.id, "b");
    assert.deepEqual(suggestions[0].missing, ["Parmesan", "Oignon"]);
  });

  it("ne rend rien sur une liste vide", () => {
    assert.deepEqual(suggestFromNames(recipes, [], LUNDI), []);
  });
});
