import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/widgets/main_drawer.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';

class AddMealsScreen extends StatefulWidget {
  static const routeName = '/add-meal';
  final List<Meal> availableMeals;

  AddMealsScreen(this.availableMeals);

  @override
  State<AddMealsScreen> createState() => AddMealsState();
}

class AddMealsState extends State<AddMealsScreen> {
  var finalsteps = <TextEditingController>[];
  var id = "test";
  var title = TextEditingController();
  var imageUrl = TextEditingController();
  var duration = TextEditingController();
  var complexity = TextEditingController();
  var affordability = TextEditingController();
  var ingredients = TextEditingController();
  var steps = TextEditingController();
  var cards = <Card>[];
  var stepsText = [];

  Card createCard() {
    var step = TextEditingController();
    finalsteps.add(step);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Schritt ${cards.length + 1}'),
          TextField(
              controller: step,
              decoration: const InputDecoration(
                  labelText: 'Beschreibe den Zubereitungsschritt')),
        ],
      ),
    );
  }

  @override
  void initState() {
    // ...
    super.initState();
    cards.add(createCard());
  }

  _onDone() {
    List entries = [];
    for (int i = 0; i < cards.length; i++) {
      var name = finalsteps[i].text;
      entries.add(name);
    }
    Navigator.pop(context, entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Füge ein Rezept hinzu'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "createMeal",
        onPressed: () async {
          Meal meal = Meal(
            id: imageUrl.hashCode.toString(),
            title: title.text,
            imageUrl: imageUrl.text,
            duration: int.parse(duration.text),
            complexity: Complexity.values
                .firstWhere((element) => element.toString() == complexity.text),
            affordability: Affordability.values.firstWhere(
                (element) => element.toString() == affordability.text),
            ingredients: ingredients.text.split(","),
            steps: steps.text.split(","),
            isGlutenFree: false,
            isLactoseFree: false,
            isVegan: false,
            isVegetarian: false,
            categories: [],
          );
          var creation = true; //await addMeals(meal);
          /// TODO: Add Refresh of screen
          debugPrint(creation.toString());
          if (creation) {
            Navigator.pop(context);
          } else {
            showAboutDialog(
                context: context,
                applicationName: "Fehler",
                applicationVersion: "Fehler beim Erstellen des Rezepts");
          }
          //Navigator.pop(context);
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
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                ),
              ),
            ),
            Text("Schritte",
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton(
              child: Text('Füge deinem Rezept die Schritte hinzu'),
              onPressed: () async {
                stepsText = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SOF(),
                  ),
                );
                if (stepsText != null) stepsText.forEach(print);
                setState(() {});
              },
            ),
            Container(
              width: 300,
              height: 450,
              margin: const EdgeInsets.all(10),
              child: stepsText != []
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
                  : const Text("Noch keine Schritte hinzugefügt"),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: duration,
                decoration: const InputDecoration(
                  labelText: 'Dauer',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: complexity,
                decoration: const InputDecoration(
                  labelText: 'Komplexität',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: affordability,
                decoration: const InputDecoration(
                  labelText: 'Preis',
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: MainDrawer(),
    );
  }
}

class SOF extends StatefulWidget {
  @override
  _SOFState createState() => _SOFState();
}

class _SOFState extends State<SOF> {
  var finalsteps = <TextEditingController>[];
  var cards = <Card>[];

  Card createCard() {
    var step = TextEditingController();
    finalsteps.add(step);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Schritt ${cards.length + 1}'),
          TextField(
              controller: step,
              decoration: const InputDecoration(
                  labelText: 'Beschreibe den Zubereitungsschritt')),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cards.add(createCard());
  }

  _onDone() {
    List entries = [];
    for (int i = 0; i < cards.length; i++) {
      var name = finalsteps[i].text;
      entries.add(name);
      print(name);
    }
    Navigator.pop(context, entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int index) {
                return cards[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: Text('add new'),
              onPressed: () => setState(() => cards.add(createCard())),
            ),
          )
        ],
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
    );
  }
}
