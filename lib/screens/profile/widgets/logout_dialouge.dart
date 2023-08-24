import 'dart:async';

import 'package:app_xpox/resourses/auth_methods.dart';
import 'package:flutter/material.dart';

import '../../authentication_screens/signin_screen.dart';

showLogoutDialog(BuildContext context) {
  Widget yesButton = TextButton(
    child: const Text(
      "Yes",
    ),
    onPressed: () async {
      // setState(() {
      //   isQuit = true;
      // });

      await AuthMethods().signout();
      const Center(
        child: CircularProgressIndicator(backgroundColor: Colors.white),
      );
      Timer(const Duration(seconds: 5), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SigninScreen(),
          ),
        );
      });
    },
  );

  Widget noButton = TextButton(
    child: const Text(
      "No",
      style: TextStyle(color: Colors.black),
    ),
    onPressed: () {
      Navigator.of(context).pop(); // Close the dialog
    },
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    title: const Text("Logout", style: TextStyle(color: Colors.black)),
    content: const Text(
      "Are you sure you want to logout?",
      style: TextStyle(color: Colors.black),
    ),
    actions: [
      yesButton,
      noButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
