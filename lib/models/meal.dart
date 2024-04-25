class Meal {
  final String? name;
  final String? instructions;
  final String? area;
  final String? category;
  final List<String>? tags;
  final String? youtubeUrl;
  final String? imageUrl;
  final List<Ingredient> ingredients = List.empty(growable: true);

  Meal({
    this.name,
    this.instructions,
    this.area,
    this.category,
    this.tags,
    this.youtubeUrl,
    this.imageUrl,
    required List<Map<String, String>> ingredients,
  }) {
    for (int i = 1; i <= 20; i++) {
      final String ingredient = ingredients
          .singleWhere((map) => map.entries.first.key == "strIngredient$i")
          .entries
          .first
          .value;

      final String measure = ingredients
          .singleWhere((map) => map.entries.first.key == "strMeasure$i")
          .entries
          .first
          .value;

      if (ingredient.isNotEmpty && measure.isNotEmpty) {
        this.ingredients.add(
              Ingredient(
                ingredient: ingredient,
                measure: measure,
              ),
            );
      }
    }
  }

  factory Meal.fromMap({required Map<String, dynamic> map}) {
    final Map meal = map["meals"][0];
    return Meal(
      name: meal["strMeal"],
      category: meal["strCategory"],
      area: meal["strArea"],
      instructions: meal["strInstructions"],
      imageUrl: meal["strMealThumb"],
      tags: meal["strTags"] == null
          ? null
          : List<String>.from((meal["strTags"] as String).split(",")),
      youtubeUrl: meal["strYoutube"],
      ingredients: meal.entries
          .where((entry) =>
              entry.key.toString().contains("Ingredient") ||
              entry.key.toString().contains("Measure"))
          .map((entry) => {entry.key.toString(): entry.value.toString()})
          .toList(),
    );
  }

  @override
  String toString() {
    return "Meal(name: $name, instructions: $instructions, area: $area, category: $category, tags: $tags, youtubeUrl: $youtubeUrl, imageUrl: $imageUrl, ingredients: $ingredients)";
  }
}

class Ingredient {
  final String ingredient;
  final String measure;

  const Ingredient({
    required this.ingredient,
    required this.measure,
  });

  factory Ingredient.fromMap({required Map<String, String> map}) => Ingredient(
        ingredient: map["ingredient"]!,
        measure: map["measure"]!,
      );

  @override
  String toString() => "Ingredient(ingredient: $ingredient, measure: $measure)";
}
