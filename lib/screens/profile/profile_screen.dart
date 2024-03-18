import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_solution_challenge/models/languages.dart';
import 'package:google_solution_challenge/screens/login/service/login_service.dart';
import 'package:google_solution_challenge/screens/profile/edit_profile.dart';
import 'package:google_solution_challenge/screens/profile/sos_rev.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/report_service.dart';
import '../../translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  final ReportService _reportService = ReportService();
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String username = "";
  String description = "";
  int posts = 0;
  final String _language='';

  static String nullSafeStr(String source) => (source.isEmpty || source == "null") ? "" : source;

  signUserOut() async {
    await Provider.of<FirebaseUserAuthentication>(context, listen: false)
        .logout();
  }


  @override
  void initState() {
    super.initState();
    FirebaseDocument();
    postCount();
  }

  Future<void> _refresh() async {
    posts = 0;
    FirebaseDocument();
    postCount();
    return Future.delayed(const Duration(seconds: 1));
  }

  FirebaseDocument() async {
    var document = await db.collection('Person').doc(user.uid).get();
    Map<String, dynamic>? value = document.data();

    if (mounted && value != null) {
      setState(() {
        String a = value['name'] ?? ''; // name null ise boş string ata
        String b = value['surname'] ?? ''; // surname null ise boş string ata
        username = "$a $b";
        description = value['description'];
      });
    }
  }

  postCount() async {
    var document = await db.collection('Status').get();
    for (var i = 0; i < document.docs.length; i++) {
      if (document.docs[i]["user"] == username) {
        setState(() {
          posts++;
        });
      }
    }
  }

  void sos_mobile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SOSButton())); //SosMobile
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            LocaleKeys.profileScreenMyProfile.tr(),
            style: TextStyle(
              color: Colors.grey.shade800,
              fontFamily: "Raleway",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              underline: const SizedBox(),
              icon: const Icon(
                Icons.flag,
                color: Color.fromARGB(255, 123, 123, 123),
              ),
              onChanged: (Language? language) {
                context.setLocale(Locale(language!.languageCode));
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                  value: e,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        e.flag,
                        style: const TextStyle(fontSize: 30),
                      ),
                      Text(e.name)
                    ],
                  ),
                ),
              )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: signUserOut,
              icon: Icon(
                Icons.exit_to_app_sharp,
                color: Colors.grey.shade600,
              ),
            ),
          )
        ],
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
      body: RefreshIndicator(
        color: Colors.blueGrey,
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        username,
                        style: const TextStyle(
                            fontFamily: "Raleway", fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: Text(
                        "  Status\n$description",
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              posts.toString(),
                              style: const TextStyle(
                                  fontFamily: "Raleway",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20.0),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              LocaleKeys.Profile_profileScreen_Posts.tr(),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.w300,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildButton(
                            () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditProfilePage())),
                        LocaleKeys.Profile_profileScreen_EditProfile.tr()),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        LocaleKeys.language.tr(),
                        style: const TextStyle(
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Divider(
                        thickness: 1,
                        color: Colors.green[900],
                      ),
                    ),
                    StreamBuilder(
                      stream: _reportService.getStatus(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? const CircularProgressIndicator()
                            : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var itemCount = 0;
                            DocumentSnapshot myReport =
                            snapshot.data!.docs[index];
                            Future<void> showChoiceDialog(BuildContext) {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        LocaleKeys.Profile_profileScreen_deletePost.tr()),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    content: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () => _reportService
                                              .removeStatus(myReport.id)
                                              .then((value) =>
                                              Navigator.pop(
                                                  context)),
                                          child: Text(
                                            LocaleKeys.Profile_profileScreen_Yes.tr(),
                                            style: const TextStyle(
                                                color: Colors.blueGrey
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        InkWell(
                                          onTap: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            LocaleKeys.Profile_profileScreen_No.tr(),
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }


                            if (myReport['user'] == username) {
                              itemCount += 1;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                  ),
                                  margin: const EdgeInsets.fromLTRB(
                                      3, 0, 3, 9),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                    "assets/images/profile_black.png"),
                                                const SizedBox(width: 10),
                                                Text(
                                                  myReport['user'],
                                                  style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.w700,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Text(
                                              myReport['createdAt']
                                                  .toDate()
                                                  .toString()
                                                  .substring(0, 10),
                                              style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight.w700,
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          myReport['status'],
                                          style: GoogleFonts.nunitoSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            height: 1.3625,
                                            color: const Color(0xff000000),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon:
                                              const Icon(Icons.location_on),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  showChoiceDialog(
                                                      context),
                                              icon: const Icon(Icons.delete),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (index == snapshot.data!.docs.length - 1 &&
                                itemCount == 0) {
                              return Center(
                                child: Column(
                                  children: [
                                    Text('Profile_profileScreen_EndPost'.tr()),
                                    const SizedBox(
                                      height: 15.0,
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
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
