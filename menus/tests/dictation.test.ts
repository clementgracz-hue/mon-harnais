import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { matchProduct, parseDictation } from "@/lib/dictation";

// Lundi 3 août 2026, pour que les dates relatives soient prévisibles.
const LUNDI = new Date("2026-08-03T10:00:00");

const dates = (phrase: string) =>
  parseDictation(phrase, LUNDI).corrections.map((c) => c.date);

const queries = (phrase: string) =>
  parseDictation(phrase, LUNDI).corrections.map((c) => c.query);

describe("parseDictation", () => {
  it("lit plusieurs corrections dans une seule phrase", () => {
    const result = parseDictation(
      "saumon vendredi, yaourts le 15, poulet dans trois jours",
      LUNDI,
    );

    assert.deepEqual(result.corrections, [
      { query: "saumon", date: "2026-08-07" },
      { query: "yaourts", date: "2026-08-15" },
      { query: "poulet", date: "2026-08-06" },
    ]);
    assert.deepEqual(result.unmatched, []);
  });

  it("se passe de ponctuation, comme la dictée du téléphone", () => {
    assert.deepEqual(
      parseDictation("le saumon demain les courgettes vendredi", LUNDI)
        .corrections,
      [
        { query: "saumon", date: "2026-08-04" },
        { query: "courgettes", date: "2026-08-07" },
      ],
    );
  });

  it("comprend aujourd'hui, demain et après-demain", () => {
    assert.deepEqual(dates("lait aujourd'hui"), ["2026-08-03"]);
    assert.deepEqual(dates("lait demain"), ["2026-08-04"]);
    assert.deepEqual(dates("lait après-demain"), ["2026-08-05"]);
  });

  it("compte les jours et les semaines, en chiffres comme en lettres", () => {
    assert.deepEqual(dates("riz dans 5 jours"), ["2026-08-08"]);
    assert.deepEqual(dates("riz dans cinq jours"), ["2026-08-08"]);
    assert.deepEqual(dates("riz dans une semaine"), ["2026-08-10"]);
    assert.deepEqual(dates("riz dans deux semaines"), ["2026-08-17"]);
  });

  it("prend la prochaine occurrence du jour nommé", () => {
    // Lundi : « mercredi » est dans deux jours.
    assert.deepEqual(dates("poulet mercredi"), ["2026-08-05"]);
    // « lundi » prononcé un lundi, c'est aujourd'hui…
    assert.deepEqual(dates("poulet lundi"), ["2026-08-03"]);
    // … sauf si on dit « prochain ».
    assert.deepEqual(dates("poulet lundi prochain"), ["2026-08-10"]);
  });

  it("accepte un quantième, avec ou sans mois", () => {
    assert.deepEqual(dates("yaourts le 15"), ["2026-08-15"]);
    // Le 1er est passé : ce sera celui de septembre.
    assert.deepEqual(dates("yaourts le 1er"), ["2026-09-01"]);
    assert.deepEqual(dates("yaourts le 12 septembre"), ["2026-09-12"]);
    assert.deepEqual(dates("yaourts 12 septembre"), ["2026-09-12"]);
  });

  it("accepte les dates écrites en chiffres", () => {
    assert.deepEqual(dates("crème 12/08"), ["2026-08-12"]);
    assert.deepEqual(dates("crème 12/08/2027"), ["2027-08-12"]);
  });

  it("laisse tomber les mots de liaison autour du produit", () => {
    assert.deepEqual(queries("et le saumon c'est vendredi"), ["saumon"]);
    assert.deepEqual(queries("les pavés de saumon expirent demain"), [
      "paves de saumon",
    ]);
  });

  it("signale ce qu'il n'a pas compris plutôt que de l'ignorer", () => {
    const result = parseDictation("saumon vendredi et puis le fromage", LUNDI);

    assert.deepEqual(result.corrections, [{ query: "saumon", date: "2026-08-07" }]);
    assert.deepEqual(result.unmatched, ["fromage"]);
  });

  it("ne rend rien sur une phrase vide", () => {
    assert.deepEqual(parseDictation("   ", LUNDI), {
      corrections: [],
      unmatched: [],
    });
  });
});

describe("matchProduct", () => {
  const names = [
    "Pavé de saumon frais",
    "Courgettes",
    "Yaourt nature",
    "Ravioles du Dauphiné",
    "Riz basmati",
  ];

  it("retrouve le produit sur un mot", () => {
    assert.equal(matchProduct("saumon", names), 0);
    assert.equal(matchProduct("courgette", names), 1);
    assert.equal(matchProduct("yaourts", names), 2);
  });

  it("ne confond pas deux produits qui partagent des lettres", () => {
    assert.equal(matchProduct("riz", names), 4);
  });

  it("accepte le libellé complet", () => {
    assert.equal(matchProduct("pavé de saumon frais", names), 0);
  });

  it("rend null quand rien ne correspond", () => {
    assert.equal(matchProduct("chocolat", names), null);
    assert.equal(matchProduct("", names), null);
  });
});
