import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_app_flutter/alert_dialog.dart';
import 'package:meal_app_flutter/html_parser.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/screens/add_meal_screen.dart';
import 'package:meal_app_flutter/screens/meal_detail.dart';
import 'package:meal_app_flutter/screens/category_screen.dart';
import 'package:meal_app_flutter/widgets/main_drawer.dart';

import '../dummy_data.dart';
import '../models/meal.dart';

class ImportMealScreen extends StatefulWidget {
  static const routeName = '/import-meals';

  ImportMealScreen();

  @override
  State<ImportMealScreen> createState() => ImportMealState();
}

class ImportMealState extends State<ImportMealScreen> {
  var inputText = TextEditingController();
  @override
  void initState() {
    // ...
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload),
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.fromLTRB(90, 0, 90, 30),
            duration: Duration(milliseconds: 1500),
            content: Text("Importiere Rezepte..."),
          ));
          var fileName = "${inputText.text}.json";
          var creation = await loadAllSavedMeals(fileName);

          if (creation) {
            var alterdialog = AlertDialog(
              title: const Text("Rezepte erfolgreich geladen"),
              content: const Text("Die Rezepte wurden erfolgreich geladen."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                )
              ],
            );
            var dialog = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alterdialog;
                });
            if (dialog) {
              Navigator.pushReplacementNamed(context, "/");
            }
          } else {
            await showAlertDialog(
                context, "Fehler", "Es ist ein Fehler aufgetreten");
          }
        },
      ),
      appBar: AppBar(
        title: const Text('Lade alle Rezepte'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 300,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff439180),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 400,
                height: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Name deiner Sicherungsdatei:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 100,
                      width: 400,
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: inputText,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 13),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 20),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          labelText: 'Dateiname',
                          hintText: 'meineRezepte',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
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