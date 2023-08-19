import 'package:app_xpox/providers/user_provider.dart';
import 'package:app_xpox/screens/direct_message/user_list_screen.dart';
import 'package:app_xpox/screens/home/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:app_xpox/models/user.dart' as model;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";

  @override
  void initState() {
    super.initState();

    getUsername();
    listenToChange();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    print(user);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Image(
          image: AssetImage('assets/logo.png'),
          width: 100,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(
                  const UserListScreen(),
                );
              },
              icon: const Icon(
                Icons.message_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              username.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No posts available."),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }

  getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'];
    });

    print(
      snap.data(),
    );
  }

  listenToChange() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }
}
