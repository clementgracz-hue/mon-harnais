/**
 * Types de la base Supabase.
 * Régénérables avec :
 *   npx supabase gen types typescript --project-id <ref> > src/lib/types/database.ts
 */

export const AISLES = [
  "Fruits & Légumes",
  "Boucherie & Volaille",
  "Poissonnerie",
  "Crémerie",
  "Traiteur & Charcuterie",
  "Surgelés",
  "Épicerie salée",
  "Épicerie sucrée",
  "Pain & Pâtisserie",
  "Boissons",
  "Bébé",
  "Hygiène & Beauté",
  "Entretien & Maison",
  "Animalerie",
  "Autres",
] as const;

export type Aisle = (typeof AISLES)[number];

export const DAYS = [
  "lundi",
  "mardi",
  "mercredi",
  "jeudi",
  "vendredi",
  "samedi",
  "dimanche",
] as const;

export type Day = (typeof DAYS)[number];

export type Recipe = {
  id: string;
  title: string;
  description: string | null;
  image_url: string | null;
  prep_time: number | null;
  cook_time: number | null;
  rating: number | null;
  tags: string[];
  created_at: string;
};

export type RecipeIngredient = {
  id: string;
  recipe_id: string;
  name: string;
  quantity: number | null;
  unit: string | null;
  aisle_category: Aisle;
  position: number;
};

export type RecipeStep = {
  id: string;
  recipe_id: string;
  step_number: number;
  instruction: string;
};

export type RecipeComment = {
  id: string;
  recipe_id: string;
  author: string;
  rating: number | null;
  comment: string | null;
  created_at: string;
};

export type StapleProduct = {
  id: string;
  name: string;
  category: Aisle;
  is_frequent: boolean;
  is_selected: boolean;
  created_at: string;
};

export type WishlistItem = {
  id: string;
  item_name: string;
  quantity: number | null;
  unit: string | null;
  aisle_category: Aisle;
  is_checked: boolean;
  added_by: string | null;
  created_at: string;
};

export type WeeklyMenu = {
  id: string;
  week_number: number;
  year: number;
  created_at: string;
};

export type WeeklyMenuRecipe = {
  id: string;
  menu_id: string;
  recipe_id: string;
  day_assigned: Day | null;
  is_kid_friendly_veg: boolean;
  created_at: string;
};

export type RecipeWithDetails = Recipe & {
  recipe_ingredients: RecipeIngredient[];
  recipe_steps: RecipeStep[];
  recipe_comments?: RecipeComment[];
};

type Relationship = {
  foreignKeyName: string;
  columns: string[];
  isOneToOne: boolean;
  referencedRelation: string;
  referencedColumns: string[];
};

/**
 * `Insert` : seules les colonnes sans valeur par défaut en base sont
 * obligatoires (`Required`), tout le reste est optionnel.
 */
type Table<
  Row extends Record<string, unknown>,
  Required extends keyof Row,
  Relationships extends Relationship[] = [],
> = {
  Row: Row;
  Insert: Pick<Row, Required> & Partial<Omit<Row, Required>>;
  Update: Partial<Row>;
  Relationships: Relationships;
};

/** Clé étrangère vers `recipes(id)`, portée par les tables filles. */
type RecipeFk<Name extends string> = {
  foreignKeyName: Name;
  columns: ["recipe_id"];
  isOneToOne: false;
  referencedRelation: "recipes";
  referencedColumns: ["id"];
};

export type Database = {
  public: {
    Tables: {
      recipes: Table<Recipe, "title">;
      recipe_ingredients: Table<
        RecipeIngredient,
        "recipe_id" | "name",
        [RecipeFk<"recipe_ingredients_recipe_id_fkey">]
      >;
      recipe_steps: Table<
        RecipeStep,
        "recipe_id" | "step_number" | "instruction",
        [RecipeFk<"recipe_steps_recipe_id_fkey">]
      >;
      recipe_comments: Table<
        RecipeComment,
        "recipe_id",
        [RecipeFk<"recipe_comments_recipe_id_fkey">]
      >;
      staple_products: Table<StapleProduct, "name">;
      shopping_wishlist: Table<WishlistItem, "item_name">;
      weekly_menu: Table<WeeklyMenu, "week_number" | "year">;
      weekly_menu_recipes: Table<
        WeeklyMenuRecipe,
        "menu_id" | "recipe_id",
        [
          RecipeFk<"weekly_menu_recipes_recipe_id_fkey">,
          {
            foreignKeyName: "weekly_menu_recipes_menu_id_fkey";
            columns: ["menu_id"];
            isOneToOne: false;
            referencedRelation: "weekly_menu";
            referencedColumns: ["id"];
          },
        ]
      >;
    };
    Views: Record<string, { Row: Record<string, unknown>; Relationships: [] }>;
    Functions: Record<string, { Args: Record<string, unknown>; Returns: unknown }>;
    Enums: {
      aisle_category: Aisle;
    };
    CompositeTypes: Record<string, Record<string, unknown>>;
  };
};
