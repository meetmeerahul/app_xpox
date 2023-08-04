import 'dart:typed_data';

import 'package:app_xpox/models/user.dart' as model;
import 'package:app_xpox/resourses/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

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

        model.User user = model.User(
            email: email,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            username: username,
            bio: bio,
            followers: [],
            followings: []);

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        // await _firestore.collection('users').add({
        //   "uid": cred.user!.uid,
        //   "": username,
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
    } on FirebaseAuthException catch (err) {
      if (err.code == "user-not-found") {
        res = "User not registred";
      } else if (err.code == "wrong-password") {
        res = "Wrong password";
      }
    } catch (err) {
      print(err.toString());
    }

    return res;
  }

  signout() async {
    await _auth.signOut();
  }

  Future<String> resetPassword(String email) async {
    String res = "Some error occured";

    try {
      await _auth.sendPasswordResetEmail(email: email);
      res = "Success";
    } on FirebaseAuthException catch (err) {
      if (err.code == "user-not-found") {
        res = "User not registred";
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
  }
}
