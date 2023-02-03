import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:pharma_trax_scanner/Widgets/app_drawer.dart';
import 'package:pharma_trax_scanner/Widgets/db_helper.dart';
import 'package:pharma_trax_scanner/providers/auth_provider.dart';
import 'package:pharma_trax_scanner/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/globalValue.dart';

class UpdateDatabase extends StatefulWidget {
  const UpdateDatabase({Key? key}) : super(key: key);

  static const routeName = '/update_database';

  @override
  State<UpdateDatabase> createState() => _UpdateDatabaseState();
}

class _UpdateDatabaseState extends State<UpdateDatabase> {
  final dbhelper = DataBaseHelper.instance;
  List<Map<String, dynamic>>? data = [];
  String? version;
  DateTime? updatedDate;
  String? formattedDate;

  @override
  void initState() {
    fatchData();
    super.initState();
  }

  Future<void> fatchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    version = prefs.getString("version");
    String? date = prefs.getString("updateTime");

    if (date != "") {
      updatedDate = DateTime.parse(date.toString());
      formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(updatedDate!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final auth = Provider.of<AuthProvider>(context);

    showLoading({String title = "Updating Database.."}) {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Row(
              children: [
                CircularProgressIndicator(),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  title,
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }

    hideLoading() {
      Get.back();
    }

    Future updateDatabase() async {
      showLoading();

      if (!await InternetConnectionChecker().hasConnection) {
        Fluttertoast.showToast(
          msg: 'No Internet',
        );
        hideLoading();
      } else {
     
      dynamic response =  await auth.getUpdateApiCall();
      Map getApiData = jsonDecode(response);
   




        hideLoading();
        Timer(Duration(milliseconds: 100), () async {
          fatchData();
        });
        
        if (getApiData['Info']['Status'] == -1) {
          Fluttertoast.showToast(msg: 'Something went wrong');
        } else if (getApiData['Info']['Status'] == 0) {
          Fluttertoast.showToast(msg: 'Already updated to latest version');
        }
         else if (getApiData['Info']['Status'] == 1 && version != "0") {
          Fluttertoast.showToast(msg: 'Updated to latest version');
        } else if (getApiData['Info']['Status'] == 6 || version == "0") {
          Fluttertoast.showToast(msg: 'Updated to latest version');
         
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
      }
    }

    Future<bool> _onWillPop() async {
            indexClicked = 0;
      await Navigator.of(context).pushReplacementNamed('/home_screen');
      return true;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: const AppDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: colorPrimaryLightBlue,
          title: const Text(
            "Update Database",
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image:
                  DecorationImage(image: AssetImage('assets/images/dna.png'))),
          width: _width,
          height: _height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Database Information',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: 'Database Version: ',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                          children: <InlineSpan>[
                            version == null
                                ? TextSpan()
                                : TextSpan(
                                    text: version,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: colorPrimaryLightBlue),
                                  )
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Updated At: ',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                          children: <InlineSpan>[
                            TextSpan(
                              text: formattedDate.toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: colorPrimaryLightBlue),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  width: _width * 0.8,
                  height: 60,
                  child: MaterialButton(
                    color: colorPrimaryLightBlue,
                    onPressed: updateDatabase,
                    // style: ButtonStyle(
                    //   backgroundColor: Co
                    // ),
                    child: const Text(
                      'UPDATE DATABASE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

mixin Auth {}
