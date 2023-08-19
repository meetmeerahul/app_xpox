import 'package:app_xpox/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_xpox/models/user.dart' as model;

class NotificationCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const NotificationCard({super.key, required this.snap});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return widget.snap['owner'] == FirebaseAuth.instance.currentUser!.uid
        ? Container(
            padding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
            child: Row(
              children: [
                // ClipRRect(
                //   child: Image.network(
                //     widget.snap['profilePic'],
                //     width: 36,
                //     height: 36,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: widget.snap['name'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            widget.snap['text'] == "commented"
                                ? const TextSpan(
                                    text: " Commented on your post",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                : const TextSpan()
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
