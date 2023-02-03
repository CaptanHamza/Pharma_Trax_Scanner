import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:pharma_trax_scanner/Widgets/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  SharedPreferences? prefs;

  bool? isLoginorNot = false;

  String? message;

  String? _token = '';
  DateTime? _expiryDate;
  int? _expirySecond;
  String? _userId = '';
  Timer? _authTimer;

  bool get isAuth {
    token != null;
    return true;
  }

  // hideLoading() {
  //   Get.back();
  // }

  dynamic get token {
    if (_expiryDate != 0 && _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId!;
  }

  Future<bool> login(String userId) async {
    var provinceBodyPayment = jsonEncode(<String, String>{
      'Email': userId.trim(),
      'Password': 'P@ssw0rd',
      'ConfirmPassword': 'P@ssw0rd',
    });
    print(provinceBodyPayment);
    try {
      bool result = await apiResponse(provinceBodyPayment, userId);
      if (result == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      print(e.toString());
      return false;
    }
  }

  Future<bool> apiResponse(String provinceBodyPayment, String getemail) async {
    if (!await InternetConnectionChecker().hasConnection) {
      Fluttertoast.showToast(
        msg: 'Internet Error',
      );
      return false;
    } else {
      try {
        http.Response response = await http.post(
            Uri.parse(
              'https://api.pharmasync.pk/api/account/register',
             // 'http://192.168.100.87:3003/api/account/register',
            ),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: provinceBodyPayment);

        if (response.statusCode == 200) {
          Map getResponseData = jsonDecode(response.body);

         // log(getResponseData.toString());
          _expirySecond = getResponseData['expires_in'];
          _token = getResponseData['access_token'];

          SharedPreferences prefs = await SharedPreferences.getInstance();

          String? getVersionValue = prefs.getString("version");
          if (getVersionValue == null) {
            prefs.setString('version', "0");
            prefs.setString('updateTime',
                DateTime.now().subtract(Duration(days: 7)).toIso8601String());
          }

          prefs.setBool('isLogin', true);
          prefs.setString('istoken', _token!);
          prefs.setString('isexpireSecond', _expirySecond.toString());
          prefs.setString('iscurentTime', DateTime.now().toIso8601String());
          prefs.setString('email', getemail);

          return true;
        } else {
          Fluttertoast.showToast(msg: 'Something went wrong');
          print("Response not 200");
          return false;
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Something went wrong');
        return false;
      }
    }
  }

 Future<dynamic>? getUpdateApiCall() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? version = prefs.getString("version");
      String? gettoken = prefs.getString('istoken');

      http.Response response = await http.get(
        Uri.parse(
           'https://api.pharmasync.pk/api/gtin',
         // 'http://192.168.100.87:3003/api/gtin',
        ),
        headers: <String, String>{
          'Authorization': 'Bearer ${gettoken}',
          'Version': version.toString(),
        },
      );

      if (response.statusCode == 200) {
        Map getApiData = jsonDecode(response.body);
      //  log(getApiData.toString());

        final dbhelper = DataBaseHelper.instance;
        List<Map<String, dynamic>> data = [];

        if (getApiData['Info']['Status'] == -1) {
         // Fluttertoast.showToast(msg: 'Something went wrong');
        } else if (getApiData['Info']['Status'] == 0) {
        //  Fluttertoast.showToast(msg: 'Already updated to latest version');
        } else if (getApiData['Info']['Status'] == 1 && version != "0") {
          Fluttertoast.showToast(msg: 'Updated to latest version');
          for (int i = 0; i < getApiData['Companies'].length; i++) {
            updateDbData(getApiData['Companies'][i]);
          }
          updateDBVersion(getApiData['Info']['Version'].toString());
        } else if (getApiData['Info']['Status'] == 6 || version == "0") {
          //Fluttertoast.showToast(msg: 'Updated to latest version');
          await dbhelper.deleteTable1();
          for (int i = 0; i < getApiData['Companies'].length; i++) {
            insertDbData(getApiData['Companies'][i]);
          }
          updateDBVersion(getApiData['Info']['Version'].toString());
        }
      } else {
       // Fluttertoast.showToast(msg: 'Something went wrong');
      }

      return response.body;
    } catch (e) {
    //  Fluttertoast.showToast(msg: 'Something went wrong');
      e.toString();
    }
  }

  // Insert Data in Database
  final dbhelper = DataBaseHelper.instance;

  void insertDbData(Map<String, dynamic> dbData) async {
    Map<String, dynamic> row = {
      DataBaseHelper.table1ColumnId: dbData['Id'],
      DataBaseHelper.table1ColumnPlain1: dbData['Pline1'],
      DataBaseHelper.table1ColumnCline3: dbData['Cline3'],
      DataBaseHelper.table1ColumnSline4: dbData['Sline4'],
      DataBaseHelper.table1ColumnVersion: dbData['Version'],
      DataBaseHelper.table1ColumnIsModified: dbData['IsModified']
    };
    final id = await dbhelper.insertTable1(row);
  }

  void updateDbData(Map<String, dynamic> dbData) async {
    Map<String, dynamic> row = {
      DataBaseHelper.table1ColumnId: dbData['Id'],
      DataBaseHelper.table1ColumnPlain1: dbData['Pline1'],
      DataBaseHelper.table1ColumnCline3: dbData['Cline3'],
      DataBaseHelper.table1ColumnSline4: dbData['Sline4'],
      DataBaseHelper.table1ColumnVersion: dbData['Version'],
      DataBaseHelper.table1ColumnIsModified: dbData['IsModified']
    };
    final id = await dbhelper.updateTable1(row);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
    prefs.setString('istoken', '');
    prefs.setString('iscurentTime', '');
    prefs.setString('email', '');
    prefs.setString('isexpireSecond', '');
  }

  Future<void> updateDBVersion(String version) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('version', version);
    prefs.setString('updateTime', DateTime.now().toIso8601String());
  }

// Future<bool?> CheckUserExist() async{
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return  (prefs.getBool('isLogin') == null) ? false : prefs.getBool('isLogin');

// }


















}
