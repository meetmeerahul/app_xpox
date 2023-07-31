import 'package:app_xpox/responsive/layout.dart';
import 'package:app_xpox/responsive/mobile_layout.dart';
import 'package:app_xpox/responsive/web_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'screens/authentication_screens/signin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAKCMgUoC0q_mWi8wpsYHj_ShP-wXbmaOw",
          appId: "1:745118102110:web:708b9d4376ff30dc053acf",
          messagingSenderId: "745118102110",
          projectId: "app-xpox",
          storageBucket: "app-xpox.appspot.com"),
    );
  } else {
    await Firebase.initializeApp();
  }
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
      home: const SigninScreen(),
    );
  }
}
