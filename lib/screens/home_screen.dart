


import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pharma_trax_scanner/Widgets/db_helper.dart';
import 'package:pharma_trax_scanner/screens/barcode_scanner.dart';
import 'package:pharma_trax_scanner/screens/data_matrix_scanner.dart';
import 'package:pharma_trax_scanner/screens/signinpage.dart';
import 'package:pharma_trax_scanner/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Widgets/app_drawer.dart';

import '../providers/auth_provider.dart';
import '../utils/globalValue.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/home_screen';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final dbhelper = DataBaseHelper.instance;
  SharedPreferences? prefs;
  AuthProvider provider = AuthProvider();

  @override
  void initState() {
          indexClicked = 0;
    getSharePrefenceValue();
    checkDBUpdate();
    // SaveValueInPrefecnce();
    super.initState();
  }

  checkDBUpdate() async {
    prefs = await SharedPreferences.getInstance();
    String? date = prefs!.getString("updateTime");
    DateTime currentTime = DateTime.now();

    if (date != "") {
      DateTime updatedDate =
          DateTime.parse(date.toString()).add(Duration(days: 1));
      // String? formattedDate =
      //     DateFormat('yyyy-MM-dd hh:mm').format(updatedDate);
      if (updatedDate.compareTo(currentTime) <= 0) {
        await provider.getUpdateApiCall();
      }
    }
  }

  getSharePrefenceValue() async {
    prefs = await SharedPreferences.getInstance();
    String? getExpireSecond = prefs!.getString('isexpireSecond');
    String? getexpiryDate = prefs!.getString('iscurentTime');

    // log(getexpiryDate.toString());

    DateTime? now = DateTime.now();
    final getdiffernce = now.difference(DateTime.parse(getexpiryDate!));

    //log(getdiffernce.inSeconds.toString());

    if (getdiffernce.inSeconds >= double.parse(getExpireSecond!)) {
      LogoutFunction();
    }
  }

  LogoutFunction() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
    prefs.setString('istoken', '');
    prefs.setString('iscurentTime', '');
    prefs.setString('email', '');
    prefs.setString('isexpireSecond', '');

    // ignore: use_build_context_synchronously
    //Navigator.of(context).pop();
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => Signinpage()));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final auth = Provider.of<AuthProvider>(context);

    SaveValueInPrefecnce() async {
      prefs = await SharedPreferences.getInstance();
      prefs!.setBool('isLogin', true);
    }

    var width2 = MediaQuery.of(context).size.width;
    var height2 = MediaQuery.of(context).size.height;

    var padding = MediaQuery.of(context).padding;
    var safeHeight = height2 - padding.top - padding.bottom;

//log(safeHeight.toString());

    return Scaffold(
      key: _key,
      drawer: const AppDrawer(),
      drawerEnableOpenDragGesture: false,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: colorPrimaryLightBlue,
      //   onPressed: () {
      //     final box = context.findRenderObject() as RenderBox?;
      //     Share.share(
      //       "https://play.google.com/store/apps/details?id=pk.pharmatrax.pharmatraxscanner",
      //       sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      //     );
      //   },
      //   child: const Icon(
      //     Icons.share,
      //     color: Colors.white,
      //   ),
      // ),

      floatingActionButton: SpeedDial(
        childMargin: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        // icon: Icons.add,
        // animatedIcon: AnimatedIcons.close_menu,
        backgroundColor: colorPrimaryLightBlue,
        icon: Icons.share,
        activeIcon: Icons.close,
        childPadding: EdgeInsets.symmetric(vertical: 8),
        animationDuration: const Duration(milliseconds: 350),

        children: [
          SpeedDialChild(
              // child: const ImageIcon(AssetImage("assets/images/share.png"),
              child: Icon(Icons.apple, color: Colors.white),
              label: "Share IOS",
              labelStyle: const TextStyle(color: Colors.white),
              labelBackgroundColor: Colors.black,
              backgroundColor: sharebuttonColor,
              onTap: () async {
                final box = context.findRenderObject() as RenderBox?;
                await Share.share(
                    "https://apps.apple.com/pk/app/pharma-trax-scanner/id1444756129",
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size);
              }),
          SpeedDialChild(
              child: Icon(Icons.android,
                  // child: const ImageIcon(AssetImage("assets/images/share.png"),
                  color: Colors.white),
              label: "Share Android",
              labelStyle: const TextStyle(color: Colors.white),
              labelBackgroundColor: Colors.black,
              backgroundColor: screenshotbuttonColor,
              onTap: () async {
                final box = context.findRenderObject() as RenderBox?;
                await Share.share(
                    "https://play.google.com/store/apps/details?id=pk.pharmatrax.pharmatraxscanner",
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size);
              }),
        ],
      ),

      appBar: AppBar(
        backgroundColor: colorPrimaryLightBlue,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  }),
        ),
        title: const Text("Pharma Trax Scanner"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/dna.png'))),
        height: height,
        width: width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  // color: Colors.red,

                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        //color: Color,
                        child: Image.asset(
                          'assets/images/pharmatrax2.png',
                          height: safeHeight > 700
                              ? MediaQuery.of(context).size.height * 0.2 - 65
                              : MediaQuery.of(context).size.height * 0.2 - 40,
                        ),
                      ),
                      Text(
                        "Pakistan's first Track and Trace Serialization \nSolution Complete End to End Turnkey Solution\nMarket Leader in Track and Trace Solutions",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: textColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          PermissionStatus camerstatus = await Permission.camera.request();
                          if (camerstatus == PermissionStatus.granted) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const BarCodeScanner()));
                          }
                          if(camerstatus == PermissionStatus.denied){
                            Fluttertoast.showToast(msg: "You need to provide camera permission");
                          }
                           if(camerstatus == PermissionStatus.permanentlyDenied) {
                       openAppSettings();
                          }
                        },
                        child: Container(
                          color: colorPrimaryLightBlue,
                          width: MediaQuery.of(context).size.width * 0.7 - 10,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                height: 50,
                                width: 50,
                                color: colorPrimaryLightDark,
                                child:
                                    Image.asset('assets/images/code_128.png'),
                              ),
                              Expanded(
                                child: Text(
                                  "SCAN GS1 128 BARCODE",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                        PermissionStatus camerstatus = await Permission.camera.request();


                          if (camerstatus == PermissionStatus.granted) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => DataMatrixSacnner()));
                          }
                          if(camerstatus == PermissionStatus.denied){
                            Fluttertoast.showToast(msg: "You need to provide camera permission");
                          }
                           if(camerstatus == PermissionStatus.permanentlyDenied) {
                             PermissionStatus camerstatus = await Permission.camera.request();
                       openAppSettings();
                          }
                        },
                        child: Container(
                          color: colorPrimaryLightBlue,
                          width: MediaQuery.of(context).size.width * 0.7 - 10,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                height: 50,
                                width: 50,
                                color: colorPrimaryLightDark,
                                child: Image.asset(
                                    'assets/images/data_matrix.png'),
                              ),
                              Expanded(
                                child: Text(
                                  "SCAN GS1 DATA MATRIX",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "PHARMA TRAX",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: textColor,
                          fontSize: 15,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Contact us: ",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: textColor,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: "CONTACT@PHARMATRAX.PK",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: blueColor1,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    // ignore: deprecated_member_use
                                    await launch(
                                        "mailto:CONTACT@PHARMATRAX.PK?");
                                  }),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "WWW.PHARMATRAX.PK",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: blueColor1,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url = "https://WWW.PHARMATRAX.PK";
                              // ignore: deprecated_member_use
                              if (!await canLaunch(url)) {
                                // ignore: deprecated_member_use
                                await launch(url);
                              } else {
                                throw "Connot Load Url ";
                              }
                            },
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "WWW.ZAUQ.COM",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: blueColor1,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url = "https://WWW.ZAUQ.COM";
                              // ignore: deprecated_member_use
                              if (!await canLaunch(url)) {
                                // ignore: deprecated_member_use
                                await launch(url);
                              } else {
                                throw "Connot Load Url ";
                              }
                            },
                        ),
                      ),
                      Container(
                        height: safeHeight > 700
                            ? MediaQuery.of(context).size.height * 0.2 - 60
                            : MediaQuery.of(context).size.height * 0.2 - 40,
                        padding: EdgeInsets.symmetric(
                            horizontal: safeHeight > 700 ? 110 : 80,
                            vertical: 5),
                        // height: 120,
                        // width: 120,
                        child: Image.asset(
                          'assets/images/zauq.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
