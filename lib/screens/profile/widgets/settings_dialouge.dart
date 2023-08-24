import 'package:flutter/material.dart';

settingsDialouge(BuildContext context, String title, String content) {
  Widget backBtn = TextButton(
    child: const Text(
      "Back",
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    title: Text(title, style: const TextStyle(color: Colors.black)),
    content: SingleChildScrollView(
      child: Text(
        content,
        style: const TextStyle(color: Colors.black),
      ),
    ),
    actions: [
      backBtn,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
