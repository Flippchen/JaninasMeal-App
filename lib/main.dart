import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:meal_app_flutter/dummy_data.dart';
import 'package:meal_app_flutter/models/meal.dart';
import 'package:meal_app_flutter/screens/add_meal_screen.dart';
import 'package:meal_app_flutter/screens/all_meals_screen.dart';
import 'package:meal_app_flutter/screens/category_meals_screen.dart';
import 'package:meal_app_flutter/screens/export_screen.dart';
import 'package:meal_app_flutter/screens/import_screen.dart';
import 'package:meal_app_flutter/screens/intro_screen.dart';
import 'package:meal_app_flutter/screens/online_meal_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:meal_app_flutter/screens/category_screen.dart';
import 'package:meal_app_flutter/screens/filters_screen.dart';
import 'package:meal_app_flutter/screens/meal_detail.dart';
import 'package:meal_app_flutter/screens/tabs_screen.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isInit = false;
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegetarian': false,
    'vegan': false,
  };
  @override
  initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    helper();
  }

  void helper() async {
    final prefs = await SharedPreferences.getInstance();
    var tempmeals = await getAllMeals();
    var tempfavs = await getAllFavouriteMeals();
    var tempfilters = prefs.getStringList("filters");
    //print(tempfavs.map((e) => e.toJson().toString()))
    setState(() {
      _isInit = prefs.getBool("isInit") ?? false;
      _availableMeals = tempmeals;
      _favouriteMeals = tempfavs;
      if (tempfilters != null) {
        _filters = {
          'gluten': tempfilters[0] == "true" ? true : false,
          'lactose': tempfilters[1] == "true" ? true : false,
          'vegetarian': tempfilters[2] == "true" ? true : false,
          'vegan': tempfilters[3] == "true" ? true : false,
        };
      }
      //print(_favouriteMeals.map((e) => e.toJson().toString()));
    });
    _setFilters(_filters);
  }

  List<Meal> _availableMeals = [];

  List<Meal> _favouriteMeals = [];

  void _setFilters(Map<String, bool> filterData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("filters",
        filterData.values.toList().map((e) => e.toString()).toList());
    _availableMeals = await getAllMeals();
    setState(() {
      _filters = filterData;
      _availableMeals = _availableMeals.where((meal) {
        if (_filters['gluten']! && !meal.isGlutenFree) {
          return false;
        }

        if (_filters['lactose']! && !meal.isLactoseFree) {
          return false;
        }

        if (_filters['vegetarian']! && !meal.isVegetarian) {
          return false;
        }

        if (_filters['vegan']! && !meal.isVegan) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggledFavourite(String mealId) async {
    var favMeals = await getAllFavouriteMeals();
    _favouriteMeals = favMeals;
    print("Favourite Meals");
    print(favMeals.toList().toString());
    final existingIndex =
        _favouriteMeals.indexWhere((meal) => meal.id == mealId);
    // Remove Meal if it was favourite before
    if (existingIndex >= 0) {
      setState(() {
        _favouriteMeals.removeAt(existingIndex);
        var encoded = _favouriteMeals.map((meal) => json.encode(meal.toJson()));
        writeMealsFav(encoded);
      });
      // Add Meal if it was not favourite before
    } else {
      setState(() {
        _favouriteMeals
            .add(_availableMeals.firstWhere((meal) => meal.id == mealId));
        var encoded = _favouriteMeals.map((meal) => json.encode(meal.toJson()));
        writeMealsFav(encoded);
      });
    }
  }

  bool _isMealFavourite(String id) {
    return _favouriteMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meals_App',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: TextStyle(
                fontSize: 20.0,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      //home: CategoriesScreen(),
      routes: {
        '/': (context) =>
            _isInit == true ? TabsScreen() : IntroductionScreens(),
        CategoryMealsScreen.routeName: (context) => CategoryMealsScreen(),
        MealDetailScreen.routeName: (context) => MealDetailScreen(
            toggleFavourite: _toggledFavourite, isFavourite: _isMealFavourite),
        FiltersScreen.routeName: (context) =>
            FiltersScreen(_setFilters, _filters),
        OnlineMealScreen.routeName: (context) => OnlineMealScreen(),
        AllMealsScreen.routeName: (context) => AllMealsScreen(_availableMeals),
        AddMealsScreen.routeName: (context) =>
            AddMealsScreen(_availableMeals, ErrorMeal),
        ExportMealScreen.routeName: (context) => ExportMealScreen(),
        ImportMealScreen.routeName: (context) => ImportMealScreen(),
        IntroductionScreens.routeName: (context) => IntroductionScreens(),
      },

      onGenerateRoute: (settings) {
        print(settings.arguments);
        return MaterialPageRoute(builder: (context) => CategoriesScreen());
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => CategoriesScreen());
      },
    );
  }
}

/// Normal Meals
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  print("Path: $path");
  var exists = await File('$path/meals.json').exists();
  if (!exists) {
    var file = await File('$path/meals.json').create();
    var helper = await rootBundle.loadString('assets/meals.json');
    file.writeAsString(helper);
    return file;
  }
  return File('$path/meals.json');
}

//await rootBundle.loadString('assets/meals.json');
// : await File('$path/meals.json').create()
Future<File> writeMeals(Iterable<String> objects) async {
  final file = await _localFile;
  // Write the file
  return file.writeAsString("[${objects.join(",")}]");
}

Future<bool> writeAllMeals(Iterable<String> objects) async {
  final file = await _localFile;
  file.writeAsString("[${objects.join(",")}]").then((value) => true);
  return true;
}

Future<bool> loadAllSavedMeals(String name) async {
  var file = File(name);
  var contents = await file.readAsString();
  List<Meal> mealsList = [];
  var decoded = json.decode(contents);
  decoded.forEach((meal) {
    mealsList.add(Meal.fromJson(meal));
  });
  var encoded = mealsList.map((meal) => json.encode(meal.toJson()));
  await writeMeals(encoded);
  return true;
}

Future<String> readMeals() async {
  final file = await _localFile;

  // Read the file
  final contents = await file.readAsString();

  return contents;
}

Future<List<Meal>> getAllMeals() async {
  //only one time in production
  //var encoded = DUMMY_MEALS.map((meal) => json.encode(meal.toJson()));
  //print(encoded);
  //await writeMeals(encoded);
  var meals = await readMeals();
  List<Meal> mealsList = [];
  var decoded = json.decode(meals);
  decoded.forEach((meal) {
    mealsList.add(Meal.fromJson(meal));
  });

  return mealsList;
}

Future<bool> addMeals(Meal meal) async {
  var meals = await getAllMeals();
  meals.add(meal);
  var encoded = meals.map((meal) => json.encode(meal.toJson()));
  await writeMeals(encoded);
  return true;
}

Future<bool> updateMeals(Meal meal) async {
  var meals = await getAllMeals();
  var index = meals.indexWhere((element) => element.id == meal.id);
  meals[index] = meal;
  var encoded = meals.map((meal) => json.encode(meal.toJson()));
  await writeMeals(encoded);
  return true;
}

Future<bool> deleteMeals(String id) async {
  var meals = await getAllMeals();
  meals.removeWhere((element) => element.id == id);
  var encoded = meals.map((meal) => json.encode(meal.toJson()));
  await writeMeals(encoded);
  return true;
}

Future<bool> saveAllMeals(Iterable<String> objects, String name) async {
  final dir = await getExternalStorageDirectory();
  var path = dir?.path;
  var file = await File('$path/$name').create();
  await file.writeAsString("[${objects.join(",")}]");
  print("Saved file to: $path/$name");
  // Write the file
  return true;
}

/// Favorite Meals
Future<File> get _localFileFav async {
  final path = await _localPath;
  print("Path: $path");
  var exists = await File('$path/fav.json').exists();
  return exists
      ? File('$path/fav.json')
      : await File('$path/fav.json').create();
}

Future<File> writeMealsFav(Iterable<String> objects) async {
  final file = await _localFileFav;
  // Write the file
  return file.writeAsString("[${objects.join(",")}]");
}

Future<String> readMealsFav() async {
  final file = await _localFileFav;

  // Read the file
  final contents = await file.readAsString();

  return contents;
}

Future<List<Meal>> getAllFavouriteMeals() async {
  //only one time in production
  //var encoded = DUMMY_MEALS.map((meal) => json.encode(meal.toJson()));
  //print(encoded);
  //await writeMeals(encoded);
  var meals = await readMealsFav();
  List<Meal> mealsList = [];
  if (meals != "") {
    var decoded = json.decode(meals);
    decoded.forEach((meal) {
      mealsList.add(Meal.fromJson(meal));
    });
  }

  return mealsList;
}

Future<bool> addMealsFavorite(Meal meal) async {
  var meals = await getAllFavouriteMeals();
  meals.add(meal);
  var encoded = meals.map((meal) => json.encode(meal.toJson()));
  await writeMealsFav(encoded);
  return true;
}

Future<bool> updateMealsFavorite(Meal meal) async {
  var meals = await getAllFavouriteMeals();
  var index = meals.indexWhere((element) => element.id == meal.id);
  meals[index] = meal;
  var encoded = meals.map((meal) => json.encode(meal.toJson()));
  await writeMealsFav(encoded);
  return true;
}

Future<bool> isMealFavourite(String id) async {
  var meals = await getAllFavouriteMeals();
  return meals.any((element) => element.id == id);
}

Future<bool> deleteMealsFavorites(String id) async {
  var meals = await getAllFavouriteMeals();
  meals.removeWhere((element) => element.id == id);
  var encoded = meals.map((meal) => json.encode(meal.toJson()));
  await writeMealsFav(encoded);
  return true;
}

saveImage(String id, Uint8List imagebytes) async {
  final directory = await getExternalStorageDirectory();
  print("Path: ${directory!.path}");
  var file = File('${directory.path}/$id.jpg');
  if (await file.exists()) {
    await file.delete();
  }
  await file.writeAsBytes(imagebytes);
}

loadImage(String id) async {
  final directory = await getExternalStorageDirectory();
  final file = File('${directory?.path}/$id.jpg');
  print("Image loaded: ${file.path}");
  return await file.readAsBytes();
}

// Near future:
// FIXME:Jagdwurst Parser anpassen usw
// FIXME: Error when opening add meal because of image

// Future
// TODO: Startbild und Appbild --> Playestore
// TODO: Rezeptgröße auf Personen anpassen und Angabe Rezept Anzahl Personen
// TODO: Mealitem durch Kommentar erweitern
