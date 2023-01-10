import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meal_app_flutter/dummy_data.dart';
import 'package:meal_app_flutter/models/meal.dart';
import 'package:meal_app_flutter/screens/meal_detail.dart';

class MealItem extends StatelessWidget {
  final String id, title, imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final Function? callback;
  final List<String> categories, ingredients, steps;
  final Map<String, bool> filters;

  MealItem({
    required this.id,
    required this.affordability,
    required this.complexity,
    required this.duration,
    required this.imageUrl,
    required this.title,
    required this.ingredients,
    required this.steps,
    required this.categories,
    required this.filters,
    this.callback,
  });

  Future<bool> selectMeal(BuildContext context) async {
    List<String> cat = await getMealCategories(categories);

    Navigator.of(context).pushNamed(MealDetailScreen.routeName, arguments: [
      id,
      callback,
      affordability,
      complexity,
      duration,
      imageUrl,
      title,
      ingredients,
      steps,
      cat,
      filters
    ]).then((result) {
      if (result != null) {
        // removeItem(result);
      }
    });
    return true;
  }

  String get complexityText {
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

  String get affordabilityText {
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await selectMeal(context);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(
                        width: 6,
                      ),
                      Text('$duration min'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(MdiIcons.weight),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(complexityText),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.attach_money),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(affordabilityText),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
