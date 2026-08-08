import assert from "node:assert/strict";
import { describe, it } from "node:test";

import {
  DAY_CAPACITY,
  WEEK_CAPACITY,
  hasRoom,
  placeMeals,
  slotsFrom,
} from "@/lib/schedule";
import type { Day } from "@/lib/types/database";

const meal = (id: string, day_assigned: Day | null) => ({ id, day_assigned });

describe("capacité de la semaine", () => {
  it("tient un repas par jour et deux le week-end", () => {
    assert.equal(DAY_CAPACITY.mercredi, 1);
    assert.equal(DAY_CAPACITY.samedi, 2);
    assert.equal(DAY_CAPACITY.dimanche, 2);
    assert.equal(WEEK_CAPACITY, 9);
  });
});

describe("slotsFrom", () => {
  it("part du jour courant et compte double le week-end", () => {
    // Vendredi 7 août 2026.
    assert.deepEqual(slotsFrom(new Date("2026-08-07T10:00:00")), [
      "vendredi",
      "samedi",
      "samedi",
      "dimanche",
      "dimanche",
    ]);
  });

  it("offre les neuf créneaux quand la semaine commence", () => {
    assert.equal(slotsFrom(new Date("2026-08-03T10:00:00")).length, 9);
  });
});

describe("placeMeals", () => {
  it("range les repas dans leur jour", () => {
    const { byDay, unplaced } = placeMeals([
      meal("a", "lundi"),
      meal("b", "samedi"),
      meal("c", "samedi"),
    ]);

    assert.deepEqual(byDay.get("lundi")?.map((m) => m.id), ["a"]);
    assert.deepEqual(byDay.get("samedi")?.map((m) => m.id), ["b", "c"]);
    assert.deepEqual(unplaced, []);
  });

  it("renvoie le surplus d'un jour saturé plutôt que de l'empiler", () => {
    const { byDay, unplaced } = placeMeals([
      meal("a", "mardi"),
      meal("b", "mardi"),
      meal("c", "samedi"),
      meal("d", "samedi"),
      meal("e", "samedi"),
    ]);

    assert.deepEqual(byDay.get("mardi")?.map((m) => m.id), ["a"]);
    assert.deepEqual(byDay.get("samedi")?.map((m) => m.id), ["c", "d"]);
    assert.deepEqual(unplaced.map((m) => m.id), ["b", "e"]);
  });

  it("laisse « à placer » les repas sans jour", () => {
    const { unplaced } = placeMeals([meal("a", null)]);
    assert.deepEqual(unplaced.map((m) => m.id), ["a"]);
  });
});

describe("hasRoom", () => {
  const meals = [meal("a", "lundi"), meal("b", "samedi")];

  it("refuse un jour de semaine déjà pris", () => {
    assert.equal(hasRoom(meals, "lundi"), false);
    assert.equal(hasRoom(meals, "mardi"), true);
  });

  it("garde une place le samedi tant qu'il n'y a qu'un repas", () => {
    assert.equal(hasRoom(meals, "samedi"), true);
    assert.equal(hasRoom([...meals, meal("c", "samedi")], "samedi"), false);
  });

  it("ne compte pas le repas que l'on déplace", () => {
    // Déplacer « a » sur lundi, là où il est déjà : la place existe.
    assert.equal(hasRoom(meals, "lundi", "a"), true);
  });
});
