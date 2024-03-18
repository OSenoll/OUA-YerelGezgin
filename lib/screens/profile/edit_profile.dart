import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_solution_challenge/translations/locale_keys.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final descriptionController = TextEditingController();
  var profileImage;

  String username = "";

  @override
  void initState() {
    super.initState();
    FirebaseDocument();
  }

  FirebaseDocument() async {
    var document = await db.collection('Person').doc(user.uid).get();
    Map<String, dynamic>? value = document.data();
    if (mounted && value != null) {
      setState(() {
        String a = value['name'] ?? ''; // name null ise boş string ata
        String b = value['surname'] ?? ''; // surname null ise boş string ata

        username = "$a $b";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          LocaleKeys.profileEdit.tr(),
          style: TextStyle(
            color: Colors.grey.shade800,
            fontFamily: "Raleway",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  username,
                  style: const TextStyle(
                      fontSize: 24, fontFamily: "Raleway", fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 20),
                child: buildTextField(descriptionController,
                    LocaleKeys.profileEditStatus.tr(), false),
              ),
              Text(LocaleKeys.profileEditPasswordChange.tr()),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: buildTextField(
                    descriptionController, LocaleKeys.profileEditPasswordNew.tr(), false),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 20),
                child: buildTextField(
                    descriptionController, LocaleKeys.profileEditPasswordConfirm.tr(), false),
              ),
              buildButton(() => null, LocaleKeys.profileEditConfirmAll.tr()),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildButton(final Function()? onTap, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 5.0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 250.0,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
              color: Colors.black,
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

  TextField buildTextField(
      final controller, String hintText, bool obscureText) {
    return TextField(
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
    );
  }
}
