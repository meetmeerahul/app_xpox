import 'package:app_xpox/providers/user_provider.dart';
import 'package:app_xpox/screens/authentication_screens/signin_screen.dart';
import 'package:app_xpox/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/bottom_nav/bottom_nav_screen.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App_XpoX',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)
              .copyWith(background: Colors.black),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return BottomNavScreen();
              }
              if (snapshot.hasError) {
                showSnackbar(
                  context,
                  snapshot.error.toString(),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return const SigninScreen();
          },
        ),
      ),
    );
  }
}
