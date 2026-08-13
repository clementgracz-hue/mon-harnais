import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { aisleRank, guessAisle } from "@/lib/aisles";
import { deriveVeg } from "@/lib/veg";
import { getIsoWeek } from "@/lib/utils";

describe("guessAisle", () => {
  it("classe les produits courants dans le bon rayon", () => {
    assert.equal(guessAisle("Courgettes"), "Fruits & Légumes");
    assert.equal(guessAisle("Escalopes de dinde"), "Boucherie & Volaille");
    assert.equal(guessAisle("Pavé de saumon"), "Poissonnerie");
    assert.equal(guessAisle("Litière chat"), "Animalerie");
    assert.equal(guessAisle("Couches taille 4"), "Bébé");
    assert.equal(guessAisle("Papier toilette"), "Entretien & Maison");
  });

  it("ignore les accents et la casse", () => {
    assert.equal(guessAisle("CRÈME FRAÎCHE"), "Crémerie");
    assert.equal(guessAisle("epinards"), "Fruits & Légumes");
  });

  it("ne matche que des mots entiers", () => {
    // « ail » est contenu dans « taille », « pâtes » dans « pâté ».
    assert.equal(guessAisle("Couches taille 4"), "Bébé");
    assert.equal(guessAisle("Pâtes complètes"), "Épicerie salée");
    assert.equal(guessAisle("Pâté de campagne"), "Traiteur & Charcuterie");
  });

  it("tolère le pluriel au milieu d'un libellé", () => {
    assert.equal(guessAisle("Petits pois"), "Fruits & Légumes");
    assert.equal(guessAisle("Haricots verts"), "Fruits & Légumes");
    assert.equal(guessAisle("Pommes de terre"), "Fruits & Légumes");
  });

  it("préfère le libellé composé au mot isolé", () => {
    assert.equal(guessAisle("Jus d'orange"), "Boissons");
    assert.equal(guessAisle("Orange"), "Fruits & Légumes");
    assert.equal(guessAisle("Lait de coco"), "Épicerie salée");
    assert.equal(guessAisle("Lait demi-écrémé"), "Crémerie");
  });

  it("range les épices avec les épices, pas avec le sucré", () => {
    assert.equal(guessAisle("Muscade"), "Épicerie salée");
    assert.equal(guessAisle("Cannelle"), "Épicerie salée");
    assert.equal(guessAisle("Herbes de Provence"), "Épicerie salée");
    // Les herbes fraîches restent au rayon frais.
    assert.equal(guessAisle("Menthe fraîche"), "Fruits & Légumes");
    assert.equal(guessAisle("Basilic (frais)"), "Fruits & Légumes");
  });

  it("préfère le libellé le plus précis à partir du même mot", () => {
    assert.equal(guessAisle("Sirop d'érable"), "Épicerie sucrée");
    assert.equal(guessAisle("Sirop de menthe"), "Boissons");
    assert.equal(guessAisle("Crème balsamique"), "Épicerie salée");
    assert.equal(guessAisle("Crème fraîche"), "Crémerie");
  });

  it("coupe au trait d'union à gauche seulement", () => {
    assert.equal(guessAisle("Beurre demi-sel"), "Crémerie");
    assert.equal(guessAisle("Sel fin"), "Épicerie salée");
    assert.equal(guessAisle("Céleri-rave"), "Fruits & Légumes");
  });

  it("range les produits du fond de roulement", () => {
    assert.equal(guessAisle("Mouchoirs en papier confort ultra soft"), "Hygiène & Beauté");
    assert.equal(guessAisle("Lime"), "Fruits & Légumes");
    // « lime » est aussi un outil : le rayon non alimentaire passe avant.
    assert.equal(guessAisle("Lime à ongles"), "Hygiène & Beauté");
    assert.equal(guessAisle("Skyr protéiné 0% MG"), "Crémerie");
    assert.equal(guessAisle("Lait bébé en poudre 3ème âge bio"), "Bébé");
    assert.equal(guessAisle("Petits suisses"), "Crémerie");
    assert.equal(guessAisle("Cappuccino soluble"), "Épicerie sucrée");
    // Le jus de citron est un condiment ; le jus d'orange, une boisson.
    assert.equal(guessAisle("Jus de citron bio"), "Épicerie salée");
    assert.equal(guessAisle("Jus d'orange avec pulpe"), "Boissons");
    // La compote l'emporte sur le fruit qui la compose.
    assert.equal(guessAisle("Compote pomme sans sucre bio"), "Épicerie sucrée");
  });

  it("retombe sur « Autres » quand rien ne correspond", () => {
    assert.equal(guessAisle("Truc inconnu"), "Autres");
  });
});

describe("aisleRank", () => {
  it("ordonne les rayons selon le parcours du Drive", () => {
    assert.ok(aisleRank("Fruits & Légumes") < aisleRank("Crémerie"));
    assert.ok(aisleRank("Crémerie") < aisleRank("Animalerie"));
    assert.ok(aisleRank("Animalerie") < aisleRank("Autres"));
  });
});

describe("deriveVeg", () => {
  const ingredient = (name: string, aisle_category: Parameters<typeof deriveVeg>[0][number]["aisle_category"]) =>
    ({ name, aisle_category }) as const;

  it("accepte un plat sans produit animal", () => {
    const verdict = deriveVeg([
      ingredient("Lentilles corail", "Épicerie salée"),
      ingredient("Lait de coco", "Épicerie salée"),
      ingredient("Oignon", "Fruits & Légumes"),
    ]);

    assert.equal(verdict.isVeg, true);
    assert.deepEqual(verdict.blockers, []);
  });

  it("repère les produits animaux par rayon", () => {
    const verdict = deriveVeg([
      ingredient("Riz", "Épicerie salée"),
      ingredient("Blanc de poulet", "Boucherie & Volaille"),
    ]);

    assert.equal(verdict.isVeg, false);
    assert.deepEqual(verdict.blockers, ["Blanc de poulet"]);
  });

  it("repère les produits animaux rangés dans un autre rayon", () => {
    const verdict = deriveVeg([
      ingredient("Thon en boîte", "Épicerie salée"),
      ingredient("Miel", "Épicerie sucrée"),
    ]);

    assert.equal(verdict.isVeg, false);
    assert.equal(verdict.blockers.length, 2);
  });

  it("ne bloque pas sur les alternatives végétales", () => {
    const verdict = deriveVeg([
      ingredient("Crème de soja", "Crémerie"),
      ingredient("Lait d'avoine", "Crémerie"),
    ]);

    assert.equal(verdict.isVeg, true);
  });
});

describe("getIsoWeek", () => {
  it("suit la norme ISO-8601 aux bascules d'année", () => {
    // 4 janvier : toujours en semaine 1.
    assert.deepEqual(getIsoWeek(new Date("2026-01-04T12:00:00Z")), {
      week: 1,
      year: 2026,
    });
    // 1er janvier 2027 (vendredi) appartient à la semaine 53 de 2026.
    assert.deepEqual(getIsoWeek(new Date("2027-01-01T12:00:00Z")), {
      week: 53,
      year: 2026,
    });
    assert.deepEqual(getIsoWeek(new Date("2026-08-05T12:00:00Z")), {
      week: 32,
      year: 2026,
    });
  });
});
