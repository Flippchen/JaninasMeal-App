import 'dart:convert';
import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_app_flutter/alert_dialog.dart';
import 'package:meal_app_flutter/html_parser.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/screens/add_meal_screen.dart';
import 'package:meal_app_flutter/screens/meal_detail.dart';
import 'package:meal_app_flutter/screens/category_screen.dart';
import 'package:meal_app_flutter/widgets/main_drawer.dart';
import 'package:path_provider/path_provider.dart';
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
      appBar: AppBar(
        title: const Text('Lade alle Rezepte'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Expanded(
              child: SizedBox(
            height: 50,
          )),
          Text(
            "Drücke den Knopf, um Rezepte zu importieren!",
            style:
                GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 100,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xff439180),
              ),
              width: 200,
              height: 200,
              child: TextButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.fromLTRB(90, 0, 90, 30),
                    duration: Duration(milliseconds: 1500),
                    content: Text("Importiere Rezepte..."),
                  ));

                  Directory Path = await getTemporaryDirectory();
                  Directory? rootPath = await getExternalStorageDirectory();
                  print(rootPath.toString());
                  String? path = await FilesystemPicker.open(
                    title: 'Lade aus dem Ordner',
                    context: context,
                    //directory: Path,
                    rootDirectory: rootPath ?? Path,
                    fileTileSelectMode: FileTileSelectMode.wholeTile,
                    allowedExtensions: ['.json'],
                    fsType: FilesystemType.file,
                    pickText: 'Lade Rezepte',
                    folderIconColor: Colors.teal,
                  );
                  print(path);
                  var creation = false;
                  if (path != null) {
                    creation = await loadAllSavedMeals(path);
                  }

                  if (creation) {
                    var alterdialog = AlertDialog(
                      title: const Text("Rezepte erfolgreich geladen"),
                      content:
                          const Text("Die Rezepte wurden erfolgreich geladen."),
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
                child: const Icon(
                  Icons.upload,
                  size: 70,
                ),
              ),
            ),
          ),
          Expanded(
              child: SizedBox(
            height: 500,
          ))
        ],
      ),
    );
  }
}
