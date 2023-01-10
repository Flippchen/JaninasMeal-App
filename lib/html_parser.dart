import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import 'models/meal.dart';

Future<Meal> getOnlineMeal(Uri url) async {
  print("Start scraping");
  // The URL of the food blog
  // Send a GET request to the URL
  http.Response response;
  try {
    response = await http.get(url);
  } catch (e) {
    print("Fehler bei http.get");
    return ErrorMeal;
  }

  if (response.statusCode == HttpStatus.ok) {
    // parse the response body as HTML
    final document = parse(response.body);

    // Search for the recipe title
    String title = "";
    try {
      title =
          document.querySelector("span.border-module--text--yNYGU").toString();
    } catch (e) {
      title = "Kein Titel gefunden";
    }

    // Search for the recipe ingredients
    final ingredients =
        document.querySelectorAll("div.card-module--ingredients--QK-on li");
    print("Ingredients:");
    List<String> ingredientList = [];
    for (var ingredient in ingredients) {
      ingredientList.add(ingredient.text);
      print("- ${ingredient.text}");
    }
    //Search for the recipe instructions
    print("Anfang Zubereitung");
    List<String> instructionsList = [];
    final instructions =
        document.querySelectorAll("div.card-module--instructions--eTJjd li");
    for (var element in instructions) {
      instructionsList.add(element.text.toString());
      print("- ${element.text}");
    }
    //Search for the recipe image
    print("Anfang Bild");
    String imageString = "";
    try {
      final images = document
          .querySelectorAll("div.header-module--image--Sfehh picture img");
      imageString = images[0].attributes["data-src"].toString();
    } catch (e) {
      imageString = "";
    }

    //Search for the recipe time
    print("Anfang Zeit");
    int time;
    final timeList =
        document.querySelectorAll("div.card-module--infos--GVz7U div");
    try {
      var timeString = timeList[1].text;
      time = sumNumbersInString(timeString);
    } catch (e) {
      time = 0;
    }

    //Recipe categorie
    final categories = ["c12"];

    final Meal meal = Meal(
      id: "test",
      title: title,
      imageUrl: imageString != ""
          ? imageString
          : "https://images.pexels.com/photos/1565982/pexels-photo-1565982.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      categories: categories,
      duration: time,
      complexity: Complexity.simple,
      affordability: Affordability.affordable,
      ingredients: ingredientList,
      steps: instructionsList,
      isGlutenFree: false,
      isLactoseFree: false,
      isVegan: true,
      isVegetarian: true,
    );
    return meal;
  } else {
    debugPrint("Failed to load website");
    return ErrorMeal;
  }
}

int sumNumbersInString(String input) {
  // Regular expression to match numbers
  final regex = RegExp(r'\d+');
  int sum = 0;
  // Use the `allMatches()` method to find all the matches in the input string
  for (var match in regex.allMatches(input)) {
    sum += int.parse(match.group(0)!);
  }
  return sum;
}

Meal ErrorMeal = const Meal(
  id: "ERROR",
  title: "Fehler",
  imageUrl: "h",
  categories: ["c12"],
  duration: 0,
  complexity: Complexity.simple,
  affordability: Affordability.affordable,
  ingredients: ["Fehler"],
  steps: ["Fehler"],
  isGlutenFree: false,
  isLactoseFree: false,
  isVegan: true,
  isVegetarian: true,
);
