import 'package:app_xpox/utils/constants.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webLayout;
  final Widget mobileLayout;

  const ResponsiveLayout(
      {super.key, required this.webLayout, required this.mobileLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {

        return webLayout;
      }
      
      return mobileLayout;
    });
  }
}
