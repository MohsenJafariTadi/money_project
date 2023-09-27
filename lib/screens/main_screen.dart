import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:money_app/screens/home_screen.dart';
import 'package:money_app/screens/info_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentindex = 0;
  Widget body = HomeScreen();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        inactiveColor: Colors.black54,
        icons: const [Icons.home, Icons.info],
        activeIndex: currentindex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) {
          if (index == 0) {
            body = HomeScreen();
          } else {
            body = InfoScreen();
          }
          setState(() {
            currentindex = index;
          });
        },
      ),
      body: body,
    );
  }
}
