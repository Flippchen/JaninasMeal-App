import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_app_flutter/alert_dialog.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/widgets/main_drawer.dart';
import 'package:meal_app_flutter/dummy_data.dart';
import 'package:meal_app_flutter/models/category.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';
import 'category_meals_screen.dart';
import 'category_screen.dart';
import 'meal_detail.dart';

class AddMealsScreen extends StatefulWidget {
  static const routeName = '/add-meal';
  final List<Meal> availableMeals;
  final Meal meal;

  AddMealsScreen(this.availableMeals, this.meal);

  @override
  State<AddMealsScreen> createState() => AddMealsState();
}

class AddMealsState extends State<AddMealsScreen> {
  late Meal meal;

  var finalsteps = <TextEditingController>[];
  var id = "test";
  var title = TextEditingController();
  var imageUrl = TextEditingController();
  var duration = TextEditingController();
  var complexity = Complexity.simple;
  var affordability = Affordability.affordable;
  var ingredients = TextEditingController();
  var steps = TextEditingController();
  var mealId = "";
  var cards = <Card>[];
  List<String> stepsText = [];
  List<String> ingredientsText = [];
  var finalIngredients = <TextEditingController>[];
  var categories = DUMMY_CATEGORIES;
  List<String> selectedCategories = [];
  List<String> allFilters = [
    "Glutenfrei",
    "Laktosefrei",
    "Vegetarisch",
    "Vegan"
  ];
  List<String> selectedFilters = [];
  var imagebytes = null;
  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  late File imagefile;

  @override
  void initState() {
    // ERROR means Add Mode
    if (widget.meal.id != "ERROR") {
      // Bearbeitungsmodus
      mealId = widget.meal.id;
      title.text = widget.meal.title;
      imageUrl.text = widget.meal.imageUrl ?? "";
      duration.text = widget.meal.duration.toString();
      complexity = widget.meal.complexity;
      affordability = widget.meal.affordability;
      stepsText = widget.meal.steps; // Maybe finalsteps
      ingredientsText = widget.meal.ingredients; // Maybe finalIngredients
      selectedCategories = widget.meal.categories;
      if (widget.meal.isGlutenFree) {
        selectedFilters.add("Glutenfrei");
      }
      if (widget.meal.isLactoseFree) {
        selectedFilters.add("Laktosefrei");
      }
      if (widget.meal.isVegetarian) {
        selectedFilters.add("Vegetarisch");
      }
      if (widget.meal.isVegan) {
        selectedFilters.add("Vegan");
      }
    }
    if (imageUrl.text == "") {
      loadImagebytes(mealId);
    }
    super.initState();
  }

  loadImagebytes(String mealId) async {
    var image = await loadImage(mealId);
    setState(() {
      imagebytes = image;
    });
  }

  openImage() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        imagepath = pickedFile.path;
        imagefile = File(imagepath);
        imagebytes = imagefile.readAsBytesSync();
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      showAlertDialog(context, "Error while loading image", "Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neues Rezept'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "createMeal",
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.fromLTRB(90, 0, 90, 30),
            duration: Duration(milliseconds: 800),
            content: Text("Erstelle Rezept..."),
          ));

          var creation = false;
          var favCreation = false;
          try {
            meal = Meal(
              id: mealId == ""
                  ? title.text.hashCode.toString()
                  : mealId, //TODO: Id must be consistent
              title: title.text,
              imageUrl: imageUrl.text == "" ? null : imageUrl.text,
              duration: int.parse(duration.text),
              complexity: complexity,
              affordability: affordability,
              ingredients: ingredientsText,
              steps: stepsText,
              isGlutenFree:
                  selectedFilters.contains("Glutenfrei") ? true : false,
              isLactoseFree:
                  selectedFilters.contains("Laktosefrei") ? true : false,
              isVegan: selectedFilters.contains("Vegan") ? true : false,
              isVegetarian:
                  selectedFilters.contains("Vegetarisch") ? true : false,
              categories: selectedCategories,
            );
            var meals = await getAllMeals();
            bool fav = await isMealFavourite(meal.id);
            //var meals = widget.availableMeals;
            print("Favourite: $fav");
            print("widget.meal");
            print(widget.meal.id);
            print(meal.id);
            List mealIds = meals.map((e) => e.id).toList();
            print(mealIds);
            mealIds.contains(widget.meal.id)
                ? print("Meal already exists")
                : print("Meal does not exist");
            if (!mealIds.contains(widget.meal.id)) {
              print("Creating meal");
              print(meal.toJson().toString());
              creation = await addMeals(meal);
              print("Meal is favourite $fav");
              if (meal.imageUrl != null && imagebytes != null) {
                creation = false;
                await showAlertDialog(context, "Fehler",
                    "Es dürfen nicht zwei Bilder ausgewählt werden.");
              } else if (meal.imageUrl == null && imagebytes == null) {
                var stockImage = await getStandartImage();
                await saveImage(meal.id, stockImage);
              } else if (meal.imageUrl == null && imagebytes != null) {
                await saveImage(meal.id, imagebytes);
                print("Image saved");
              }
              if (fav) {
                favCreation = await addMealsFavorite(meal);
                creation = creation && favCreation;
              }
              creation = creation;
              print("Added Meal");
            } else {
              creation = await updateMeals(meal);
              if (meal.imageUrl != null && imagebytes != null) {
                creation = false;
                await showAlertDialog(context, "Fehler",
                    "Es dürfen nicht zwei Bilder ausgewählt werden.");
              } else if (meal.imageUrl == null) {
                await saveImage(meal.id, imagebytes);
                print("Image saved");
              }
              if (fav) {
                favCreation = await updateMealsFavorite(meal);
                creation = creation && favCreation;
              }
              creation = creation;
              print("Updated Meal: $creation");
            }
          } catch (e) {
            creation = false;
            favCreation = false;
            print("Exception: $e");
            print("Error, creation false");
          }

          debugPrint(creation.toString());
          if (creation && (widget.meal.id != "ERROR")) {
            print("Screen popped");
            // Bearbeitungsmodus und erfolgreich //TODO: Wenn Error bei online Meal, dann passiert das auch / ein Input Meal erstellen wo dann auch route zu categoriescreen ist
            Navigator.pop(context, [true, meal]);
          } else if (creation && (widget.meal.id == "ERROR")) {
            // Neues Rezept und erfolgreich
            setState(() async {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.fromLTRB(90, 0, 90, 30),
                duration: Duration(milliseconds: 800),
                content: Text("Rezept erstellt!"),
              ));
              List<String> cat = await getMealCategories(meal.categories);
              print(meal.affordability.toString());
              print(meal.complexity.toString());
              await Navigator.of(context)
                  .pushNamed(MealDetailScreen.routeName, arguments: [
                meal.id,
                setState(() {}),
                meal.affordability,
                meal.complexity,
                meal.duration,
                meal.imageUrl,
                meal.title,
                meal.ingredients,
                meal.steps,
                cat,
                {
                  'gluten': meal.isGlutenFree,
                  'lactose': meal.isLactoseFree,
                  'vegan': meal.isVegan,
                  'vegetarian': meal.isVegetarian,
                },
              ]);
              Navigator.of(context).pushReplacementNamed('/');
            });
          } else {
            // Nicht erfolgreich
            showAlertDialog(context, "Fehler",
                "Rezept konnte nicht erstellt werden\nÜberprüfe deine Angaben und versuche es erneut");
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.check,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Füge ein Bild hinzu",
                          style: GoogleFonts.roboto(
                              fontSize: 23, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 200,
                        child: imageUrl.text == ""
                            ? imagebytes != null
                                ? Image.memory(
                                    imagebytes,
                                    fit: BoxFit.fill,
                                  )
                                : widget.meal.id != "ERROR"
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : const Center(child: Icon(Icons.image))
                            : Image.network(
                                imageUrl.text,
                                fit: BoxFit.fill,
                              ), //const Icon(Icons.image),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          openImage();
                        },
                        child: imagebytes == null
                            ? Text("Bild hinzufügen")
                            : Text("Bild ändern"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        child: imagebytes != null
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    imagebytes = null;
                                  });
                                },
                                child: Text("Bild entfernen"),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: imageUrl,
                decoration: const InputDecoration(
                  labelText: 'imageURL',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: duration,
                decoration: const InputDecoration(
                  labelText: 'Dauer',
                ),
              ),
            ),
            Text("Zubereitung",
                style: GoogleFonts.roboto(
                    fontSize: 23, fontWeight: FontWeight.normal)),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                child: stepsText.length > 0
                    ? const Text('Ändere oder lösche Schritte')
                    : const Text('Füge deinem Rezept Schritte hinzu'),
                onPressed: () async {
                  stepsText = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SOF(stepsText),
                    ),
                  );
                  if (stepsText != null) stepsText.forEach(print);
                  setState(() {});
                },
              ),
            ),

            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              width: 400,
              height: (stepsText.length) * 50.0 >= 250
                  ? 250
                  : stepsText.length * 50.0,
              margin: const EdgeInsets.all(10),
              child: stepsText.isNotEmpty
                  ? ListView.builder(
                      itemCount: stepsText.length,
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
                              stepsText[index],
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
                    )
                  : Text("Noch keine Schritte hinzugefügt"),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Zutaten",
                style: GoogleFonts.roboto(
                    fontSize: 23, fontWeight: FontWeight.normal)),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                child: ingredientsText.length > 0
                    ? const Text('Ändere oder lösche Zutaten')
                    : const Text('Füge deinem Rezept Zutaten hinzu'),
                onPressed: () async {
                  ingredientsText = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SOF2(ingredientsText),
                    ),
                  );
                  if (ingredientsText != null) ingredientsText.forEach(print);
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              width: 400,
              height: ingredientsText.length * 50.0 >= 250
                  ? 250
                  : ingredientsText.length * 50.0,
              margin: const EdgeInsets.all(10),
              child: ingredientsText.isNotEmpty
                  ? ListView.builder(
                      itemCount: ingredientsText.length,
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
                              ingredientsText[index],
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
                    )
                  : const Text("Noch keine Zutaten hinzugefügt"),
            ),
            const SizedBox(
              height: 20,
            ),
            // A DropdownButton for the complexity
            Row(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Text(
                      "Schwierigkeit:",
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    DropdownButton<Complexity>(
                      value: complexity,
                      onChanged: (Complexity? newValue) {
                        setState(() {
                          complexity = newValue!;
                        });
                      },
                      items: Complexity.values
                          .map<DropdownMenuItem<Complexity>>(
                              (Complexity value) {
                        return DropdownMenuItem<Complexity>(
                          value: value,
                          child: Text(getMealComplexity(value)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Text(
                  "Preis:",
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.normal)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.28,
                ),
                DropdownButton<Affordability>(
                  value: affordability,
                  onChanged: (Affordability? newValue) {
                    setState(() {
                      affordability = newValue!;
                    });
                  },
                  items: Affordability.values
                      .map<DropdownMenuItem<Affordability>>(
                          (Affordability value) {
                    return DropdownMenuItem<Affordability>(
                      value: value,
                      child: Text(getMealAffordability(value)),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Wähle die passenden Kategorien aus:",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 300,
              child: Card(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final Category category = categories[index];
                    final color = category.color;
                    return CheckboxListTile(
                      tileColor: color,
                      activeColor: Colors.black87,
                      title: Text(
                        category.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      value:
                          selectedCategories.contains(category.id.toString()),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedCategories.add(category.id.toString());
                          } else {
                            selectedCategories.remove(category.id.toString());
                          }
                        });
                      },
                    );
                  },
                  itemCount: categories.length,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Wähle die passenden Filter aus:",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 220,
              child: Card(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final filter = allFilters[index];
                    return CheckboxListTile(
                      tileColor: Colors.black12,
                      title: Text(
                        filter,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      value: selectedFilters.contains(filter),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedFilters.add(filter);
                          } else {
                            selectedFilters.remove(filter);
                          }
                        });
                      },
                    );
                  },
                  itemCount: allFilters.length,
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            // A DropdownButton for the affordability
          ],
        ),
      ),
      drawer: MainDrawer(),
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

  getStandartImage() async {
    var helper = await rootBundle.load('assets/stockimage.png');
    return helper.buffer.asUint8List();
  }
}

class SOF extends StatefulWidget {
  List? steps = [];
  SOF(this.steps);
  @override
  _SOFState createState() => _SOFState();
}

class _SOFState extends State<SOF> {
  var finalsteps = <TextEditingController>[];
  var cards = <Card>[];

  Card createCard(String? text) {
    var step = TextEditingController();
    step.text = text ?? "";
    finalsteps.add(step);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Schritt ${cards.length + 1}'),
          Row(
            children: [
              Expanded(
                child: TextField(
                    controller: step,
                    decoration: const InputDecoration(
                        labelText: 'Beschreibe den Zubereitungsschritt')),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  setState(() {
                    int index = finalsteps.indexOf(step);
                    cards.removeAt(index);
                    finalsteps.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.steps != []) {
      widget.steps?.forEach((element) {
        cards.add(createCard(element.toString()));
      });
    } else {
      cards.add(createCard(null));
    }
  }

  _onDone() {
    List<String> entries = [];
    for (int i = 0; i < cards.length; i++) {
      var name = finalsteps[i].text;
      if (name != "") {
        entries.add(name);
      }
      print(name);
    }
    Navigator.pop(context, entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Schritte hinzufügen'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _onDone();
            },
          )),
      body: Column(
        children: <Widget>[
          Expanded(
            child: cards.length > 0
                ? ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (BuildContext context, int index) {
                      return cards[index];
                    },
                  )
                : Scaffold(
                    body: Center(
                      child: Text('Noch keine Schritte hinzugefügt'),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: const Icon(Icons.add),
              onPressed: () => setState(() => cards.add(createCard(null))),
            ),
          )
        ],
      ),
      //floatingActionButton:
      //    FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
    );
  }
}

class SOF2 extends StatefulWidget {
  List? finalIngredients = [];
  SOF2(this.finalIngredients);
  @override
  _SOF2State createState() => _SOF2State();
}

class _SOF2State extends State<SOF2> {
  var finalIngredients = <TextEditingController>[];
  var cards = <Card>[];

  Card createCard(String? text) {
    var step = TextEditingController();
    step.text = text ?? "";
    finalIngredients.add(step);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Zutat ${cards.length + 1}'),
          Row(
            children: [
              Expanded(
                child: TextField(
                    controller: step,
                    decoration: const InputDecoration(
                        labelText: 'Beschreibe die Zutat')),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  setState(() {
                    int index = finalIngredients.indexOf(step);
                    cards.removeAt(index);
                    finalIngredients.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.finalIngredients != []) {
      widget.finalIngredients?.forEach((element) {
        cards.add(createCard(element.toString()));
      });
    } else {
      cards.add(createCard(null));
    }
  }

  _onDone() {
    List<String> entries = [];
    for (int i = 0; i < cards.length; i++) {
      var name = finalIngredients[i].text;
      if (name != "") {
        entries.add(name);
      }
      print(name);
    }
    Navigator.pop(context, entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Zutaten hinzufügen'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _onDone();
            },
          )),
      body: Column(
        children: <Widget>[
          Expanded(
            child: cards.length > 0
                ? ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (BuildContext context, int index) {
                      return cards[index];
                    },
                  )
                : Scaffold(
                    body: Center(
                      child: Text('Noch keine Zutaten hinzugefügt'),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: const Icon(Icons.add),
              onPressed: () => setState(() => cards.add(createCard(null))),
            ),
          )
        ],
      ),
      //floatingActionButton:
      //    FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
    );
  }
}
