import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/screens/category_screen.dart';
import 'package:meal_app_flutter/screens/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_meals_screen.dart';

/// This is the Screen which will show on the first ever startup of the app.
class IntroductionScreens extends StatefulWidget {
  static const routeName = '/intro';
  const IntroductionScreens({Key? key}) : super(key: key);

  @override
  State<IntroductionScreens> createState() => _IntroductionScreensState();
}

/// This is the state of the IntroductionScreens class.
class _IntroductionScreensState extends State<IntroductionScreens> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroductionScreen(
          globalBackgroundColor: Colors.lightGreen,
          pages: [
            PageViewModel(
              titleWidget: const Text(
                "Janinas Kochbuch",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
              bodyWidget: Column(
                children: const [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Janinas Kochbuch ist eine einfache App, um seine Rezepte zu digitalisieren und neue Rezepte hinzuzufügen.',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              titleWidget: const Text(
                "Was kannst du mit Janinas Kochbuch machen?",
                style: TextStyle(
                    color: Color(0xfb589a07),
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              bodyWidget: Column(
                children: const [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Erstelle neue Rezepte und gebe diesen ein Bild zum personalisieren.\n\nBearbeite oder lösche vorhandene Rezepte\n\nFilter deine Rezepte nach Kategorien und eigenen Präferenzen\n\nImportiere Rezepte direkt von Zucker&Jagdwurst\n\nSichere deine Rezepte ab, damit du immer ein Backup hast',
                    style: TextStyle(
                        color: Color(0xff05936f),
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              titleWidget: const Text(
                "Deine ersten Schritte",
                style: TextStyle(
                    color: Color(0xffb8c400),
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              bodyWidget: Column(
                children: const [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Erstelle ein Rezept\n\nKoche es nach\n\nGenieße das Essen\n\nHab viel Spaß! 🎉',
                    style: TextStyle(
                        color: Color(0xffde960d),
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
          ],

          /// This is the method which will be called when the user clicks on the done button. It will trigger the SharedPreferences to set the isInit value to true and then it will navigate to the FeedPage.
          onDone: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isInit', true);
            setState(() {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TabsScreen()));
            });
          },
          //ClampingScrollPhysics prevent the scroll offset from exceeding the bounds of the content.
          scrollPhysics: const ClampingScrollPhysics(),
          showDoneButton: true,
          showNextButton: true,
          showSkipButton: true,
          isBottomSafeArea: true,
          skip: const Text("Skip",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 20)),
          next: const Icon(
            Icons.forward,
            color: Colors.black,
            size: 30,
          ),
          done: const Text("Fertig",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 20)),
          dotsDecorator: getDotsDecorator()),
    );
  }

  /// Method to customise the page style
  PageDecoration getPageDecoration() {
    return const PageDecoration(
      imagePadding: EdgeInsets.only(top: 120),
      pageColor: Color.fromRGBO(255, 254, 229, 1),
      bodyPadding: EdgeInsets.only(top: 8, left: 20, right: 20),
      titlePadding: EdgeInsets.only(top: 50),
      bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 15),
    );
  }

  /// Method to customize the dots style
  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 2),
      activeColor: Colors.black,
      color: Colors.grey,
      activeSize: Size(15, 10),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }
}
