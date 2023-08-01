import 'package:app_xpox/providers/user_provider.dart';
import 'package:app_xpox/resourses/auth_methods.dart';
import 'package:app_xpox/screens/authentication_screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_xpox/models/user.dart' as model;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUsername();

    listenToChange();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            AuthMethods().signout();

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SigninScreen(),
              ),
            );
          },
          child: Row(
            children: [
              const Text(
                'HomePage',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Welcome ${user.email}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      username = (snap.data() as Map<String, dynamic>)['usernamr'];
    });

    print(
      snap.data(),
    );
  }

  void listenToChange() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }
}
