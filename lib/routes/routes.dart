import 'package:google_solution_challenge/navbar/navbar.dart';
import 'package:google_solution_challenge/screens/profile/profile_screen.dart';
import 'package:get/get.dart';

class AppPage {
  static List<GetPage> routes = [
    GetPage(name: navbar, page: () => const NavBar()),
    GetPage(name: profile, page: () => const ProfileScreen()),
  ];

  static String navbar = "/";
  static String profile = "/profile";
  static String information = "/information";

  static getNavBar() => navbar;
  static getProfile() => profile;
  static getInformation() => information;
}
