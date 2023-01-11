import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String title, String content) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
showLoveDialog(BuildContext context, String title, String content) {
  // set up the button
  Widget okButton = TextButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(const Color(0xFF38313F)),
    ),
    child: Text("❤️"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: const Color(0xFF851E2D),
    title: Text(title,style: TextStyle(color: const Color(0xFFDCCBE3))),
    content: Text(content, style: TextStyle(color: const Color(0xFFDCCBE3)),),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    barrierColor: const Color(0xFF9038DC),
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class AlertWidget extends StatelessWidget {
  AlertWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rezept löschen'),
      content: const Text('Möchtest du das Rezept unwiderruflich löschen?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Nein'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: const Text('Ja'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}

