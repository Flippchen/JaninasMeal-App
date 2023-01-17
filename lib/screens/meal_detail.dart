import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_app_flutter/models/meal.dart';

import '../alert_dialog.dart';
import '../dummy_data.dart';
import '../main.dart';
import 'add_meal_screen.dart';

class MealDetailScreen extends StatefulWidget {
  static const routeName = '/meal-deatil';
  final Function toggleFavourite, isFavourite;
  final Function? callback;
  MealDetailScreen(
      {required this.toggleFavourite,
      required this.isFavourite,
      this.callback});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  bool isInit = false;
  late final List mealargs;
  late final String mealId;
  late final Function? callback;
  late final Affordability affordability;
  late final Complexity complexity;
  late final int duration;
  late final String? imageUrl;
  late final String title;
  late final List<String> ingredients;
  late final List<String> steps;
  late final categories;
  late List<String> showCategories;
  //print(categories.toString());
  late final Map filters;
  late Meal selectedMeal;
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
    if (!isInit) {
      setState(() {
        final mealargs = ModalRoute.of(context)!.settings.arguments as List;
        mealId = mealargs[0];
        callback = mealargs[1];
        affordability = mealargs[2];
        complexity = mealargs[3];
        duration = mealargs[4];
        imageUrl = mealargs[5];
        title = mealargs[6];
        ingredients =
            (mealargs[7] as List).map((item) => item as String).toList();
        steps = (mealargs[8] as List).map((item) => item as String).toList();
        categories =
            (mealargs[9] as List).map((item) => item as String).toList();
        showCategories = getMealCategories(categories);
        print(categories.toString());
        filters = mealargs[10];
        selectedMeal = Meal(
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
        isInit = true;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMeal.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (callback != null) {
              callback!();
            }
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: selectedMeal.imageUrl != null
                  ? Image.network(
                      selectedMeal.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : const Text(
                      "No Network Image"), //TODO: Await Image from File // Brainfuck!!
            ),
            Container(
              color: const Color(0x426ec539),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(
                        width: 7,
                      ),
                      Text('${selectedMeal.duration} min',
                          style: GoogleFonts.roboto(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(MdiIcons.weight),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(getMealComplexity(selectedMeal.complexity),
                          style: GoogleFonts.roboto(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.attach_money),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(getMealAffordability(selectedMeal.affordability),
                          style: GoogleFonts.roboto(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            buildSectionTitle('Zutaten', context),
            selectedMeal.ingredients != []
                ? buildContainer(
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
                  )
                : buildContainer(
                    height: 100,
                    Text("Keine Zutaten vorhanden",
                        style: GoogleFonts.roboto(
                            fontSize: 25, fontWeight: FontWeight.w500))),
            buildSectionTitle('Schritte', context),
            selectedMeal.steps != []
                ? buildContainer(
                    ListView.builder(
                      itemCount: selectedMeal.steps.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                '${(index + 1)}.',
                                style: const TextStyle(color: Colors.white),
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
                          const Divider(),
                        ],
                      ),
                    ),
                  )
                : buildContainer(
                    height: 100,
                    Text("Keine Schritte vorhanden",
                        style: GoogleFonts.roboto(
                            fontSize: 25, fontWeight: FontWeight.w500))),
            buildSectionTitle('Kategorien', context),
            showCategories != []
                ? buildContainer(
                    height: 130,
                    ListView.builder(
                      itemCount: showCategories.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              child: Text(
                                '${(index + 1)}.',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              showCategories[index],
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  )
                : buildContainer(
                    height: 100,
                    Text("Keine Kategorien vorhanden",
                        style: GoogleFonts.roboto(
                            fontSize: 25, fontWeight: FontWeight.w500))),
            const SizedBox(
              height: 40,
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: TextButton.icon(
                    onPressed: () async {
                      List values;
                      var all_meals = await getAllMeals();

                      values = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddMealsScreen(all_meals, selectedMeal);
                      }));
                      print(values.toString());
                      if (values[0]) {
                        print("Wir sind angekommen");
                        print(values[1].toString());
                        Meal selectedMealNew = values[1];
                        setState(() {
                          selectedMeal = selectedMealNew;
                          print("Selected Meal: " + selectedMeal.toString());
                        });
                      } else {
                        await showAlertDialog(context, "Fehler",
                            "Das Rezept konnte nicht bearbeitet werden");
                      }
                    },
                    // TODO: Add Refresh?
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: TextButton.icon(
                    onPressed: () async {
                      bool delete = await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertWidget(),
                      );
                      if (delete) {
                        var value = await deleteMeals(selectedMeal.id);
                        var value2 =
                            await deleteMealsFavorites(selectedMeal.id);
                        if (value && value2) {
                          Navigator.pop(context, true);
                          debugPrint("gelöscht");
                        } else {
                          await showAlertDialog(context, "Fehler",
                              "Das Rezept konnte nicht gelöscht werden");
                        }
                      }
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
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(widget.isFavourite(mealId)
            ? Icons.favorite
            : Icons.favorite_outline),
        onPressed: () => widget.toggleFavourite(mealId),
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

  List<String> getMealCategories_id(List<String> categories) {
    List<String> cat = [];
    for (var i = 0; i < categories.length; i++) {
      for (var j = 0; j < DUMMY_CATEGORIES.length; j++) {
        if (categories[i] == DUMMY_CATEGORIES[j].title) {
          cat.add(DUMMY_CATEGORIES[j].id);
        }
      }
    }
    return cat;
  }

  getMealCategories(List<String> categories) {
    List<String> cat = [];
    for (var i = 0; i < categories.length; i++) {
      for (var j = 0; j < DUMMY_CATEGORIES.length; j++) {
        if (categories[i] == DUMMY_CATEGORIES[j].id) {
          cat.add(DUMMY_CATEGORIES[j].title);
        }
      }
    }
    return cat;
  }
}
