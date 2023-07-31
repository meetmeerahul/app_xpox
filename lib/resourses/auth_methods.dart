// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:app_xpox/resourses/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error has been occured";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //Registering user

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        await _firestore.collection('users').doc(cred.user!.uid).set({
          "uid": cred.user!.uid,
          "usernamr": username,
          "password": password,
          "bio": bio,
          "email": email,
          "followers": [],
          "followings": [],
          "photoUrl": photoUrl,
        });

        // await _firestore.collection('users').add({
        //   "uid": cred.user!.uid,
        //   "usernamr": username,
        //   "password": password,
        //   "bio": bio,
        //   "email": email,
        //   "followers": [],
        //   "followings": [],
        // });
        //Store the remaining details in database
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> signinuser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (password.isNotEmpty || email.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "Success";
      } else {
        res = "Please fill all fields";
      }
    } catch (err) {
      print(err.toString());
    }

    return res;
  }
}
