import 'package:flutter/material.dart';
import 'package:meal_app_flutter/models/meal.dart';
import 'package:meal_app_flutter/screens/category_screen.dart';
import 'package:meal_app_flutter/screens/favourites_screen.dart';
import 'package:meal_app_flutter/widgets/main_drawer.dart';

import '../main.dart';

class TabsScreen extends StatefulWidget {
  TabsScreen();

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, dynamic>>? _pages;

  int _selectedPageindex = 0;

  @override
  void initState() {
    setState(() {
      _pages = [
        {
          'Page': CategoriesScreen(),
          'title': 'Kategorien',
        },
        {
          'Page': FavouritesScreen(),
          'title': 'Meine Favoriten',
        },
      ];
    });
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages![_selectedPageindex]['title']),
      ),
      drawer: MainDrawer(),
      body: _pages![_selectedPageindex]['Page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageindex,
        selectedItemColor: Theme.of(context).accentColor,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
            label: 'Kategorien',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            label: 'Favouriten',
          ),
        ],
      ),
    );
  }
}
