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

  Future<void> followUsers(
    String uid,
    String followId,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firebaseFirestore.collection('users').doc(uid).get();
      List followings = (snap.data()! as dynamic)['followings'];

      if (followings.contains(followId)) {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'followings': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firebaseFirestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'followings': FieldValue.arrayUnion([followId])
        });
      }
    } catch (err) {
      print(
        err.toString(),
      );
    }
  }

  Future<void> likePost(String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> postComments(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'postId': postId,
          'text': text,
          'commentId': commentId,
          'name': name,
          'uid': uid,
          'datePublished': DateTime.now()
        });
      } else {
        print('Empty comment');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<String> deletePost(String postId) async {
    String res = "Error";

    print(postId);

    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();
      res = "Deleted";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateData(String newValue, String postId) async {
    // Get a reference to the document

    print(postId);
    print(newValue);
    String res = "error";
    DocumentReference docRef = _firebaseFirestore.doc('posts/$postId');

    try {
      // Update the specific field using the update method
      await docRef.update({'description': newValue});

      res = "Success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
