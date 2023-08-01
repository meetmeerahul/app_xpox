import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List followings;

  User(
      {required this.email,
      required this.uid,
      required this.photoUrl,
      required this.username,
      required this.bio,
      required this.followers,
      required this.followings});

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "photoUrl": photoUrl,
        "username": username,
        "bio": bio,
        "follwers": followers,
        "followings": followings,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['usernamr'],
      bio: snapshot['bio'],
      email: snapshot['email'],
      followers: snapshot['followers'],
      followings: snapshot['followings'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}
