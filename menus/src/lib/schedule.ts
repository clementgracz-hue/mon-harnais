import { DAYS, type Day } from "@/lib/types/database";

/**
 * Un repas par jour en semaine, deux le samedi et le dimanche — on cuisine
 * midi et soir quand on est à la maison. Neuf repas au total.
 */
export const DAY_CAPACITY: Record<Day, number> = {
  lundi: 1,
  mardi: 1,
  mercredi: 1,
  jeudi: 1,
  vendredi: 1,
  samedi: 2,
  dimanche: 2,
};

export const WEEK_CAPACITY = DAYS.reduce(
  (total, day) => total + DAY_CAPACITY[day],
  0,
);

export type Placeable = { id: string; day_assigned: Day | null };

/** Index du jour dans la semaine ISO : lundi = 0, dimanche = 6. */
export function dayIndex(date = new Date()) {
  return (date.getDay() + 6) % 7;
}

/**
 * Les créneaux encore devant nous, jour courant inclus, dans l'ordre : un
 * samedi vaut deux créneaux. Sert à répartir les repas à la sortie du Drive.
 */
export function slotsFrom(from = new Date()): Day[] {
  return DAYS.slice(dayIndex(from)).flatMap((day) =>
    Array.from({ length: DAY_CAPACITY[day] }, () => day),
  );
}

/**
 * Répartit les repas sur la semaine. Un jour déjà plein renvoie le surplus
 * dans `unplaced` plutôt que de l'empiler : la contrainte reste visible.
 */
export function placeMeals<T extends Placeable>(meals: T[]) {
  const byDay = new Map<Day, T[]>(DAYS.map((day) => [day, []]));
  const unplaced: T[] = [];

  for (const meal of meals) {
    const day = meal.day_assigned;
    const placed = day ? byDay.get(day) : undefined;

    if (day && placed && placed.length < DAY_CAPACITY[day]) placed.push(meal);
    else unplaced.push(meal);
  }

  return { byDay, unplaced };
}

/** Reste-t-il un créneau ce jour-là ? Le repas déplacé ne se compte pas. */
export function hasRoom(meals: Placeable[], day: Day, movingId?: string) {
  const taken = meals.filter(
    (meal) => meal.day_assigned === day && meal.id !== movingId,
  ).length;
  return taken < DAY_CAPACITY[day];
}
