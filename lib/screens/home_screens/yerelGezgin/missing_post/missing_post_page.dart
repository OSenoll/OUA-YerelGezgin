import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_solution_challenge/screens/components/CustomSnackBarContent.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_solution_challenge/services/report_service.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: implementation_imports, unused_import
//import 'package:google_maps_place_picker_mb/src/google_map_place_picker.dart'; // do not import this yourself

// Only to control hybrid composition and the renderer in Android
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import '../../../../translations/locale_keys.g.dart';

class MissingPostPage extends StatefulWidget {

  MissingPostPage({super.key});

  static const kInitialPosition = LatLng(38.9637, 35.2433);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;

  @override
  State<MissingPostPage> createState() => _MissingPostPageState();
}

class _MissingPostPageState extends State<MissingPostPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String name = "";
  String surname = "";
  final ReportService _reportService = ReportService();
  final postController = TextEditingController();

  // for map
  PickResult? selectedPlace;
  String androidApiKey = "AIzaSyDqTggaCqOkh0DBWGiB3zXKO45ca9Lkq2c"; // API key for maps

  bool _mapsInitialized = false;
  final String _mapsRenderer = "latest";

  double _latitude = 0;
  double _longitude = 0;
  String _address = "";

  void initRenderer() {
    if (_mapsInitialized) return;
    if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
      switch (_mapsRenderer) {
        case "legacy":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.legacy);
          break;
        case "latest":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.latest);
          break;
      }
    }
    setState(() {
      _mapsInitialized = true;
    });
  }



  FirebaseDocument() async {
    var document = await db.collection('Person').doc(user.uid).get();
    Map<String, dynamic>? value = document.data();
    if (mounted && value != null) {
      setState(() {
        name = value['name'];
        surname = value['surname'];
      });
    }
  }

  void postReport() {
    if (selectedPlace != null) {
      setState(() {
        _latitude = selectedPlace!.geometry!.location.lat;
        _longitude = selectedPlace!.geometry!.location.lng;
        _address = selectedPlace!.formattedAddress!;
      });
    }
    _reportService
        .addStatus(
      postController.text,
      GeoPoint(_latitude, _longitude),
      _address,
      "$name $surname",
      DateTime.now(),
    )
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: CustomSnackBarContent(
          errorText: "Your post has been shared",
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ));
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseDocument();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        backgroundColor: Colors.blueGrey[300],
        title: Text(
          LocaleKeys.earthquaker_debris_page_create.tr(),
          style: GoogleFonts.prozaLibre(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.355,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            buildTextField(postController,
                LocaleKeys.earthquaker_debris_page_type.tr(), false),
            const SizedBox(
              height: 10.0,
            ),

            if (selectedPlace != null) ...[
              Text(selectedPlace!.formattedAddress!),
              Text("(lat: ${selectedPlace!.geometry!.location.lat}, lng: ${selectedPlace!.geometry!.location.lng})"),
            ],
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                initRenderer();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PlacePicker(
                        resizeToAvoidBottomInset:
                        false, // only works in page mode, less flickery
                        apiKey: androidApiKey,
                        hintText: "Find a place ...",
                        searchingText: "Please wait ...",
                        selectText: "Select place",
                        outsideOfPickAreaText: "Place not in area",
                        initialPosition: MissingPostPage.kInitialPosition,
                        useCurrentLocation: true,
                        selectInitialPosition: true,
                        usePinPointingSearch: true,
                        usePlaceDetailSearch: true,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                        },
                        onPlacePicked: (PickResult result) {
                          setState(() {
                            selectedPlace = result;
                            Navigator.of(context).pop();
                          });
                        },
                        onMapTypeChanged: (MapType mapType) {
                        },
                      );
                    },
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: Colors.black,
                margin: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    title: Text(
                      LocaleKeys.earthquaker_report_missing_location
                          .tr(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: postReport,
        icon: const Icon(Icons.save),
        label: Text(LocaleKeys.earthquaker_debris_page_post.tr()),
        backgroundColor: Colors.black,
      ),
    );
  }

  Padding buildTextField(final controller, String hintText, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        minLines: 1,
        maxLines: 7,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
        ),
      ),
    );
  }

  Padding buildButton(final Function()? onTap, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 20.0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 250.0,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12.0)),
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
