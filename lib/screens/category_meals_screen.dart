import 'package:flutter/material.dart';
import 'package:meal_app_flutter/models/meal.dart';
import 'package:meal_app_flutter/widgets/meal_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  List<Meal>? availableMeals;

  CategoryMealsScreen();

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  String? categoryTitle;
  String? categoryId;
  List<Meal>? displayedMeals;
  var _loadedInitData = false;
  //var meals;
  @override
  void initState() {
    // ...
    super.initState();
  }

  getAllDisplayMeals() async {
    var meals = await getAllMeals();
    displayedMeals = meals.where((meal) {
      return meal.categories.contains(categoryId);
    }).toList();
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
    displayedMeals = displayedMeals!.where((meal) {
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
  void didChangeDependencies() {
    if (!_loadedInitData) {
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      categoryId = routeArgs['id'];
      //meals = routeArgs['meals'];
      //displayedMeals = widget.availableMeals.where((meal) {
      //  return meal.categories.contains(categoryId);
      // }).toList();
      _loadedInitData = true;
    }
    super.didChangeDependencies();
  }

  void updateMeals(List<Meal> meals) {
    setState(() {
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      categoryId = routeArgs['id'];
      //meals = routeArgs['meals'];
      displayedMeals = meals.where((meal) {
        return meal.categories.contains(categoryId);
      }).toList();
    });
  }

  void _removeMeal(String mealId) {
    setState(() {
      displayedMeals!.removeWhere((meal) => meal.id == mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(categoryTitle!),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () async {
            var displayedMealsNew = await getAllMeals();
            updateMeals(displayedMealsNew);
          },
        ),
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
                      categoryTitle: categoryTitle,
                      categoryId: categoryId,
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
            }));
  }
}
