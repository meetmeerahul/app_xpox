import 'package:app_xpox/controller/bottom_nav_controller.dart';
import 'package:app_xpox/screens/home/home_screen.dart';
import 'package:app_xpox/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final getIndex = Get.put(NavBarController());

  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    List pages = [
      const HomeScreen(),
      const SearchScreen(),
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
            BottomNavigationBarItem(label: '', icon: Icon(Icons.add)),
            BottomNavigationBarItem(
                label: '', icon: Icon(Icons.notifications_none)),
            BottomNavigationBarItem(
                label: '', icon: Icon(Icons.person_outlined))
          ],
        ),
      ),
    );
  }
}