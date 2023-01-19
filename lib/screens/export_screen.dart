import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_app_flutter/alert_dialog.dart';
import 'package:meal_app_flutter/html_parser.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/screens/add_meal_screen.dart';
import 'package:meal_app_flutter/screens/meal_detail.dart';
import 'package:meal_app_flutter/screens/category_screen.dart';
import 'package:meal_app_flutter/widgets/main_drawer.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import '../dummy_data.dart';
import '../models/meal.dart';

class ExportMealScreen extends StatefulWidget {
  static const routeName = '/export-meals';

  ExportMealScreen();

  @override
  State<ExportMealScreen> createState() => ExportMealState();
}

class ExportMealState extends State<ExportMealScreen> {
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
        backgroundColor: const Color(0xffd33e59),
        child: const Icon(Icons.save_alt_outlined),
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.fromLTRB(90, 0, 90, 30),
            duration: Duration(milliseconds: 1500),
            content: Text("Sichere Rezepte..."),
          ));
          var all_meals = await getAllMeals();
          var encoded = all_meals.map((meal) => json.encode(meal.toJson()));
          var FileName = "${inputText.text}.json";
          var creation = await saveAllMeals(encoded, FileName);
          if (creation) {
            var alterdialog = AlertDialog(
              title: const Text("Rezepte gespeichert"),
              content:
                  const Text("Die Rezepte wurden erfolgreich gespeichert."),
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
        title: const Text('Sichere alle Rezepte'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 400,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffd33e59),
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
              ),
            ],
          ),
          Expanded(
              child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
          )),
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
