import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meal_app_flutter/dummy_data.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/models/meal.dart';
import 'package:meal_app_flutter/screens/meal_detail.dart';

class MealItem extends StatefulWidget {
  final String id, title;
  final String? imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final Function? callback;
  final List<String> categories, ingredients, steps;
  final Map<String, bool> filters;
  final String? categoryTitle, categoryId;

  MealItem({
    required this.id,
    required this.affordability,
    required this.complexity,
    required this.duration,
    required this.imageUrl,
    required this.title,
    required this.ingredients,
    required this.steps,
    required this.categories,
    required this.filters,
    this.categoryTitle,
    this.categoryId,
    this.callback,
  });

  @override
  State<MealItem> createState() => _MealItemState();
}

class _MealItemState extends State<MealItem> {
  var imagebytes = null;
  Future<bool> selectMeal(BuildContext context) async {
    //List<String> cat = await getMealCategories(categories);

    Navigator.of(context).pushNamed(MealDetailScreen.routeName, arguments: [
      widget.id,
      widget.callback,
      widget.affordability,
      widget.complexity,
      widget.duration,
      widget.imageUrl,
      widget.title,
      widget.ingredients,
      widget.steps,
      widget.categories,
      widget.filters
    ]).then((result) async {
      if (result != null) {
        if (widget.categoryTitle != null && widget.categoryId != null) {
          //var meals = await getAllMeals();
          var map = {
            "title": widget.categoryTitle!,
            "id": widget.categoryId!,
          }; // "meals": meals};
          Navigator.pushReplacementNamed(context, "/category-meals",
              arguments: map);
        } else {
          Navigator.pushReplacementNamed(context, "/all-meals");
        }
      }
      //if (result){
      //
      //}
    });
    return true;
  }

  String get complexityText {
    switch (widget.complexity) {
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

  loadImagebytes(String mealId) async {
    var image = await loadImage(mealId);
    setState(() {
      imagebytes = image;
    });
  }

  String get affordabilityText {
    switch (widget.affordability) {
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

  @override
  void initState() {
    if (widget.imageUrl == null) {
      loadImagebytes(widget.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await selectMeal(context);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: widget.imageUrl != null
                      ? Image.network(
                          widget.imageUrl!,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : imagebytes != null
                          ? Image.memory(imagebytes)
                          : const Icon(
                              Icons.image), //TODO: Await Image from File
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(
                        width: 6,
                      ),
                      Text('${widget.duration} min'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(MdiIcons.weight),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(complexityText),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.attach_money),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(affordabilityText),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
