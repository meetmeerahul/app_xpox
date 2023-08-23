import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedPostCard extends StatefulWidget {
  final snap;
  const SavedPostCard({super.key, required this.snap});

  @override
  State<SavedPostCard> createState() => _SavedPostCardState();
}

class _SavedPostCardState extends State<SavedPostCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('savedPost')
                  .doc(widget.snap['postId'])
                  .delete(),
              icon: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.white,
              ),
            )
          ],
        ),
        Image(image: NetworkImage(widget.snap['postUrl']))
      ],
    );
  }
}
