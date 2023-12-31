import 'package:app_xpox/controller/bottom_nav_controller.dart';
import 'package:app_xpox/resourses/local_notifications.dart';
import 'package:app_xpox/screens/add_post/add_post_screen.dart';
import 'package:app_xpox/screens/home/home_screen.dart';
import 'package:app_xpox/screens/notifications/notification_screen.dart';
import 'package:app_xpox/screens/profile/profile_scree.dart';
import 'package:app_xpox/screens/search/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final getIndex = Get.put(NavBarController());

  int currentindex = 4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title);
      print(message.notification!.body);
      LocalNotificationService.display(message);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      const HomeScreen(),
      const SearchScreen(),
      const AddPostScreen(),
      const NotificationScreen(),
      ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
    ];

    return Scaffold(
      body: Obx(() => pages[getIndex.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.red,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            getIndex.onSelected(value);
            print(value);
          },
          currentIndex: getIndex.currentIndex.value,
          items: const [
            BottomNavigationBarItem(label: '', icon: Icon(Icons.home_outlined)),
            BottomNavigationBarItem(label: '', icon: Icon(Icons.search)),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.add_box_outlined),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.notifications_none),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.person_outlined),
            )
          ],
        ),
      ),
    );
  }
}
