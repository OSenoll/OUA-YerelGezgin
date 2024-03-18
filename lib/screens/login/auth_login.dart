import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_solution_challenge/routes/routes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'login_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  double _latitude = 0;
  double _longitude = 0, distance = 0;
  double _earthltt = 0, _earthlgt = 0;

  late LatLng _currentPostion = const LatLng(38.9637, 35.2433);
  late GeoPoint _EarthPostion = const GeoPoint(36.2025833, 36.1604033);

  FirebaseDocument() async {
    var document = await db
        .collection('EarthquakeLocation')
        .doc("s8t9yU5SmtrKK8BWw7kr")
        .get();
    Map<String, dynamic>? value = document.data();
    if (value != null && mounted) {
      setState(() {
        var earthPosition = value['Hatay'];
        if (earthPosition != null && earthPosition is GeoPoint) {
          _earthltt = earthPosition.latitude;
          _earthlgt = earthPosition.longitude;
        }
      });
    }
  }

  double evalDistance(latitude, longitude, earthltt, earthlgt) {
    double dst = sqrt((earthltt - latitude) * (earthltt - latitude) +
        (earthlgt - longitude) * (earthlgt - longitude));
    return dst;
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));

    setState(() {
      _currentPostion = LatLng(position.latitude, position.longitude);
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  @override
  void initState() {
    _getUserLocation();
    FirebaseDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Kullanıcı girişinin başarılı olup olmadığını anlamak için kontrol sağlar.
        builder: (context, snapshot) {
          if (snapshot.hasData) { // Kullanıcının giriş yaptığını gösterir.
            return GetMaterialApp( // Kullanıcıyı ana ekrana yönlendirir.
              theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(secondary: Colors.blueGrey),
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: AppPage.getNavBar(), // NavBar() kısmına gönderiyor.
              getPages: AppPage.routes,
            );
          } else {
            return const MainPage();
          }
        },
      ),
    );
  }
}
