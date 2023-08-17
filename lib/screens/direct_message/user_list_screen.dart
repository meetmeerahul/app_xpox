import 'package:app_xpox/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:app_xpox/screens/direct_message/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool isShowUser = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () => Get.off(BottomNavScreen()),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Direct Meaasges',
            style: TextStyle(color: Colors.white),
          )),
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: TextFormField(
            autofocus: false,
            style: const TextStyle(color: Colors.white),
            controller: _searchController,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: const Icon(
                Icons.person,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              labelText: "Search",
              labelStyle: const TextStyle(
                color: Colors.white,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)
                      // Border color
                      ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white54, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            onFieldSubmitted: (String value) {
              setState(() {
                isShowUser = true;
              });
            },
          ),
        ),
        body: isShowUser
            ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: _searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No mathches found !!",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var userData = snapshot.data!.docs[index].data();

                      if (userData['uid'] !=
                          FirebaseAuth.instance.currentUser!.uid) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                              ChatScreen(
                                receiver: userData['uid'],
                                sender: FirebaseAuth.instance.currentUser!.uid,
                              ),
                            );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(userData['photoUrl']),
                            ),
                            title: Text(
                              "${userData['username']}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  );
                },
              )
            : FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance.collection('users').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var userData = snapshot.data!.docs[index].data();

                      if (userData['uid'] !=
                          FirebaseAuth.instance.currentUser!.uid) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                              ChatScreen(
                                sender: FirebaseAuth.instance.currentUser!.uid,
                                receiver: userData['uid'],
                              ),
                            );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(userData['photoUrl']),
                            ),
                            title: Text(
                              "${userData['username']}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                      return Container(
                        color: Colors.white,
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
