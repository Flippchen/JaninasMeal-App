import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';

class AllMealsScreen extends StatefulWidget {
  static const routeName = '/all-meals';
  final List<Meal> availableMeals;

  AllMealsScreen(this.availableMeals);

  @override
  State<AllMealsScreen> createState() => AllMealsState();
}

class AllMealsState extends State<AllMealsScreen> {
  List<Meal>? displayedMeals;
  @override
  void initState() {
    // ...
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (true) {
      displayedMeals = widget.availableMeals.toList();
    }
    super.didChangeDependencies();
  }

  getAllDisplayMeals() async {
    var displayedMeals = await getAllMeals();
    final prefs = await SharedPreferences.getInstance();
    var tempfilters = prefs.getStringList("filters");
    var filters;
    if (tempfilters != null) {
      filters = {
        'gluten': tempfilters[0] == "true" ? true : false,
        'lactose': tempfilters[1] == "true" ? true : false,
        'vegetarian': tempfilters[2] == "true" ? true : false,
        'vegan': tempfilters[3] == "true" ? true : false,
      };
    } else {
      filters = {
        'gluten': false,
        'lactose': false,
        'vegetarian': false,
        'vegan': false,
      };
    }
    displayedMeals = displayedMeals.where((meal) {
      if (filters['gluten']! && !meal.isGlutenFree) {
        return false;
      }

      if (filters['lactose']! && !meal.isLactoseFree) {
        return false;
      }

      if (filters['vegetarian']! && !meal.isVegetarian) {
        return false;
      }

      if (filters['vegan']! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    return displayedMeals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () async {
          var displayedMealsNew = await getAllMeals();
          setState(() {
            displayedMeals = displayedMealsNew;
          });
        },
      ),
      appBar: AppBar(
        title: const Text('Alle Mahlzeiten'),
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
          future: getAllDisplayMeals(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              displayedMeals = snapshot.data;
              return ListView.builder(
                itemBuilder: (ctx, index) {
                  return MealItem(
                    id: displayedMeals![index].id,
                    title: displayedMeals![index].title,
                    imageUrl: displayedMeals?[index].imageUrl,
                    duration: displayedMeals![index].duration,
                    affordability: displayedMeals![index].affordability,
                    complexity: displayedMeals![index].complexity,
                    steps: displayedMeals![index].steps,
                    ingredients: displayedMeals![index].ingredients,
                    categories: displayedMeals![index].categories,
                    //callback: (List<Meal> changedMeals) => setState(() {
                    //displayedMeals = changedMeals;
                    //}),
                    filters: {
                      "gluten": displayedMeals![index].isGlutenFree,
                      "lactose": displayedMeals![index].isLactoseFree,
                      "vegan": displayedMeals![index].isVegan,
                      "vegetarian": displayedMeals![index].isVegetarian
                    },
                  );
                },
                itemCount: displayedMeals!.length,
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Keine Mahlzeiten zu dieser Kategorie vorhanden'),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
