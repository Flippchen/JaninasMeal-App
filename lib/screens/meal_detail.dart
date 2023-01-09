import 'package:flutter/material.dart';
import 'package:meal_app_flutter/dummy_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/models/meal.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-deatil';
  final Function toggleFavourite, isFavourite;
  final Function? callback;
  MealDetailScreen(
      {required this.toggleFavourite,
      required this.isFavourite,
      this.callback});

  Widget buildSectionTitle(String text, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Widget buildContainer(Widget child, {height = 300, width = 350}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: height.toDouble(),
      width: width.toDouble(),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealargs = ModalRoute.of(context)!.settings.arguments as List;
    final mealId = mealargs[0];
    final callback = mealargs[1];
    final affordability = mealargs[2];
    final complexity = mealargs[3];
    final duration = mealargs[4];
    final imageUrl = mealargs[5];
    final title = mealargs[6];
    final List<String> ingredients =
        (mealargs[7] as List).map((item) => item as String).toList();
    final List<String> steps =
        (mealargs[8] as List).map((item) => item as String).toList();
    final categories =
        (mealargs[9] as List).map((item) => item as String).toList();
    final filters = mealargs[10];
    final Meal selectedMeal = Meal(
      id: mealId,
      title: title,
      categories: categories,
      affordability: affordability,
      complexity: complexity,
      duration: duration,
      imageUrl: imageUrl,
      ingredients: ingredients,
      steps: steps,
      isGlutenFree: filters['gluten'],
      isLactoseFree: filters['lactose'],
      isVegan: filters['vegan'],
      isVegetarian: filters['vegetarian'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedMeal.title}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print(callback == null);
            if (callback != null) {
              callback();
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                selectedMeal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            buildSectionTitle('Zutaten', context),
            buildContainer(
              ListView.builder(
                itemCount: selectedMeal.ingredients.length,
                itemBuilder: (context, index) => Card(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                    child: Text(
                      selectedMeal.ingredients[index],
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
              ),
            ),
            buildSectionTitle('Schritte', context),
            buildContainer(
              ListView.builder(
                itemCount: selectedMeal.steps.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          '${(index + 1)}.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        selectedMeal.steps[index],
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            buildSectionTitle('Kategorien', context),
            buildContainer(
              height: 110,
              ListView.builder(
                itemCount: selectedMeal.categories.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          '${(index + 1)}.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        selectedMeal.categories[index],
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextButton.icon(
                    onPressed: () => null,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.yellow,
                    ),
                    label: Text(
                      'Bearbeiten',
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(mealId);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                    label: Text(
                      'Löschen',
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                'Komplexität: ${getMealComplexity(selectedMeal.complexity)}',
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal)),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                'Dauer: ${selectedMeal.duration} min',
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal)),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                'Preislich: ${getMealAffordability(selectedMeal.affordability)}',
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal)),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(isFavourite(mealId) ? Icons.star : Icons.star_border),
        onPressed: () => toggleFavourite(mealId),
      ),
    );
  }

  getMealComplexity(Complexity complexity) {
    switch (complexity) {
      case Complexity.simple:
        return 'Einfach';
        // ignore: dead_code
        break;
      case Complexity.challenging:
        return 'Herausfordernd';
        // ignore: dead_code
        break;
      case Complexity.hard:
        return 'Hart';
        // ignore: dead_code
        break;
      default:
        return 'Unbekannt';
    }
  }

  getMealAffordability(Affordability affordability) {
    switch (affordability) {
      case Affordability.affordable:
        return 'Günstig';
        // ignore: dead_code
        break;
      case Affordability.pricey:
        return 'Teuer';
        // ignore: dead_code
        break;
      case Affordability.luxurious:
        return 'Luxuriös';
        // ignore: dead_code
        break;
      default:
        return 'Unbekannt';
    }
  }
}
