import 'package:flutter/material.dart';
import 'package:meal_app_flutter/alert_dialog.dart';
import 'package:meal_app_flutter/screens/filters_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 23,
            fontWeight: FontWeight.bold),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: TextButton(
              onLongPress: () {
                showAlertDialog(context, "Ich liebe dich", "❤️");
              },
              onPressed: () {},
              child: Text(
                'Erfinde dich neu!',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile(
            'Alle Rezepte',
            Icons.restaurant_menu,
            () {
              Navigator.of(context).pushReplacementNamed("/all-meals");
            },
          ),
          buildListTile(
            'Neues Rezept',
            Icons.add,
            () {
              Navigator.of(context).pushReplacementNamed("/add-meal");
            },
          ),
          buildListTile(
            'Kategorien',
            Icons.restaurant,
            () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          buildListTile(
            'Importieren',
            Icons.import_export,
            () {
              Navigator.of(context).pushReplacementNamed('/online-meal');
            },
          ),
          const SizedBox(
            height: 470,
          ),
          buildListTile(
            'Filter',
            Icons.settings,
            () {
              Navigator.of(context)
                  .pushReplacementNamed(FiltersScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
