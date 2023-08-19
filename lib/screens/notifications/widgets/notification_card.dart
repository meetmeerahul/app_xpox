import 'package:app_xpox/utils/spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    // model.User user = Provider.of<UserProvider>(context).getUser;

    print(widget.snap['owner']);
    print(FirebaseAuth.instance.currentUser!.uid);
    return widget.snap['owner'] == FirebaseAuth.instance.currentUser!.uid
        ? Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 23, // Adjust the radius as needed
                      backgroundImage: NetworkImage(widget.snap['profilePic']),
                    ),
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
                                    : widget.snap['text'] == "followed"
                                        ? const TextSpan(
                                            text: " started following you ",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        : const TextSpan(
                                            text: " Liked your post",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                              ]),
                            ),
                            getVerticalSpace(5),
                          ],
                        ),
                      ),
                    ),
                    widget.snap['text'] == "commented" ||
                            widget.snap['text'] == "liked"
                        ? ClipRRect(
                            child: Image.network(
                              widget.snap['postUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Text(""),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.white24,
              )
            ],
          )
        : Container();
  }
}
