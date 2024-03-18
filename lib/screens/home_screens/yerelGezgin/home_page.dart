import 'package:google_solution_challenge/screens/home_screens/yerelGezgin/post_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_solution_challenge/screens/profile/profile_screen.dart';
import 'package:google_solution_challenge/services/report_service.dart';
import 'package:google_solution_challenge/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class YerelGezginPage extends StatefulWidget {
  const YerelGezginPage({super.key});
  @override
  State<YerelGezginPage> createState() => _YerelGezginPageState();
}

class _YerelGezginPageState extends State<YerelGezginPage> {
  final ReportService _reportService = ReportService();

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person), // Profile girmek için olan buton
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
          color: Colors.blueGrey[900],

        ),
        backgroundColor: Colors.blueGrey[300],
        title: Center( // Programın isminin yazdığı kısım
          child: Text(
            LocaleKeys.yerelGezgin_title.tr(),
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.355,
              shadows: [
                const Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(150, 0, 0, 0),
                ),
              ],
            ),
          ),
        ),
        actions: [
        ],
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),

            child: Center(
              child: Text(
                LocaleKeys.yerelGezgin_reports.tr(), // Rapor isimleri
                style: const TextStyle(
                  fontFamily: "albertSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 29.0),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Divider(),
          ),

          StreamBuilder(
            stream: _reportService.getStatus(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) { // Herhangi bir veri yoksa sadece circular progress olsun.
                return const Center( // CircularProgressIndicator'ı merkeze al
                  child: SizedBox(
                    width: 40, // Yüklenme göstergesinin genişliği
                    height: 40, // Yüklenme göstergesinin yüksekliği
                    child: CircularProgressIndicator(
                      color: Color(0xffe97d47),
                    ),
                  ),
                );
              }
              else {
                return ListView.separated(
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(),
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot myReport = snapshot.data!.docs[index];

                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                        ),
                        margin: const EdgeInsets.fromLTRB(3, 0, 3, 9),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container( // Kullanıcı adı ve oluşturulma tarihi için yeni box
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[100],
                                // Bu box için farklı bir arka plan rengi
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                          "assets/images/profile_black.png"), // Bu asset değiştirilebilir.
                                      const SizedBox(width: 10),
                                      Text(
                                        myReport['user'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        myReport['createdAt'].toDate()),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 30),
                                  Text(
                                    myReport['status'],
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      height: 1.3625,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          GeoPoint point = myReport['location'];
                                          final Uri mapUri = Uri.parse(
                                              'https://www.google.com/maps/search/?api=1&query=${point
                                                  .latitude},${point
                                                  .longitude}');
                                          await _launchUrl(mapUri);
                                        },
                                        icon: const Icon(Icons.location_on),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        // Go to CartPage
        heroTag: "btn1",
        backgroundColor: Colors.grey[900],
        onPressed: () {
          showOptions(context);
        },
        elevation: 10.0, // Butona gölge ekler
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)), // Daha yuvarlak köşeler
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
