import 'package:app_xpox/responsive/layout.dart';
import 'package:app_xpox/responsive/mobile_layout.dart';
import 'package:app_xpox/responsive/web_layout.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App_XpoX',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)
            .copyWith(background: Colors.black),
      ),
      home: const ResponsiveLayout(
        webLayout: WebLayout(),
        mobileLayout: MobileLayout(),
      ),
    );
  }
}
