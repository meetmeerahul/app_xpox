import 'package:app_xpox/utils/gradiant.dart';
import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: getGradiant(),
        ),
        child: const Center(child: Text('Mobile layout')),
      ),
    );
  }
}
