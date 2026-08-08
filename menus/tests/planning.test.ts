import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { expiringSoon, suggestDays, urgencyOf } from "@/lib/planning";
import { scaleQuantity, shoppingQuantity } from "@/lib/servings";
import { daysUntil, formatExpiry, shelfLifeDays, suggestExpiry } from "@/lib/shelf-life";

// Lundi 3 août 2026, pour que les jours suggérés soient prévisibles.
const LUNDI = new Date("2026-08-03T10:00:00");

const pantry = [
  { id: "1", name: "Pavés de saumon frais", expires_on: "2026-08-05", is_used: false },
  { id: "2", name: "Courgettes", expires_on: "2026-08-08", is_used: false },
  { id: "3", name: "Lardons", expires_on: "2026-08-04", is_used: false },
  { id: "4", name: "Riz basmati", expires_on: "2027-01-01", is_used: false },
];

const recipes = [
  { id: "a", title: "Salade lentilles & saumon", ingredients: ["Pavés de saumon frais", "Lentilles cuites"] },
  { id: "b", title: "Nouilles sautées", ingredients: ["Courgette", "Tomates cerises"] },
  { id: "c", title: "Pâtes aux lardons", ingredients: ["Pâtes", "Lardons"] },
  { id: "d", title: "Riz cantonais", ingredients: ["Riz basmati"] },
];

describe("shelfLifeDays", () => {
  it("distingue les denrées fragiles des produits d'épicerie", () => {
    assert.equal(shelfLifeDays("Pavé de saumon", "Poissonnerie"), 2);
    assert.equal(shelfLifeDays("Blanc de poulet", "Boucherie & Volaille"), 3);
    assert.equal(shelfLifeDays("Riz basmati", "Épicerie salée"), 365);
    assert.equal(shelfLifeDays("Papier toilette", "Entretien & Maison"), 730);
  });

  it("préfère le mot-clé au rayon quand le produit tient plus longtemps", () => {
    // Les carottes tiennent bien plus que la moyenne du rayon.
    assert.ok(shelfLifeDays("Carottes", "Fruits & Légumes") > shelfLifeDays("Salade", "Fruits & Légumes"));
    assert.equal(shelfLifeDays("Œufs", "Crémerie"), 21);
  });

  it("propose une date au format attendu par un champ date", () => {
    assert.equal(suggestExpiry("Pavé de saumon", "Poissonnerie", LUNDI), "2026-08-05");
    assert.match(suggestExpiry("Riz", "Épicerie salée", LUNDI), /^\d{4}-\d{2}-\d{2}$/);
  });
});

describe("daysUntil / formatExpiry", () => {
  it("compte en jours entiers, sans décalage de fuseau", () => {
    assert.equal(daysUntil("2026-08-03", LUNDI), 0);
    assert.equal(daysUntil("2026-08-05", LUNDI), 2);
    assert.equal(daysUntil("2026-08-01", LUNDI), -2);
  });

  it("formule les échéances en français", () => {
    assert.equal(formatExpiry("2026-08-03", LUNDI), "à consommer aujourd'hui");
    assert.equal(formatExpiry("2026-08-04", LUNDI), "à consommer demain");
    assert.equal(formatExpiry("2026-08-07", LUNDI), "dans 4 jours");
    assert.equal(formatExpiry("2026-08-02", LUNDI), "périmé d'hier");
  });
});

describe("urgencyOf", () => {
  it("retient la DLC la plus proche parmi les ingrédients", () => {
    const urgency = urgencyOf(recipes, pantry);
    const salade = urgency.find((entry) => entry.recipeId === "a")!;

    assert.equal(salade.expiresOn, "2026-08-05");
    assert.equal(salade.because, "Pavés de saumon frais");
  });

  it("reconnaît un ingrédient malgré le singulier ou un qualificatif", () => {
    // « Courgette » de la recette ↔ « Courgettes » du frigo.
    const nouilles = urgencyOf(recipes, pantry).find((entry) => entry.recipeId === "b")!;
    assert.equal(nouilles.expiresOn, "2026-08-08");
  });

  it("laisse sans date une recette dont rien n'est au frigo", () => {
    const urgency = urgencyOf(
      [{ id: "z", title: "Omelette", ingredients: ["Œufs"] }],
      pantry,
    );
    assert.equal(urgency[0].expiresOn, null);
  });
});

describe("suggestDays", () => {
  it("place les repas les plus urgents en premier", () => {
    const plan = suggestDays(recipes, pantry, LUNDI);

    assert.deepEqual(
      plan.map((entry) => entry.title),
      [
        "Pâtes aux lardons", // DLC 04/08
        "Salade lentilles & saumon", // 05/08
        "Nouilles sautées", // 08/08
        "Riz cantonais", // 2027 : rien ne presse
      ],
    );
    assert.deepEqual(
      plan.map((entry) => entry.day),
      ["lundi", "mardi", "mercredi", "jeudi"],
    );
  });

  it("démarre au jour courant, pas au lundi", () => {
    const jeudi = new Date("2026-08-06T10:00:00");
    assert.equal(suggestDays(recipes, pantry, jeudi)[0].day, "jeudi");
  });

  it("ne déborde pas de la semaine", () => {
    const dimanche = new Date("2026-08-09T10:00:00");
    const plan = suggestDays(recipes, pantry, dimanche);
    assert.ok(plan.every((entry) => entry.day === "dimanche"));
  });
});

describe("expiringSoon", () => {
  it("alerte sur les produits à consommer sous 3 jours", () => {
    const alerts = expiringSoon(pantry, recipes, 3, LUNDI);

    assert.deepEqual(
      alerts.map((alert) => alert.item.name),
      ["Lardons", "Pavés de saumon frais"],
    );
    assert.equal(alerts[0].days, 1);
  });

  it("signale un produit qu'aucun repas prévu n'utilise", () => {
    const orphelin = [
      { id: "9", name: "Crème fraîche", expires_on: "2026-08-04", is_used: false },
    ];
    const [alert] = expiringSoon(orphelin, recipes, 3, LUNDI);

    assert.equal(alert.unplanned, true);
  });

  it("ignore ce qui est déjà consommé", () => {
    const used = [{ ...pantry[0], is_used: true }];
    assert.deepEqual(expiringSoon(used, recipes, 3, LUNDI), []);
  });
});

describe("shoppingQuantity", () => {
  const quiche = { servings: 6, is_batch: true };
  const plat = { servings: 2, is_batch: false };

  it("ne divise jamais un plat entier", () => {
    // Une quiche écrite pour 6 se fait en entier, même à deux.
    assert.equal(shoppingQuantity(3, "pièce", quiche, 2), 3);
    assert.equal(shoppingQuantity(400, "g", quiche, 2), 400);
    assert.equal(shoppingQuantity(400, "g", quiche, 8), 400);
  });

  it("met à l'échelle un plat portionnable", () => {
    assert.equal(shoppingQuantity(200, "g", plat, 4), 400);
    assert.equal(shoppingQuantity(200, "g", plat, 2), 200);
  });
});

describe("scaleQuantity", () => {
  it("met les quantités à l'échelle des convives", () => {
    assert.equal(scaleQuantity(200, "g", 2, 4), 400);
    assert.equal(scaleQuantity(120, "g", 2, 3), 180);
    assert.equal(scaleQuantity(40, "cl", 2, 1), 20);
  });

  it("arrondit les dénombrables au supérieur", () => {
    // 1 œuf pour 2 → 1,5 pour 3 → on en achète 2.
    assert.equal(scaleQuantity(1, "pièce", 2, 3), 2);
    assert.equal(scaleQuantity(2, "tranche", 2, 5), 5);
  });

  it("ne touche à rien quand le compte est identique ou la quantité absente", () => {
    assert.equal(scaleQuantity(200, "g", 2, 2), 200);
    assert.equal(scaleQuantity(null, "g", 2, 4), null);
  });
});
