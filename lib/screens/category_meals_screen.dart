import 'package:flutter/material.dart';
import 'package:meal_app_flutter/models/meal.dart';
import 'package:meal_app_flutter/widgets/meal_item.dart';

import '../main.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  final List<Meal> availableMeals;

  CategoryMealsScreen(this.availableMeals);

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

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      categoryId = routeArgs['id'];
      //meals = routeArgs['meals'];
      displayedMeals = widget.availableMeals.where((meal) {
        return meal.categories.contains(categoryId);
      }).toList();
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
        body: displayedMeals!.length > 0
            ? ListView.builder(
                itemBuilder: (ctx, index) {
                  return MealItem(
                    id: displayedMeals![index].id,
                    title: displayedMeals![index].title,
                    imageUrl: displayedMeals![index].imageUrl!,
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
              )
            : const Scaffold(
                body: Center(
                  child: Text('Keine Mahlzeiten zu dieser Kategorie vorhanden'),
                ),
              ));
  }
}
