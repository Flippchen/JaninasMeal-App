enum Complexity { simple, challenging, hard }

enum Affordability { affordable, pricey, luxurious }

class Meal {
  final String id, title, imageUrl;
  final List<String> categories, ingredients, steps;
  final int duration;
  final Complexity complexity;
  final bool isGlutenFree, isLactoseFree, isVegan, isVegetarian;
  final Affordability affordability;

  const Meal({
    required this.affordability,
    required this.categories,
    required this.complexity,
    required this.duration,
    required this.id,
    required this.imageUrl,
    required this.ingredients,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegetarian,
    required this.isVegan,
    required this.steps,
    required this.title,
  });

  Object? toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'categories': categories,
      'ingredients': ingredients,
      'steps': steps,
      'duration': duration,
      'complexity': complexity.toString(),
      'affordability': affordability.toString(),
      'isGlutenFree': isGlutenFree,
      'isLactoseFree': isLactoseFree,
      'isVegan': isVegan,
      'isVegetarian': isVegetarian,
    };
  }

  static fromJson(Map<String, dynamic> decode) {
    return Meal(
      id: decode['id'],
      title: decode['title'],
      imageUrl: decode['imageUrl'],
      categories:
          (decode['categories'] as List).map((item) => item as String).toList(),
      ingredients: (decode['ingredients'] as List)
          .map((item) => item as String)
          .toList(),
      steps: (decode['steps'] as List).map((item) => item as String).toList(),
      duration: decode['duration'],
      complexity: Complexity.values
          .firstWhere((element) => element.toString() == decode['complexity']),
      affordability: Affordability.values.firstWhere(
          (element) => element.toString() == decode['affordability']),
      isGlutenFree: decode['isGlutenFree'],
      isLactoseFree: decode['isLactoseFree'],
      isVegan: decode['isVegan'],
      isVegetarian: decode['isVegetarian'],
    );
  }
}
