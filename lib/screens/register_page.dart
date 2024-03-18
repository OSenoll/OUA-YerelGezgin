import 'package:google_solution_challenge/services/auth_service.dart';
import 'package:google_solution_challenge/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final descriptionController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> createPerson(String name, String surname, String email,
      String password, String description) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);


    await _firestore.collection("Person").doc(user.user?.uid).set({
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      'description': description,
    });

    return user.user;
  }

  signUserUp() async {
    try {
      if (passwordController.text == confirmPasswordController.text) {
        createPerson(
          nameController.text,
          surnameController.text,
          emailController.text,
          passwordController.text,
          descriptionController.text
        );
        Navigator.pop(context);
      } else if (passwordController.text != confirmPasswordController.text) {
        notConfirmedMessage();
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF4E6C50),
          title: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  void notConfirmedMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF4E6C50),
          title: Text(
            LocaleKeys.Register_pswrdMatch.tr(),
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.blueGrey,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Yerel Gezgin",
                    style: TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 46.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    LocaleKeys.Register_RegisterPage.tr(),
                    style: const TextStyle(
                      fontFamily: "Source Sans Pro",
                      fontSize: 15.0,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 200.0,
                    child: Divider(
                      color: Colors.grey.shade200,
                      thickness: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: buildTextField(nameController, LocaleKeys.Register_Name.tr(), false)),
                      Expanded(
                          child: buildTextField(
                              surnameController, LocaleKeys.Register_Surname.tr(), false)),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  buildTextField(emailController, LocaleKeys.Register_email.tr(), false),
                  const SizedBox(
                    height: 20.0,
                  ),
                  buildTextField(descriptionController,
                      LocaleKeys.Register_description.tr(), false), // status
                  const SizedBox(
                    height: 20.0,
                  ),
                  buildTextField(passwordController, LocaleKeys.Register_Password.tr(), true),
                  const SizedBox(
                    height: 20.0,
                  ),
                  buildTextField(
                      confirmPasswordController, LocaleKeys.Register_ConfirmPassword.tr(), true),
                  const SizedBox(
                    height: 20.0,
                  ),
                  buildButton(signUserUp),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            LocaleKeys.Register_or.tr(),
                            style: const TextStyle(
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => AuthService().signInWithGoogle(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 50.0,
                          child: Image.asset("assets/images/google.png"),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.Register_already.tr(),
                        style: const TextStyle(
                          color:  Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          LocaleKeys.Register_logIn.tr(),
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Padding buildButton(Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          width: 100.0,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12.0)),
          child: Center(
            child: Text(
              LocaleKeys.Register_signIn.tr(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildTextField(final controller, String hintText, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
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
}
