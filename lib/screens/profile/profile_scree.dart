import 'dart:async';

import 'package:app_xpox/resourses/firestore_methods.dart';

import 'package:app_xpox/screens/edit_profile/edit_profile.dart';
import 'package:app_xpox/screens/profile/followers.dart';
import 'package:app_xpox/screens/profile/post_view.dart';
import 'package:app_xpox/screens/profile/saveed_posts.dart';
import 'package:app_xpox/screens/profile/widgets/settings.dart';
import 'package:app_xpox/screens/widgets/follow_button.dart';
import 'package:app_xpox/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/logout_dialouge.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late var userDetails;

  var userData = {};
  int postLen = 0;
  int followers = 0;
  int followings = 0;
  bool isFollowing = false;
  bool isLoading = false;

  late var userSnap;

  List<dynamic> followersTopass = [];

  List<dynamic> followingsToPass = [];

  bool isQuit = false;

  late DocumentSnapshot<Map<String, dynamic>> userSnapshot;
  late DocumentSnapshot<Map<String, dynamic>> currentUserSnapshot;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getData();
    getFollowers();
    getFollowings();
    print(userData);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              title: Text(
                userData['username'],
                style: const TextStyle(color: Colors.white),
              ),
              // leading: IconButton(
              //   onPressed: () => Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => BottomNavScreen(),
              //     ),
              //   ),
              //   icon: const Icon(
              //     Icons.arrow_back,
              //     color: Colors.white,
              //   ),
              // ),
              actions: [
                popUpButton(),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColum(postLen, "Posts"),
                                    InkWell(
                                        onTap: () => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FollowScreen(
                                                        followersList:
                                                            followersTopass,
                                                        uid: widget.uid),
                                              ),
                                            ),
                                        child: buildStatColum(
                                            followers, "Follwers")),
                                    InkWell(
                                        onTap: () => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FollowScreen(
                                                        followersList:
                                                            followingsToPass,
                                                        isFollowers: false,
                                                        uid: widget.uid),
                                              ),
                                            ),
                                        child: buildStatColum(
                                            followings, "Followings")),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: "Edit profile",
                                            backgroundColor: Colors.black,
                                            borderColor: Colors.white,
                                            textColor: Colors.white,
                                            function: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfileScreen(
                                                          snap: userDetails),
                                                ),
                                              );
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: "Unfollow",
                                                backgroundColor: Colors.white,
                                                borderColor: Colors.white,
                                                textColor: Colors.black,
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followUsers(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: "Follow",
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.white,
                                                textColor: Colors.white,
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followUsers(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  // print(
                                                  //     userSnap['profileImage']);

                                                  // // print(currentUserSnapshot[
                                                  // //     'profileImage']);
                                                  // // print(
                                                  // //     userSnap['profileImage']);

                                                  await FirestoreMethods()
                                                      .saveNotifications(
                                                          name:
                                                              currentUserSnapshot[
                                                                  'username'],
                                                          owner:
                                                              userData['uid'],
                                                          postId: "null",
                                                          postUrl: userSnap[
                                                              'photoUrl'],
                                                          profilePic:
                                                              currentUserSnapshot[
                                                                  'photoUrl'],
                                                          text: "followed",
                                                          uid: FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid);

                                                  setState(
                                                    () {
                                                      isFollowing = true;
                                                      followers++;
                                                    },
                                                  );
                                                },
                                              )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Divider(),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            );
                          }

                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PostView(snap: snap),
                                      ),
                                    );
                                  },
                                  child: Image(
                                    image: NetworkImage(snap['postUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Column buildStatColum(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      followers = userSnap.data()!['followers'].length;
      followings = userSnap.data()!['followings'].length;
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {
        userDetails = userSnap;
      });
    } catch (e) {
      showSnackbar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  popUpButton() {
    return PopupMenuButton(
      color: Colors.black,
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onSelected: (value) {
        if (value == 0) {
          Get.to(
            const SavedPosts(),
          );
        }
        if (value == 1) {
          Get.to(const SettingsPage());
        }
        if (value == 2) {
          showLogoutDialog(context);
        }
      }, // <-- Add a closing bracket here

      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            value: 0,
            child: Text(
              'Saved Posts',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text('Settings', style: TextStyle(color: Colors.white)),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('LogOut', style: TextStyle(color: Colors.white)),
          ),
        ];
      },
    );
  } // <-- Add a closing bracket here

  Future<void> getFollowers() async {
    try {
      userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget
              .uid) // Replace 'uid' with the actual user ID you want to fetch
          .get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Check if the 'username' field exists in the document
        if (userSnapshot.data()!.containsKey('username')) {
          List<dynamic> followers = userSnapshot['followers'];

          followersTopass = followers;
        } else {
          print("'username' field doesn't exist in the document.");
        }

        print('Full snapshot: $userSnapshot');
      } else {
        print('Document with the specified UID does not exist.');
      }
    } catch (error) {
      print('Error fetching followers: $error');
    }
  }

  Future<void> getFollowings() async {
    try {
      userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (userSnapshot.exists) {
        if (userSnapshot.data()!.containsKey('username')) {
          List<dynamic> followers = userSnapshot['followings'];

          followingsToPass = followers;
        } else {
          print("'username' field doesn't exist in the document.");
        }

        print('Full snapshot: $userSnapshot');
      } else {
        print('Document with the specified UID does not exist.');
      }
    } catch (error) {
      print('Error fetching followers: $error');
    }
  }

  Future<void> getCurrentUser() async {
    try {
      currentUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Check if the document exists
    } catch (error) {
      print('Error fetching followers: $error');
    }
  }
}
