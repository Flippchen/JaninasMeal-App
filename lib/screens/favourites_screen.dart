import 'package:flutter/material.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/widgets/meal_item.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData && !snapshot.data.isEmpty) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return MealItem(
                id: snapshot.data![index].id,
                title: snapshot.data![index].title,
                imageUrl: snapshot.data![index].imageUrl,
                duration: snapshot.data![index].duration,
                affordability: snapshot.data![index].affordability,
                complexity: snapshot.data![index].complexity,
                steps: snapshot.data![index].steps,
                ingredients: snapshot.data![index].ingredients,
                categories: snapshot.data![index].categories,
                callback: () => setState(() {}),
                filters: {
                  "gluten": snapshot.data![index].isGlutenFree,
                  "lactose": snapshot.data![index].isLactoseFree,
                  "vegan": snapshot.data![index].isVegan,
                  "vegetarian": snapshot.data![index].isVegetarian
                },
              );
            },
          );
        } else if (snapshot.hasData && snapshot.data.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('Favoriten'),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      future: getAllFavouriteMeals(),
    );
  }
}
