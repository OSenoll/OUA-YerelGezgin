import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_solution_challenge/services/sos_mobile_service.dart';
import 'package:google_solution_challenge/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class SOSButton extends StatefulWidget {
  const SOSButton({super.key});

  @override
  State<SOSButton> createState() => _SOSButtonState();
}


class _SOSButtonState extends State<SOSButton> with SingleTickerProviderStateMixin {

  static double? _latitude;
  static double? _longitude;
  final SosMobileService _reportService = SosMobileService();
  var currentLocation;
  late bool serviceEnabled;
  late LocationPermission permission;
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String name = "";
  String surname = "";

  AnimationController? _animationController;
  Animation<double>? _buttonScale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.9).animate(_animationController!);
  }

  FirebaseDocument() async {
    var document = await db.collection('Person').doc(user.uid).get();
    Map<String, dynamic>? value = document.data();
    if(mounted) {
      setState(() {
        name = value!['name'];
        surname = value['surname'];
      });
    }
  }  

  void sosSent() {
    showDialog(
      context: context, // Burada hata çıkıyor hala.
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(148, 233, 125, 71),
          title: Text(
            LocaleKeys.Profile_sosMobile_sosCall.tr(),
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        );
      }
    );
  }

  void warnMessage(BuildContext context,latitude,longitude) {
    FirebaseDocument();
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(LocaleKeys.Profile_sosMobile_Cancel.tr(), style: const TextStyle(color: Colors.white, fontSize: 24),),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop();    
      },
    );
    Widget continueButton = TextButton(
      child: Text(LocaleKeys.Profile_sosMobile_Continue.tr(), style: const TextStyle(color: Colors.white, fontSize: 24),),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop();
        sendSosMessage(latitude,longitude); // Send SOS message if key pressed
        Navigator.pop(context);
        
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey,
      content: SizedBox(
        width: MediaQuery.of(context).size.width-20,
        height: MediaQuery.of(context).size.height/8,),
      title: Text(
        LocaleKeys.Profile_sosMobile_AreuSure.tr(),
        style: const TextStyle(color: Colors.white, fontSize: 24),
        textAlign: TextAlign.center,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }

  Future<void> sendSosMessage(latitude,longitude) async {
    FirebaseDocument();

    _reportService
        .addStatus("Please help me!",
                  ("$name $surname"),
                  GeoPoint(latitude, longitude),
        ).then((value) {
          sosSent();
    });
  
  }

  Future<Position> _getCurrentLocation() async{

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled){
      return Future.error(LocaleKeys.Profile_sosMobile_locationDisable.tr());
    }

    LocationPermission permission =await Geolocator.checkPermission();

    if(permission==LocationPermission.denied){
      permission= await Geolocator.requestPermission();
      if (permission==LocationPermission.denied){
        return Future.error(LocaleKeys.Profile_sosMobile_locationDisable.tr());
      }
    }

    if(permission==LocationPermission.deniedForever){
      return Future.error(LocaleKeys.Profile_sosMobile_locationDisablePer.tr());
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController?.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController?.reverse();
  }

  Widget _buildSOSButton() {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: () {
        // Trigger the location fetching and SOS message sending process here
        _getCurrentLocation().then((position) {
          if (mounted) {
            setState(() {
              _latitude = position.latitude;
              _longitude = position.longitude;
            });
            FirebaseDocument();
            warnMessage(context, _latitude, _longitude);
          }
        });
      },
      child: ScaleTransition(
        scale: _buttonScale!,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Adjust the color opacity
                spreadRadius: 2, // Spread radius
                blurRadius: 10, // Blur radius
                offset: Offset(0, 16), // changes position of shadow
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 80,
            backgroundColor: Colors.red,
            child: Icon(Icons.warning, size: 80, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        elevation: 10,
        title: Text(
          "SOS Button",
          style: GoogleFonts.albertSans(
            color: Colors.grey[900],
            fontSize: 29,
            fontWeight: FontWeight.bold,
            height: 1.355,
          )
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context)=> SimpleDialog(
                      title: Text("SOS Button Info"),
                      contentPadding: const EdgeInsets.all(20.0),
                      backgroundColor: Colors.blueGrey,
                      children: [
                        Text("Use this when needed!"),
                        TextButton(
                          onPressed:() {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],

                    )
                );
              },
              child: const Icon(
                Icons.info_outline,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    _buildSOSButton(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  LocaleKeys.Profile_sosMobile_emergency.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey,
    );
  }
}