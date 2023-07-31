import 'package:app_xpox/utils/gradiant.dart';
import 'package:flutter/material.dart';

class WebLayout extends StatelessWidget {
  const WebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: getGradiant(),
        ),
        child: const Text('Weblayout'),
      ),
    );
  }
}
