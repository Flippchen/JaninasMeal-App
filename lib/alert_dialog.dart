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
