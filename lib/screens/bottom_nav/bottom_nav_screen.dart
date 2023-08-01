import 'package:app_xpox/screens/home/home_screen.dart';
import 'package:app_xpox/screens/search/search_screen.dart';
import 'package:flutter/material.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  List pages = [
    const HomeScreen(),
    const SearchScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[0],
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.red,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {},
          currentIndex: 1,
          items: const [
            BottomNavigationBarItem(label: '', icon: Icon(Icons.home_outlined)),
            BottomNavigationBarItem(label: '', icon: Icon(Icons.search)),
            BottomNavigationBarItem(label: '', icon: Icon(Icons.add)),
            BottomNavigationBarItem(
                label: '', icon: Icon(Icons.notifications_none)),
            BottomNavigationBarItem(
                label: '', icon: Icon(Icons.person_outlined))
          ]),
    );
  }
}
