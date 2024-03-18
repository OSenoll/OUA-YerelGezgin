import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_solution_challenge/controller/controller.dart';
import 'package:google_solution_challenge/screens/home_screens/yerelGezgin/home_page.dart';
import 'package:google_solution_challenge/screens/home_screens/maps/map_custom.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class NavBar extends StatefulWidget {
  const NavBar({super.key});
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  double _latitude = 36.2025833;
  double _longitude = 36.1604033, distance = 0, _earthltt = 0, _earthlgt = 0;





  @override
  void initState() {
    super.initState();
  }

  final controller = Get.put(NavBarController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(builder: (context) {
        return Scaffold(
          body: IndexedStack(
            index: controller.tabIndex,
            children: [
              YerelGezginPage(), // Home page
              MapUIcustom(), // Map page
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: (Colors.blueGrey[300])!,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: GNav(
                selectedIndex: controller.tabIndex,
                onTabChange: controller.changeTabIndex,
                backgroundColor: (Colors.blueGrey[300])!,
                color: Colors.black,
                activeColor: Colors.white,
                tabBackgroundColor: const Color.fromARGB(43, 233, 125, 71),
                gap: 10.0,
                padding: const EdgeInsets.all(0.0),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: "Home",
                  ),
                  GButton(
                    icon: Icons.map,
                    text: "Maps",
                  ),
                ],
              ),
            ),
          ),
        );
    });
  }
}
