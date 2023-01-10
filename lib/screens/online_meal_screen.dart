import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_app_flutter/alert_dialog.dart';
import 'package:meal_app_flutter/html_parser.dart';
import 'package:meal_app_flutter/widgets/main_drawer.dart';

import '../models/meal.dart';

class OnlineMealScreen extends StatefulWidget {
  static const routeName = '/online-meal';

  OnlineMealScreen();

  @override
  State<OnlineMealScreen> createState() => OnlineMealState();
}

class OnlineMealState extends State<OnlineMealScreen> {
  var inputText = TextEditingController();
  List<Meal>? displayedMeals;
  @override
  void initState() {
    // ...
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () async {
          Uri url;
          try {
            url = Uri.parse(inputText.text);
            print("Parsing hat geklappt\nURL: ${url.toString()}");
            try {
              var meal = await getOnlineMeal(url);
              if (meal.id != "ERROR") {
                print("meal erstellt");
                // TODO: Push screen with information
                //setState(() {
                //// });
              } else {
                showAlertDialog(context, "Fehler",
                    "Die Seite konnte nicht richtig geladen werden\nÜberprüfe deine Eingabe, deine Internetverbindung und versuche es erneut");
              }
            } catch (e) {
              print("Fehler bei URl");
              showAlertDialog(context, "Fehler",
                  "Ein unbekannter Fehler ist beim abrufen der URL aufgetreten.\nÜberprüfe deine Eingabe, deine Internetverbindung und versuche es erneut");
            }
          } catch (e) {
            print("Url ungültig");
            showAlertDialog(context, "URL ungültig",
                "Die eingegebene URL ist ungültig.\n Bitte korrigiere die Eingabe und versuche es erneut");
          }
        },
      ),
      appBar: AppBar(
        title: const Text('Import Online Meals'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 300,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [Container(
            decoration: BoxDecoration(
              color: const Color(0xFF8bc34a),
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            width: 400,
            height: 170,
            child:Column(mainAxisAlignment:MainAxisAlignment.center, children: [const Text(
              "Gib hier die URL von Zucker & Jagdwurst ein",
              style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
            ),const SizedBox(
              height: 10,
            ),Container(
              height: 100,
              width: 400,
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: inputText,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle: TextStyle(color: Colors.black,fontSize: 13),
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),

                  ),
                  labelText: 'URL',
                  hintText: 'Bsp: https://www.zuckerundjagdwurst.de/rezepte/veganer-erdnussbutter-kuchen/',
                ),
              ),
            ),], ),),],)



        ],
      ),
    );
  }
}
