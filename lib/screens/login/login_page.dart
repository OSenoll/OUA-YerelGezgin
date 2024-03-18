import 'package:google_solution_challenge/screens/forgot_password.dart';
import 'package:google_solution_challenge/screens/register_page.dart';
import 'package:google_solution_challenge/services/auth_service.dart';
import 'package:google_solution_challenge/screens/login/service/login_service.dart';
import 'package:google_solution_challenge/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late AudioPlayer audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
  }


  void registerUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Yerel Gezgin",
                style: TextStyle(
                    fontFamily: "Quicksand",
                    fontSize: 46.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 48),
              buildTextField(Icons.email, emailController, LocaleKeys.Login_Page_email.tr(), false),
              const SizedBox(
                height: 20.0,
              ),
              buildTextField(Icons.lock, passwordController, LocaleKeys.Login_Page_password.tr(), true),
              const SizedBox(
                height: 40.0,
              ),
              buildLoginButton(() async {
                await FirebaseUserAuthentication.signIn(
                  email: emailController.text,
                  password: passwordController.text,
                  context: context,
                );
              }),
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
                        LocaleKeys.Login_Page_or.tr(),
                        style: const TextStyle(
                          color: Colors.black,
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
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.loginPageCreateAccount.tr(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  GestureDetector(
                    onTap: registerUser,
                    child: Text(
                      LocaleKeys.loginPageSignUp.tr(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: LocaleKeys.Login_Page_email.tr(),
        border: OutlineInputBorder(),
        prefixIcon: const Icon(Icons.email),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: LocaleKeys.Login_Page_password.tr(),
        border: OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        // Giriş işlemi burada
      },
      child: Text(LocaleKeys.loginPageSignIn.tr()),
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: const [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("or"),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Sosyal medya butonlarını buraya ekleyin
        IconButton(
          icon: const Icon(Icons.alternate_email),
          onPressed: () {
            // Google ile giriş yap
          },
        ),
      ],
    );
  }

  Widget _buildRegisterPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(LocaleKeys.loginPageCreateAccount.tr()),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RegisterPage()));
          },
          child: Text(LocaleKeys.loginPageSignUp.tr()),
        ),
      ],
    );
  }

  Padding buildLoginButton(Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          width: 150.0,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.0)),
          child: Center(
            child: Text(
              LocaleKeys.loginPageSignIn.tr(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildTextField(IconData icon, final controller, String hintText,
      bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[500]),
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

