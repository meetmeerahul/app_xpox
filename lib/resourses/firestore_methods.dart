import 'dart:typed_data';

import 'package:app_xpox/models/post.dart';
import 'package:app_xpox/resourses/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = "Some error occured";

    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        "posts",
        file,
        true,
      );

      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: []);

      _firebaseFirestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
