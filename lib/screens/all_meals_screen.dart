import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/widgets/main_drawer.dart';

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
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return MealItem(
            id: displayedMeals![index].id,
            title: displayedMeals![index].title,
            imageUrl: displayedMeals![index].imageUrl,
            duration: displayedMeals![index].duration,
            affordability: displayedMeals![index].affordability,
            complexity: displayedMeals![index].complexity,
            steps: displayedMeals![index].steps,
            ingredients: displayedMeals![index].ingredients,
            categories: displayedMeals![index].categories,
            filters: {
              "gluten": displayedMeals![index].isGlutenFree,
              "lactose": displayedMeals![index].isLactoseFree,
              "vegan": displayedMeals![index].isVegan,
              "vegetarian": displayedMeals![index].isVegetarian
            },
          );
        },
        itemCount: displayedMeals!.length,
      ),
    );
  }
}
