import 'package:flutter/material.dart';

getGradiant() {
  return const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 60, 8, 173),
      Color.fromARGB(255, 238, 3, 171),
    ],
  );
}
