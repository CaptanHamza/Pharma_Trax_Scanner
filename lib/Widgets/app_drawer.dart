import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../utils/colors.dart';
import '../utils/globalValue.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}



class _AppDrawerState extends State<AppDrawer> {
  SharedPreferences? prefs;

  @override
  void initState() {
    
    super.initState();
    getSharePrefenceValue();
  }

  String? auth2;

  getSharePrefenceValue() async {
    prefs = await SharedPreferences.getInstance();
    String? getEmail = prefs!.getString('email').toString();
    log(getEmail.toString());

    setState(() {
      auth2 = getEmail;
    });
  }

// log(getdiffernce.inSeconds.toString());

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return SafeArea(
        child: Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        SizedBox(
          height: 180,
          child: DrawerHeader(
            decoration: const BoxDecoration(color: blueColor1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorPrimaryDarkes,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(5),
                  height: 60,
                  width: 70,
                  child: Image.asset("assets/images/splash_logo.png"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Title(
                    color: Colors.white,
                    child: const Text(
                      "PHARMA TRAX",
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  height: 5,
                ),
                Title(
                    color: Colors.white,
                    child: auth2 != null
                        ? Text("$auth2",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontWeight: FontWeight.normal,
                                fontSize: 12))
                        : Text(''))
              ],
            ),
          ),
        ),
        ListTile(
          selected: indexClicked == 0,
          selectedTileColor: textColor.withOpacity(0.2),
          leading: SizedBox(
            height: 24,
            width: 24,
            child: Image.asset(
              "assets/images/barcode_scanner.png",
              color: indexClicked == 0
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          title: Text(
            "Scan GS1 Barcode",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: indexClicked == 0
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          onTap: () {
            setState(() {
              indexClicked = 0;
            });
            Navigator.of(context).pushReplacementNamed('/home_screen');
          },
        ),
        ListTile(
          selected: indexClicked == 1,
          selectedTileColor: textColor.withOpacity(0.2),
          leading: SizedBox(
            height: 24,
            width: 24,
            child: Image.asset(
              "assets/images/history.png",
              color: indexClicked == 1
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          title: Text(
            "Scan History",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: indexClicked == 1
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          onTap: () {
            setState(() {
              indexClicked = 1;
            });
            Navigator.of(context).pushReplacementNamed('/scan_history');
          },
        ),


       

        ListTile(
          selected: indexClicked == 2,
          selectedTileColor: textColor.withOpacity(0.2),
          leading: SizedBox(
            height: 24,
            width: 24,
            child: Image.asset(
              "assets/images/update.png",
              color: indexClicked == 2
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          title: Text(
            "Update Database",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: indexClicked == 2
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          onTap: () {
            setState(() {
              indexClicked = 2;
            });
            Navigator.of(context).pushReplacementNamed('/update_database');
          },
        ),
         ListTile(
          selected: indexClicked == 8,
          selectedTileColor: textColor.withOpacity(0.2),
          leading: SizedBox(
            
            height: 28,
            width: 28,
            child: Image.asset(
              "assets/images/check_digit.png",
              
              color: indexClicked == 8  
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          title: Text(
            "Calculate Check Digit",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: indexClicked == 8
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          onTap: () {
            setState(() {
              indexClicked = 8;
            });
            Navigator.of(context).pushReplacementNamed('/check_digit');
          },
        ),


        ListTile(
          selected: indexClicked == 3,
          selectedTileColor: textColor.withOpacity(0.2),
          leading: SizedBox(
            height: 24,
            width: 24,
            child: Image.asset(
              "assets/images/sign_out.png",
              color: indexClicked == 3
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          title: Text(
            "Sign Out",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: indexClicked == 3
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          onTap: () {
            setState(() {
              indexClicked = 3;
            });

            auth.logout();
            Navigator.of(context).pushReplacementNamed('/signin_page');
          },
        ),
        const Divider(
          thickness: 1,
        ),
        const ListTile(
            leading: Text(
          "Pharma Trax Product Line",
          style: TextStyle(color: textColor),
        )),
        ListTile(
          selected: indexClicked == 4,
          selectedTileColor: textColor.withOpacity(0.2),
          leading: SizedBox(
            height: 24,
            width: 24,
            child: Image.asset(
              "assets/images/hardware.png",
              color: indexClicked == 4
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          title: Text(
            "Line Level Hardware",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: indexClicked == 4
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          onTap: () {
            setState(() {
              indexClicked = 4;
            });
            Navigator.of(context).pushReplacementNamed('/line_level_hardware');
          },
        ),
        ListTile(
          selected: indexClicked == 5,
          selectedTileColor: textColor.withOpacity(0.2),
          leading: SizedBox(
            height: 24,
            width: 24,
            child: Image.asset(
              "assets/images/equipment.png",
              color: indexClicked == 5
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          title: Text(
            "Line Equipment",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: indexClicked == 5
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          onTap: () {
            setState(() {
              indexClicked = 5;
            });
            Navigator.of(context).pushReplacementNamed('/line_equipment');
          },
        ),
        ListTile(
          selected: indexClicked == 6,
          selectedTileColor: textColor.withOpacity(0.2),
          leading: SizedBox(
            height: 24,
            width: 24,
            child: Image.asset(
              "assets/images/gears.png",
              color: indexClicked == 6
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          title: Text(
            "How it Works",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: indexClicked == 6
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          onTap: () {
            setState(() {
              indexClicked = 6;
            });
            Navigator.of(context).pushReplacementNamed('/how_it_works');
          },
        ),
        ListTile(
          selected: indexClicked == 7,
          selectedTileColor: textColor.withOpacity(0.2),
          leading: SizedBox(
            height: 24,
            width: 24,
            child: Image.asset(
              "assets/images/about.png",
              color: indexClicked == 7
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          title: Text(
            "About Pharma Trax",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: indexClicked == 7
                  ? colorPrimaryLightBlue
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          onTap: () {
            setState(() {
              indexClicked = 7;
            });
            Navigator.of(context).pushReplacementNamed('/about_pharma');
          },
        ),
      ]),
    ));
  }
}
