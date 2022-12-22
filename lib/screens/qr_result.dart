import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pharma_trax_scanner/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pharma_trax_scanner/Widgets/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRCodeResultScreen extends StatefulWidget {
  String? qrCode;
  String? typeText;
  bool? isScanFile;
  String? rawByteCode;
  QRCodeResultScreen(this.qrCode, this.typeText, this.isScanFile,
      {Key? key, this.rawByteCode})
      : super(key: key);

  @override
  State<QRCodeResultScreen> createState() => _QRCodeResultScreenState();
}

class _QRCodeResultScreenState extends State<QRCodeResultScreen> {
  List<Map<String, dynamic>> map = [
    {'identifer': "00", 'title': "SSCC", 'length': 18},
    {'identifer': "01", 'title': "GTIN", 'length': 14},
    {'identifer': "02", 'title': "CONTENT", 'length': 14},
    {
      'identifer': "10",
      'title': "BATCH/LOT",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {'identifer': "11", 'title': "PROD DATE", 'length': 6},
    {'identifer': "12", 'title': "DUE DATE", 'length': 6},
    {'identifer': "13", 'title': "PACK DATE", 'length': 6},
    {'identifer': "15", 'title': "BEST BY", 'length': 6},
    {'identifer': "16", 'title': "SELL BY", 'length': 6},
    {'identifer': "17", 'title': "EXPIRY", 'length': 6},
    {'identifer': "20", 'title': "VARIANT", 'length': 2},
    {
      'identifer': "21",
      'title': "SERIAL",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "22",
      'title': "CPV",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "240",
      'title': "ADDITIONAL ID",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "241",
      'title': "CUST. PART NO.",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "242",
      'title': "MTO VARIANT",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "243",
      'title': "PCN",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "250",
      'title': "SECONDARY SERIAL",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "251",
      'title': "REF. TO SOURCE",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "253",
      'title': "GDTI",
      "minimumLength": 13,
      "maximumLength": 30
    },
    {
      'identifer': "254",
      'title': "GLN EXTENSION COMPONENT",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "255",
      'title': "GCN",
      "minimumLength": 13,
      "maximumLength": 25
    },
    {
      'identifer': "30",
      'title': "VAR. COUNT",
      "minimumLength": 1,
      "maximumLength": 8
    },
    {'identifer': "310n", 'title': "NET WEIGHT (kg)", 'length': 6},
    {'identifer': "311n", 'title': "LENGTH (m)", 'length': 6},
    {'identifer': "312n", 'title': "WIDTH (m)", 'length': 6},
    {'identifer': "313n", 'title': "HEIGHT (m)", 'length': 6},
    {'identifer': "314n", 'title': "AREA (m2)", 'length': 6},
    {'identifer': "315n", 'title': "NET VOLUME (l)", 'length': 6},
    {'identifer': "316n", 'title': "NET VOLUME (m3)", 'length': 6},
    {'identifer': "320n", 'title': "NET WEIGHT (lb)", 'length': 6},
    {'identifer': "321n", 'title': "LENGTH (i)", 'length': 6},
    {'identifer': "322n", 'title': "LENGTH (f)", 'length': 6},
    {'identifer': "323n", 'title': "LENGTH (y)", 'length': 6},
    {'identifer': "324n", 'title': "WIDTH (i)", 'length': 6},
    {'identifer': "325n", 'title': "WIDTH (f)", 'length': 6},
    {'identifer': "326n", 'title': "WIDTH (y)", 'length': 6},
    {'identifer': "327n", 'title': "HEIGHT (i)", 'length': 6},
    {'identifer': "328n", 'title': "HEIGHT (f)", 'length': 6},
    {'identifer': "329n", 'title': "HEIGHT (y)", 'length': 6},
    {'identifer': "330n", 'title': " GROSS WEIGHT (kg)", 'length': 6},
    {'identifer': "331n", 'title': "LENGTH (m), log", 'length': 6},
    {'identifer': "332n", 'title': "WIDTH (m), log", 'length': 6},
    {'identifer': "333n", 'title': "HEIGHT (m), log", 'length': 6},
    {'identifer': "334n", 'title': "AREA (m2), log", 'length': 6},
    {'identifer': "335n", 'title': "VOLUME (l), log", 'length': 6},
    {'identifer': "336n", 'title': "VOLUME (m3), log", 'length': 6},
    {'identifer': "337n", 'title': "KG PER m²", 'length': 6},
    {'identifer': "340n", 'title': "GROSS WEIGHT (lb)", 'length': 6},
    {'identifer': "341n", 'title': "LENGTH (i), log", 'length': 6},
    {'identifer': "342n", 'title': "LENGTH (f), log", 'length': 6},
    {'identifer': "343n", 'title': "LENGTH (y), log", 'length': 6},
    {'identifer': "344n", 'title': "WIDTH (i), log", 'length': 6},
    {'identifer': "345n", 'title': "WIDTH (f), log", 'length': 6},
    {'identifer': "346n", 'title': "WIDTH (y), log", 'length': 6},
    {'identifer': "347n", 'title': "HEIGHT (i), log", 'length': 6},
    {'identifer': "348n", 'title': "HEIGHT (f), log", 'length': 6},
    {'identifer': "349n", 'title': "HEIGHT (y), log", 'length': 6},
    {'identifer': "350n", 'title': "AREA (i2)", 'length': 6},
    {'identifer': "351n", 'title': "AREA (f2)", 'length': 6},
    {'identifer': "352n", 'title': "AREA (y2)", 'length': 6},
    {'identifer': "353n", 'title': "AREA (i2), log", 'length': 6},
    {'identifer': "354n", 'title': "AREA (f2), log", 'length': 6},
    {'identifer': "355n", 'title': "AREA (y2), log", 'length': 6},
    {'identifer': "356n", 'title': "NET WEIGHT (t)", 'length': 6},
    {'identifer': "357n", 'title': "NET VOLUME (oz)", 'length': 6},
    {'identifer': "360n", 'title': "NET VOLUME (q)", 'length': 6},
    {'identifer': "361n", 'title': "NET VOLUME (g)", 'length': 6},
    {'identifer': "362n", 'title': "VOLUME (q), log", 'length': 6},
    {'identifer': "363n", 'title': "VOLUME (g), log", 'length': 6},
    {'identifer': "364n", 'title': "VOLUME (i3)", 'length': 6},
    {'identifer': "365n", 'title': "VOLUME (f3)", 'length': 6},
    {'identifer': "366n", 'title': "VOLUME (y3)", 'length': 6},
    {'identifer': "367n", 'title': "VOLUME (i3), log", 'length': 6},
    {'identifer': "368n", 'title': "VOLUME (f3), log", 'length': 6},
    {'identifer': "369n", 'title': "VOLUME (y3), log", 'length': 6},
    {
      'identifer': "37",
      'title': "COUNT",
      "minimumLength": 1,
      "maximumLength": 8
    },
    {
      'identifer': "390n",
      'title': "AMOUNT",
      "minimumLength": 1,
      "maximumLength": 15
    },
    {
      'identifer': "391n",
      'title': "AMOUNT",
      "minimumLength": 3,
      "maximumLength": 18
    },
    {
      'identifer': "392n",
      'title': "PRICE",
      "minimumLength": 1,
      "maximumLength": 15
    },
    {
      'identifer': "393n",
      'title': "PRICE",
      "minimumLength": 3,
      "maximumLength": 18
    },
    {
      'identifer': "394n",
      'title': "PRCNT OFF",
      'length': 4,
      "requiredFNC1": true
    },
    {
      'identifer': "400",
      'title': "ORDER NUMBER",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "401",
      'title': "GINC",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {'identifer': "402", 'title': "GSIN", 'length': 17, "requiredFNC1": true},
    {
      'identifer': "403",
      'title': "ROUTE",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {'identifer': "410", 'title': "SHIP TO LOC", 'length': 13},
    {'identifer': "411", 'title': "BILL TO", 'length': 13},
    {'identifer': "412", 'title': "PURCHASE FROM", 'length': 13},
    {'identifer': "413", 'title': "SHIP FOR LOC", 'length': 13},
    {'identifer': "414", 'title': "LOC No", 'length': 13},
    {'identifer': "415", 'title': "PAY TO", 'length': 13},
    {'identifer': "416", 'title': "PROD/SERV LOC", 'length': 13},
    {
      'identifer': "420",
      'title': "SHIP TO POST",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "421",
      'title': "SHIP TO POST",
      "minimumLength": 3,
      "maximumLength": 12
    },
    {'identifer': "422", 'title': "ORIGIN", 'length': 3, "requiredFNC1": true},
    {
      'identifer': "423",
      'title': "COUNTRY - INITIAL PROCESS.",
      "minimumLength": 3,
      "maximumLength": 15
    },
    {
      'identifer': "424",
      'title': "COUNTRY - PROCESS.",
      'length': 3,
      "requiredFNC1": true
    },
    {
      'identifer': "425",
      'title': "COUNTRY - DISASSEMBLY",
      "minimumLength": 3,
      "maximumLength": 15
    },
    {
      'identifer': "426",
      'title': "COUNTRY – FULL PROCESS",
      'length': 3,
      "requiredFNC1": true
    },
    {
      'identifer': "427",
      'title': "ORIGIN SUBDIVISION",
      "minimumLength": 1,
      "maximumLength": 3
    },
    {'identifer': "7001", 'title': "NSN", 'length': 13, "requiredFNC1": true},
    {
      'identifer': "7002",
      'title': "MEAT CUT",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "7003",
      'title': "EXPIRY TIME",
      'length': 10,
      "requiredFNC1": true
    },
    {
      'identifer': "7004",
      'title': "ACTIVE POTENCY",
      "minimumLength": 1,
      "maximumLength": 4
    },
    {
      'identifer': "7005",
      'title': "CATCH AREA",
      "minimumLength": 1,
      "maximumLength": 12
    },
    {
      'identifer': "7006",
      'title': "FIRST FREEZE DATE",
      'length': 6,
      "requiredFNC1": true
    },
    {
      'identifer': "7007",
      'title': "HARVEST DATE",
      "minimumLength": 6,
      "maximumLength": 12
    },
    {
      'identifer': "7008",
      'title': "AQUATIC SPECIES",
      "minimumLength": 1,
      "maximumLength": 3
    },
    {
      'identifer': "7009",
      'title': "FISHING GEAR TYPE",
      "minimumLength": 1,
      "maximumLength": 10
    },
    {
      'identifer': "7010",
      'title': "PROD METHOD",
      "minimumLength": 1,
      "maximumLength": 2
    },
    {
      'identifer': "7020",
      'title': "REFURB LOT",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "7021",
      'title': "FUNC STAT",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "7022",
      'title': "REV STAT",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "7023",
      'title': "GIAI – ASSEMBLY",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "703s",
      'title': "PROCESSOR # s",
      "minimumLength": 3,
      "maximumLength": 30
    },
    {
      'identifer': "710",
      'title': "NHRN PZN",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "711",
      'title': "NHRN CIP",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "712",
      'title': "NHRN CN",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "713",
      'title': "NHRN DRN",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "714",
      'title': "NHRN AIM",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "...",
      'title': "NHRN xxx",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "8001",
      'title': "DIMENSIONS",
      'length': 14,
      "requiredFNC1": true
    },
    {
      'identifer': "8002",
      'title': "CMT No",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "8003",
      'title': "GRAI",
      "minimumLength": 14,
      "maximumLength": 30
    },
    {
      'identifer': "8004",
      'title': "GIAI",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "8005",
      'title': "PRICE PER UNIT",
      'length': 6,
      "requiredFNC1": true
    },
    {
      'identifer': "8006",
      'title': "ITIP or GCTIN",
      'length': 18,
      "requiredFNC1": true
    },
    {
      'identifer': "8007",
      'title': "IBAN",
      "minimumLength": 1,
      "maximumLength": 34
    },
    {
      'identifer': "8008",
      'title': "PROD TIME",
      "minimumLength": 8,
      "maximumLength": 12
    },
    {
      'identifer': "8010",
      'title': "CPID",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "8011",
      'title': "CPID SERIAL",
      "minimumLength": 1,
      "maximumLength": 12
    },
    {
      'identifer': "8012",
      'title': "VERSION",
      "minimumLength": 1,
      "maximumLength": 20
    },
    {
      'identifer': "8013",
      'title': "GMN or BUDI-DI",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "8017",
      'title': "GSRN - PROVIDER",
      'length': 18,
      "requiredFNC1": true
    },
    {
      'identifer': "8018",
      'title': "GSRN - RECIPIENT",
      'length': 18,
      "requiredFNC1": true
    },
    {
      'identifer': "8019",
      'title': "SRIN",
      "minimumLength": 1,
      "maximumLength": 10
    },
    {
      'identifer': "8020",
      'title': "REF No",
      "minimumLength": 1,
      "maximumLength": 25
    },
    {
      'identifer': "8110",
      'title': "-",
      "minimumLength": 1,
      "maximumLength": 70
    },
    {'identifer': "8111", 'title': "POINTS", 'length': 4, "requiredFNC1": true},
    {
      'identifer': "8112",
      'title': "-",
      "minimumLength": 1,
      "maximumLength": 70
    },
    {
      'identifer': "8200",
      'title': "PRODUCT URL",
      "minimumLength": 1,
      "maximumLength": 70
    },
    {
      'identifer': "90",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 30
    },
    {
      'identifer': "91",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "92",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "93",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "94",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "95",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "96",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "97",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "98",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
    {
      'identifer': "99",
      'title': "INTERNAL",
      "minimumLength": 1,
      "maximumLength": 90
    },
  ];

  final dbhelper = DataBaseHelper.instance;
  List<Map<String, dynamic>> resultMap = [];

  List getLocalstoreData = [];
  List qrResultConvertList = [];
  String? getSpecialCharacter;
  String? getSpecialCharacterLastIndex;
  String? afterAlldataNewstringg;
  String? getSpecialcharcatershape;

  String? getNewSpaecialcharacter = '';

  String? productName;
  String? CompanyName;
  String? suplychain = null;

  bool isGTINExistValue = false;

  String? replaceAllspecialcharacter;

  @override
  void initState() {
    log(widget.qrCode!);

    CheckValueExitInDbb();

// fatchData();

    String? getqrcoderesult = widget.qrCode.toString();

    replaceAllspecialcharacter =
        getqrcoderesult.replaceAll(RegExp('[^A-Za-z0-9]'), 'FNC');
    log(getqrcoderesult);
    getSpecialcharcatershape = getqrcoderesult[0];

    getSpecialCharacter = getqrcoderesult.codeUnitAt(0).toString();

    log(getSpecialCharacter.toString());
    getSpecialCharacterLastIndex =
        getqrcoderesult.codeUnitAt(widget.qrCode!.length - 1).toString();

    if (getSpecialCharacter == "29") {
      for (int i = 0; i < widget.qrCode!.length; i++) {
        qrResultConvertList.add(widget.qrCode![i].toString());
      }

      // log(qrResultConvertList.toString());

      CheckValueForTest(widget.qrCode.toString());
    } else {
      log("invalid Data Matrix");
    }

    if (getSpecialCharacter == "29") {
      for (int i = 0; i < widget.qrCode!.length; i++) {
        if (widget.qrCode![0] == widget.qrCode![i]) {
          getNewSpaecialcharacter = "$getNewSpaecialcharacter" + "FNC";
        } else {
          getNewSpaecialcharacter =
              "$getNewSpaecialcharacter" + widget.qrCode![i];
        }
      }
    }

    if (widget.isScanFile!) {
      insertScanData(widget.qrCode.toString(),
          resultMap.isNotEmpty ? 'DATA MATRIX (GS1)' : 'DATA MATRIX');
      widget.isScanFile = false;
    }

    super.initState();
  }

  void insertScanData(String qrData, String qrType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmailId = prefs.getString("email");

    Map<String, dynamic> row = {
      DataBaseHelper.table2ColumnUserId: userEmailId,
      DataBaseHelper.table2ColumnId: qrData,
      DataBaseHelper.table2ColumnBarcodeType: qrType,
      DataBaseHelper.table2ColumnDate:
          DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()).toString()
    };
    final id = await dbhelper.insertTable2(row);
  }

  void ShowDialogBox(String message) {
    Future.delayed(Duration.zero, () {
      Get.defaultDialog(
          title: 'Alert',
          titleStyle: TextStyle(fontWeight: FontWeight.bold),
          content: Text(
            message.toString(),
            style: TextStyle(fontWeight: FontWeight.w500),
          ));
    });
  }

  CheckValueForTest(String? newStringafterSpecialCharcter) async {
    if (newStringafterSpecialCharcter!.length == 1) {
      if (newStringafterSpecialCharcter ==
          widget.qrCode!.substring(widget.qrCode!.length - 1)) {
        // print("The Value of Last Index ${widget.qrCode!.length-1}");
        if (newStringafterSpecialCharcter.codeUnitAt(0).toString() == "29") {
          ShowDialogBox(
              'FNC Not Required At Index ${widget.qrCode!.length - 1}');

          setState(() {
            resultMap = [];
          });
        }
      }
    } else {
      if (newStringafterSpecialCharcter.codeUnitAt(0).toString() == "29") {
        String? newStringDeleteFirstIndex = newStringafterSpecialCharcter
            .substring(1, newStringafterSpecialCharcter.length);
      if(newStringDeleteFirstIndex.length >1){
getDataMatrixCodeRemoveFirstIndex(newStringDeleteFirstIndex);
      }
      } else {
   if(newStringafterSpecialCharcter.length>1){
        getDataMatrixCodeRemoveFirstIndex(newStringafterSpecialCharcter);
      }
      }
    }
  }

  getDataMatrixCodeRemoveFirstIndex(String newStringDeleteFirstIndex) {
    if (newStringDeleteFirstIndex.length < 3) {
      getDataMatrixWithFirstTwoIndex(newStringDeleteFirstIndex);
    } else if (newStringDeleteFirstIndex.length < 4) {
      getDataMatrixWithFirstThreeIndex(newStringDeleteFirstIndex);
    } else if (newStringDeleteFirstIndex.length >= 4) {
      getDataMatrixWithFirstFourIndex(newStringDeleteFirstIndex);
    }
  }

  getDataMatrixWithFirstTwoIndex(String newStringDeleteFirstIndex) {
    String? getFirsttwoIndex = newStringDeleteFirstIndex.substring(0, 2);

    for (var key in map) {
      if (key['identifer'] == getFirsttwoIndex) {
        int checkItemExistorNot = 0;

        for (var item in resultMap) {
          if (item['identifer'] == getFirsttwoIndex) {
            checkItemExistorNot++;
          }
        }

        if (checkItemExistorNot > 0) {
          ShowDialogBox(
              'Dublicate AII ${key['title']} At Index ${widget.qrCode!.length - newStringDeleteFirstIndex.length + 1}');
          // ShowDialogBox("FNC Required At point ");

          setState(() {
            resultMap = [];
          });
        } else {
          String? getLengthafterCode = newStringDeleteFirstIndex.substring(
              2, newStringDeleteFirstIndex.length);
          if (key.containsKey("length")) {
            int? getLength = key["length"];

            afterGetLengthThanAgainParsing(key, getLength!, getLengthafterCode);
          } else if (key.containsKey("maximumLength")) {
            int? getLength = key["maximumLength"];
            int? getminiLength = key['minimumLength'];
            afterGetMaximumLengthThanAgainParsing(
                key, getLength!, getLengthafterCode, getminiLength!);
          }
        }
      }
    }
  }

  getDataMatrixWithFirstThreeIndex(String newStringDeleteFirstIndex) {
    String? getFirsttwoIndex = newStringDeleteFirstIndex.substring(0, 2);
    String? getFirstthreeIndex = newStringDeleteFirstIndex.substring(0, 3);

    for (var key in map) {
      if (key['identifer'] == getFirsttwoIndex) {
        int checkItemExistorNot = 0;

        for (var item in resultMap) {
          if (item['identifer'] == getFirsttwoIndex) {
            checkItemExistorNot++;
          }
        }

        if (checkItemExistorNot > 0) {
          ShowDialogBox(
              'Dublicate AII ${key['title']} At Index ${widget.qrCode!.length - newStringDeleteFirstIndex.length + 1}');
          // ShowDialogBox("FNC Required At point ");

          setState(() {
            resultMap = [];
          });
        } else {
          String? getLengthafterCode = newStringDeleteFirstIndex.substring(
              2, newStringDeleteFirstIndex.length);
          if (key.containsKey("length")) {
            int? getLength = key["length"];
            afterGetLengthThanAgainParsing(key, getLength!, getLengthafterCode);
          } else if (key.containsKey("maximumLength")) {
            int? getLength = key["maximumLength"];
            int? getminiLength = key['minimumLength'];
            afterGetMaximumLengthThanAgainParsing(
                key, getLength!, getLengthafterCode, getminiLength!);
          }
        }
      } else if (key['identifer'] == getFirstthreeIndex) {
        int checkItemExistorNot = 0;

        for (var item in resultMap) {
          if (item['identifer'] == getFirstthreeIndex) {
            checkItemExistorNot++;
          }
        }

        if (checkItemExistorNot > 0) {
          ShowDialogBox(
              'Dublicate AII ${key['title']} At Index ${widget.qrCode!.length - newStringDeleteFirstIndex.length + 1}');
          // ShowDialogBox("FNC Required At point ");

          setState(() {
            resultMap = [];
          });
        } else {
          String? getLengthafterCode = newStringDeleteFirstIndex.substring(
              3, newStringDeleteFirstIndex.length);

          int? SizeOfstring = getLengthafterCode.length;

          if (key.containsKey("length")) {
            int? getLength = key["length"];

            afterGetLengthThanAgainParsing(key, getLength!, getLengthafterCode);
          } else if (key.containsKey("maximumLength")) {
            int? getLength = key["maximumLength"];
            int? getminiLength = key['minimumLength'];
            afterGetMaximumLengthThanAgainParsing(
                key, getLength!, getLengthafterCode, getminiLength!);
          }
        }
      }
    }
  }

  getDataMatrixWithFirstFourIndex(String newStringDeleteFirstIndex) {
    String? getFirsttwoIndex = newStringDeleteFirstIndex.substring(0, 2);
    String? getFirstthreeIndex = newStringDeleteFirstIndex.substring(0, 3);
    String? getFirstfourIndex = newStringDeleteFirstIndex.substring(0, 4);

    for (var key in map) {
      if (key['identifer'] == getFirsttwoIndex) {
        int checkItemExistorNot = 0;

        for (var item in resultMap) {
          if (item['identifer'] == getFirsttwoIndex) {
            checkItemExistorNot++;
          }
        }

        if (checkItemExistorNot > 0) {
          ShowDialogBox(
              'Dublicate AII ${key['title']} At Index ${widget.qrCode!.length - newStringDeleteFirstIndex.length + 1}');
          // ShowDialogBox("FNC Required At point ");

          setState(() {
            resultMap = [];
          });
        } else {
          String? getLengthafterCode = newStringDeleteFirstIndex.substring(
              2, newStringDeleteFirstIndex.length);

          if (key.containsKey("length")) {
            int? getLength = key["length"];
            afterGetLengthThanAgainParsing(key, getLength!, getLengthafterCode);
          } else if (key.containsKey("maximumLength")) {
            int? getLength = key["maximumLength"];
            int? getminiLength = key['minimumLength'];
            afterGetMaximumLengthThanAgainParsing(
                key, getLength!, getLengthafterCode, getminiLength!);
          }
        }
      } else if (key['identifer'] == getFirstthreeIndex) {
        int checkItemExistorNot = 0;

        for (var item in resultMap) {
          if (item['identifer'] == getFirstthreeIndex) {
            checkItemExistorNot++;
          }
        }

        if (checkItemExistorNot > 0) {
          ShowDialogBox(
              'Dublicate AII ${key['title']} At Index ${widget.qrCode!.length - newStringDeleteFirstIndex.length + 1}');
          // ShowDialogBox("FNC Required At point ");

          setState(() {
            resultMap = [];
          });
        } else {
          String? getLengthafterCode = newStringDeleteFirstIndex.substring(
              3, newStringDeleteFirstIndex.length);

          int? SizeOfstring = getLengthafterCode.length;

          if (key.containsKey("length")) {
            int? getLength = key["length"];
            afterGetLengthThanAgainParsing(key, getLength!, getLengthafterCode);
          } else if (key.containsKey("maximumLength")) {
            int? getLength = key["maximumLength"];
            int? getminiLength = key['minimumLength'];
            afterGetMaximumLengthThanAgainParsing(
                key, getLength!, getLengthafterCode, getminiLength!);
          }
        }
      } else if (key['identifer'] == getFirstfourIndex) {
        int checkItemExistorNot = 0;

        for (var item in resultMap) {
          if (item['identifer'] == getFirstfourIndex) {
            checkItemExistorNot++;
          }
        }

        if (checkItemExistorNot > 0) {
          ShowDialogBox(
              'Dublicate AII ${key['title']} At Index ${widget.qrCode!.length - newStringDeleteFirstIndex.length + 1}');
          // ShowDialogBox("FNC Required At point ");

          setState(() {
            resultMap = [];
          });
        } else {
          String? getLengthafterCode = newStringDeleteFirstIndex.substring(
              4, newStringDeleteFirstIndex.length);

          if (key.containsKey("length")) {
            int? getLength = key["length"];
            afterGetLengthThanAgainParsing(key, getLength!, getLengthafterCode);
          } else if (key.containsKey("maximumLength")) {
            int? getLength = key["maximumLength"];
            int? getminiLength = key['minimumLength'];
            afterGetMaximumLengthThanAgainParsing(
                key, getLength!, getLengthafterCode, getminiLength!);
          }
        }
      }
    }
  }

  afterGetLengthThanAgainParsing(Map<String, dynamic> key, int getLength, String getLengthafterCode) {
    if (getLength > getLengthafterCode.length) {
      ShowDialogBox("Invalid Data Matrix ${key['title']} Length not Complete");
      setState(() {
        resultMap = [];
      });
    } else if (getLength == getLengthafterCode.length) {
      String? getFirstVIIStringg = getLengthafterCode;
      if (getFirstVIIStringg.contains(getSpecialcharcatershape!)) {
        int? getIndex = getFirstVIIStringg.indexOf(getSpecialcharcatershape!);
        getFirstVIIStringg = getLengthafterCode.substring(0, getIndex);

        afterAlldataNewstringg =
            getLengthafterCode.substring(getIndex, getLengthafterCode.length);
        ShowDialogBox(
            'FNC Not Required At Index ${widget.qrCode!.length - afterAlldataNewstringg!.length + 1}');
        setState(() {
          resultMap = [];
        });
      } else {
        String afterAlldataNewstringgnoExistSpecial = getLengthafterCode;

        resultMap.add({
          'identifer': key["identifer"],
          'title': key["title"],
          'value': afterAlldataNewstringgnoExistSpecial
        });
        // setState(() {
        //   CheckValueForTest(afterAlldataNewstringg);
        // });
      }
    } else {
      String? getFirstVIIStringg = getLengthafterCode.substring(0, getLength);
      if (getFirstVIIStringg.contains(getSpecialcharcatershape!)) {
        ShowDialogBox('FNC Not Required in ${key['title']}');
        setState(() {
          resultMap = [];
        });
      } else {
        afterAlldataNewstringg =
            getLengthafterCode.substring(getLength, getLengthafterCode.length);

        resultMap.add({
          'identifer': key["identifer"],
          'title': key["title"],
          'value': getFirstVIIStringg
        });

        // setState(() {
        //   CheckValueForTest(afterAlldataNewstringg);
        // });
        int count = 0;
        String? countnumberOfAIIToNotMatch;
        if (afterAlldataNewstringg!.length > 0) {
          if (afterAlldataNewstringg!.codeUnitAt(0).toString() == "29") {
            ShowDialogBox(
                'FNC Not Required After ${key['title']} At Index ${widget.qrCode!.length - afterAlldataNewstringg!.length + 1}');
            setState(() {
              resultMap = [];
            });
            //CheckValueForTest(afterAlldataNewstringg);
          } else {
            if (afterAlldataNewstringg!.length < 2) {
              countnumberOfAIIToNotMatch =
                  afterAlldataNewstringg!.substring(0, 1);
            } else if (afterAlldataNewstringg!.length < 3) {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              countnumberOfAIIToNotMatch = getFirsttwoIndex;

              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString()) {
                  count++;
                }
              }
            } else if (afterAlldataNewstringg!.length < 4) {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              String? getFirstthreeIndex =
                  afterAlldataNewstringg!.substring(0, 3);

              countnumberOfAIIToNotMatch = getFirstthreeIndex;

              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString() ||
                    key['identifer'] == getFirstthreeIndex.toString()) {
                  count++;
                }
              }
            } else {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              String? getFirstthreeIndex =
                  afterAlldataNewstringg!.substring(0, 3);
              String? getFirstfourIndex =
                  afterAlldataNewstringg!.substring(0, 4);

              countnumberOfAIIToNotMatch = getFirstfourIndex;
              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString() ||
                    key['identifer'] == getFirstthreeIndex.toString() ||
                    key['identifer'] == getFirstfourIndex.toString()) {
                  count++;
                }
              }
            }

            if (count > 0) {
              CheckValueForTest(afterAlldataNewstringg);
              count = 0;
            } else {
              ShowDialogBox(
                  'Invalid AII ${countnumberOfAIIToNotMatch}  At Index ${widget.qrCode!.length - afterAlldataNewstringg!.length + 1}');
              setState(() {
                resultMap = [];
              });
            }
          }
        }

        // else {
        //   //tis
        //   afterAlldataNewstringg = getLengthafterCode.substring(
        //       getLength, getLengthafterCode.length);

        //   resultMap.add({
        //     'identifer': key["identifer"],
        //     'title': key["title"],
        //     'value': getFirstVIIStringg
        //   });
        //   // setState(() {
        //   //   CheckValueForTest(afterAlldataNewstringg);
        //   // });

        //   int count = 0;
        //   String? countnumberOfAIIToNotMatch;
        //   if (afterAlldataNewstringg!.length > 0) {
        //     if (afterAlldataNewstringg!.codeUnitAt(0).toString() == "29") {
        //       CheckValueForTest(afterAlldataNewstringg);
        //     } else {
        //       if (afterAlldataNewstringg!.length < 2) {
        //         String? countnumberOfAIIToNotMatch =
        //             afterAlldataNewstringg!.substring(0, 1);
        //       } else if (afterAlldataNewstringg!.length < 3) {
        //         String? getFirsttwoIndex =
        //             afterAlldataNewstringg!.substring(0, 2);
        //         countnumberOfAIIToNotMatch = getFirsttwoIndex;

        //         for (key in map) {
        //           if (key['identifer'] == getFirsttwoIndex.toString()) {
        //             count++;
        //           }
        //         }
        //       } else if (afterAlldataNewstringg!.length < 4) {
        //         String? getFirsttwoIndex =
        //             afterAlldataNewstringg!.substring(0, 2);
        //         String? getFirstthreeIndex =
        //             afterAlldataNewstringg!.substring(0, 3);
        //         countnumberOfAIIToNotMatch = getFirstthreeIndex;

        //         for (key in map) {
        //           if (key['identifer'] == getFirsttwoIndex.toString() ||
        //               key['identifer'] == getFirstthreeIndex.toString()) {
        //             count++;
        //           }
        //         }
        //       } else {
        //         String? getFirsttwoIndex =
        //             afterAlldataNewstringg!.substring(0, 2);
        //         String? getFirstthreeIndex =
        //             afterAlldataNewstringg!.substring(0, 3);
        //         String? getFirstfourIndex =
        //             afterAlldataNewstringg!.substring(0, 4);
        //         countnumberOfAIIToNotMatch = getFirstfourIndex;

        //         for (key in map) {
        //           if (key['identifer'] == getFirsttwoIndex.toString() ||
        //               key['identifer'] == getFirstthreeIndex.toString() ||
        //               key['identifer'] == getFirstfourIndex.toString()) {
        //             count++;
        //           }
        //         }
        //       }
        //       if (count > 0) {
        //         CheckValueForTest(afterAlldataNewstringg);
        //         count = 0;
        //       } else {
        //         ShowDialogBox(
        //             'Invalid AII ${countnumberOfAIIToNotMatch}  At Index ${widget.qrCode!.length - afterAlldataNewstringg!.length + 1}');
        //         setState(() {
        //           resultMap = [];
        //         });
        //       }
        //     }
        //   }
        // }
      }
    }
  }

  afterGetMaximumLengthThanAgainParsing(Map<String, dynamic> key, int getLength,String getLengthafterCode, int minimumLength) {
    if (minimumLength > getLengthafterCode.length) {
      ShowDialogBox("The Required ${key['title']} the minimum Length $minimumLength");
      resultMap = [];
    } else if (getLength > getLengthafterCode.length) {
      String? getFirstVIIStringg = getLengthafterCode;

      if (getFirstVIIStringg.contains(getSpecialcharcatershape!)) {
        int? getIndex = getFirstVIIStringg.indexOf(getSpecialcharcatershape!);
        getFirstVIIStringg = getLengthafterCode.substring(0, getIndex);
        afterAlldataNewstringg =
            getLengthafterCode.substring(getIndex, getLengthafterCode.length);

            if(getFirstVIIStringg.length >=  minimumLength){

            

        resultMap.add({
          'identifer': key["identifer"],
          'title': key["title"],
          'value': getFirstVIIStringg
        });
        // setState(() {
        //   CheckValueForTest(afterAlldataNewstringg);
        // });
        int count = 0;
        String? countnumberOfAIIToNotMatch;
        if (afterAlldataNewstringg!.length > 0) {
          if (afterAlldataNewstringg!.codeUnitAt(0).toString() == "29") {
            CheckValueForTest(afterAlldataNewstringg);
          } else {
            if (afterAlldataNewstringg!.length < 2) {
              countnumberOfAIIToNotMatch =
                  afterAlldataNewstringg!.substring(0, 1);
            } else if (afterAlldataNewstringg!.length < 3) {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              countnumberOfAIIToNotMatch = getFirsttwoIndex;

              for (key in map) {
                if (key['identifer'] ==
                    getFirsttwoIndex.toString().toString()) {
                  count++;
                }
              }
            } else if (afterAlldataNewstringg!.length < 4) {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              String? getFirstthreeIndex =
                  afterAlldataNewstringg!.substring(0, 3);
              countnumberOfAIIToNotMatch = getFirstthreeIndex;

              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString() ||
                    key['identifer'] == getFirstthreeIndex.toString()) {
                  count++;
                }
              }
            } else {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              String? getFirstthreeIndex =
                  afterAlldataNewstringg!.substring(0, 3);
              String? getFirstfourIndex =
                  afterAlldataNewstringg!.substring(0, 4);
              countnumberOfAIIToNotMatch = getFirstfourIndex;

              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString() ||
                    key['identifer'] == getFirstthreeIndex.toString() ||
                    key['identifer'] == getFirstfourIndex.toString()) {
                  count++;
                }
              }
            }

            if (count > 0) {
              CheckValueForTest(afterAlldataNewstringg);

              count = 0;
            } else {
              ShowDialogBox(
                  'Invalid AII ${countnumberOfAIIToNotMatch}  At Index ${widget.qrCode!.length - afterAlldataNewstringg!.length + 1}');
              // ShowDialogBox("FNC Required At point ");

              setState(() {
                resultMap = [];
              });
            }
          }
        }}else{
           ShowDialogBox("The Required ${key['title']} the minimum Length $minimumLength");
      resultMap = [];
        }
      } else {
        String afterAlldataNewstringgnoExistSpecial = getLengthafterCode;
        resultMap.add({
          'identifer': key["identifer"],
          'title': key["title"],
          'value': afterAlldataNewstringgnoExistSpecial
        });
      }
    } else if (getLength == getLengthafterCode.length) {
      String? getFirstVIIStringg = getLengthafterCode;

      if (getFirstVIIStringg.contains(getSpecialcharcatershape!)) {
        int? getIndex = getFirstVIIStringg.indexOf(getSpecialcharcatershape!);
        getFirstVIIStringg = getLengthafterCode.substring(0, getIndex);
        afterAlldataNewstringg =
            getLengthafterCode.substring(getIndex, getLengthafterCode.length);

        resultMap.add({
          'identifer': key["identifer"],
          'title': key["title"],
          'value': getFirstVIIStringg
        });
        // setState(() {
        //   CheckValueForTest(afterAlldataNewstringg);
        // });
        int count = 0;
        String? countnumberOfAIIToNotMatch;
        if (afterAlldataNewstringg!.length > 0) {
          if (afterAlldataNewstringg!.codeUnitAt(0).toString() == "29") {
            CheckValueForTest(afterAlldataNewstringg);
          } else {
            if (afterAlldataNewstringg!.length < 2) {
              countnumberOfAIIToNotMatch =
                  afterAlldataNewstringg!.substring(0, 1);
            } else if (afterAlldataNewstringg!.length < 3) {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              countnumberOfAIIToNotMatch = getFirsttwoIndex;

              for (key in map) {
                if (key['identifer'] ==
                    getFirsttwoIndex.toString().toString()) {
                  count++;
                }
              }
            } else if (afterAlldataNewstringg!.length < 4) {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              String? getFirstthreeIndex =
                  afterAlldataNewstringg!.substring(0, 3);
              countnumberOfAIIToNotMatch = getFirstthreeIndex;

              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString() ||
                    key['identifer'] == getFirstthreeIndex.toString()) {
                  count++;
                }
              }
            } else {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              String? getFirstthreeIndex =
                  afterAlldataNewstringg!.substring(0, 3);
              String? getFirstfourIndex =
                  afterAlldataNewstringg!.substring(0, 4);
              countnumberOfAIIToNotMatch = getFirstfourIndex;

              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString() ||
                    key['identifer'] == getFirstthreeIndex.toString() ||
                    key['identifer'] == getFirstfourIndex.toString()) {
                  count++;
                }
              }
            }

            if (count > 0) {
              CheckValueForTest(afterAlldataNewstringg);

              count = 0;
            } else {
              ShowDialogBox(
                  'Invalid AII ${countnumberOfAIIToNotMatch}  At Index ${widget.qrCode!.length - afterAlldataNewstringg!.length + 1}');
              // ShowDialogBox("FNC Required At point ");

              setState(() {
                resultMap = [];
              });
            }
          }
        }
      } else {
        String afterAlldataNewstringgnoExistSpecial = getLengthafterCode;
        resultMap.add({
          'identifer': key["identifer"],
          'title': key["title"],
          'value': afterAlldataNewstringgnoExistSpecial
        });
      }
    } else {
      String? getFirstVIIStringg = getLengthafterCode.substring(0, getLength);

      if (getFirstVIIStringg.contains(getSpecialcharcatershape!)) {
        int? getIndex = getFirstVIIStringg.indexOf(getSpecialcharcatershape!);

        // print(getIndex.toString());

        getFirstVIIStringg = getLengthafterCode.substring(0, getIndex);
        //// print(getFirstVIIStringg);

        afterAlldataNewstringg =
            getLengthafterCode.substring(getIndex, getLengthafterCode.length);

        resultMap.add({
          'identifer': key["identifer"],
          'title': key["title"],
          'value': getFirstVIIStringg
        });
        // setState(() {
        //   CheckValueForTest(afterAlldataNewstringg);
        // });
        int count = 0;
        String? countnumberOfAIIToNotMatch;
        if (afterAlldataNewstringg!.length > 0) {
          if (afterAlldataNewstringg!.codeUnitAt(0).toString() == "29") {
            CheckValueForTest(afterAlldataNewstringg);
          } else {
            if (afterAlldataNewstringg!.length < 2) {
              countnumberOfAIIToNotMatch =
                  afterAlldataNewstringg!.substring(0, 1);
            } else if (afterAlldataNewstringg!.length < 3) {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              countnumberOfAIIToNotMatch = getFirsttwoIndex;
              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString()) {
                  count++;
                }
              }
            } else if (afterAlldataNewstringg!.length < 4) {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              String? getFirstthreeIndex =
                  afterAlldataNewstringg!.substring(0, 3);
              countnumberOfAIIToNotMatch = getFirstthreeIndex;

              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString() ||
                    key['identifer'] == getFirstthreeIndex.toString()) {
                  count++;
                }
              }
            } else {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              String? getFirstthreeIndex =
                  afterAlldataNewstringg!.substring(0, 3);
              String? getFirstfourIndex =
                  afterAlldataNewstringg!.substring(0, 4);
              countnumberOfAIIToNotMatch = getFirstfourIndex;

              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString() ||
                    key['identifer'] == getFirstthreeIndex.toString() ||
                    key['identifer'] == getFirstfourIndex.toString()) {
                  count++;
                }
              }
            }

            if (count > 0) {
              CheckValueForTest(afterAlldataNewstringg);
              count = 0;
            } else {
              print(
                  'Invalid AII ${countnumberOfAIIToNotMatch}  At Index ${widget.qrCode!.length - afterAlldataNewstringg!.length + 1}');
              // print("FNC Required At point ");

              setState(() {
                resultMap = [];
              });
            }
          }
        }
      } else {
        afterAlldataNewstringg =
            getLengthafterCode.substring(getLength, getLengthafterCode.length);

        //// print(getFirstVIIStringg);
        // print(afterAlldataNewstringg!);

        resultMap.add({
          'identifer': key["identifer"],
          'title': key["title"],
          'value': getFirstVIIStringg
        });

        // setState(() {
        //   CheckValueForTest(afterAlldataNewstringg);
        // });
        //erro
        int count = 0;
        String? countnumberOfAIIToNotMatch;
        if (afterAlldataNewstringg!.length > 0) {
          if (afterAlldataNewstringg!.codeUnitAt(0).toString() == "29") {
            CheckValueForTest(afterAlldataNewstringg);
          } else {
            if (afterAlldataNewstringg!.length < 2) {
              countnumberOfAIIToNotMatch =
                  afterAlldataNewstringg!.substring(0, 1);
            } else if (afterAlldataNewstringg!.length < 3) {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              countnumberOfAIIToNotMatch = getFirsttwoIndex;

              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString()) {
                  count++;
                }
              }
            } else if (afterAlldataNewstringg!.length < 4) {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              String? getFirstthreeIndex =
                  afterAlldataNewstringg!.substring(0, 3);
              countnumberOfAIIToNotMatch = getFirstthreeIndex;

              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString() ||
                    key['identifer'] == getFirstthreeIndex.toString()) {
                  count++;
                }
              }
            } else {
              String? getFirsttwoIndex =
                  afterAlldataNewstringg!.substring(0, 2);
              String? getFirstthreeIndex =
                  afterAlldataNewstringg!.substring(0, 3);
              String? getFirstfourIndex =
                  afterAlldataNewstringg!.substring(0, 4);
              countnumberOfAIIToNotMatch = getFirstfourIndex;

              for (key in map) {
                if (key['identifer'] == getFirsttwoIndex.toString() ||
                    key['identifer'] == getFirstthreeIndex.toString() ||
                    key['identifer'] == getFirstfourIndex.toString()) {
                  count++;
                }
              }
            }
            if (count > 0) {
              CheckValueForTest(afterAlldataNewstringg);
              count = 0;
            } else {
              print(
                  'Invalid AII ${countnumberOfAIIToNotMatch}  At Index ${widget.qrCode!.length - afterAlldataNewstringg!.length + 1}');
              // print("FNC Required At point ");

              setState(() {
                resultMap = [];
              });
            }
          }
        }
      }
    }
  }

  List<Map<String, dynamic>> data = [];

  Future<void> CheckValueExitInDbb() async {
    List<Map<String, dynamic>> getLocalstoreData = await dbhelper.fatchTable1();

    for (int j = 0; j < resultMap.length; j++) {
      if (resultMap[j]['title'].toString().contains("GTIN")) {
        //  log(resultMap[j].toString());
        String? getData = resultMap[j]['value'];

        for (int i = 0; i < getLocalstoreData.length; i++) {
          if (getData! == getLocalstoreData[i]['id']) {
            setState(() {
              productName = getLocalstoreData[i]['plain1'];
              CompanyName = getLocalstoreData[i]['cline3'];
              suplychain = getLocalstoreData[i]['sline4'];

              // log("Supplu chain ${suplychain.toString()}");
            });
          }
        }
      }
    }
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
    }
  }

  final _screenShotController = ScreenshotController();

  Future<void> shareScreenshot(Uint8List bytes) async {
    final box = context.findRenderObject() as RenderBox?;
    if (bytes != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/flutter.png').create();
      await imagePath.writeAsBytes(bytes);

      /// Share Plugin
      await Share.shareFiles([imagePath.path],
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      Fluttertoast.showToast(msg: "null image");
      print("image null");
    }
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Screenshot(
      controller: _screenShotController,
      child: Scaffold(
        floatingActionButton: SpeedDial(
          childMargin: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
          // icon: Icons.add,
          icon: Icons.share,
          activeIcon: Icons.close,
          backgroundColor: colorPrimaryLightBlue,
          childPadding: EdgeInsets.symmetric(vertical: 8),
          animationDuration: const Duration(milliseconds: 350),

          children: [
            SpeedDialChild(
                child: const ImageIcon(AssetImage("assets/images/copy.png"),
                    color: Colors.white),
                label: "Copy Result",
                labelStyle: const TextStyle(color: Colors.white),
                backgroundColor: copybuttonColor,
                labelBackgroundColor: Colors.black,
                onTap: () async {
                  await FlutterClipboard.copy(getNewSpaecialcharacter!);
                  Fluttertoast.showToast(
                      msg: "Result Copied!",
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 2,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.black);
                }),
            SpeedDialChild(
                child: const ImageIcon(AssetImage("assets/images/share.png"),
                    color: Colors.white),
                label: "Share Result",
                labelStyle: const TextStyle(color: Colors.white),
                labelBackgroundColor: Colors.black,
                backgroundColor: sharebuttonColor,
                onTap: () async {
                  final box = context.findRenderObject() as RenderBox?;
                  await Share.share(getNewSpaecialcharacter!,
                      sharePositionOrigin:
                          box!.localToGlobal(Offset.zero) & box.size);
                }),
            SpeedDialChild(
                child: const ImageIcon(
                    AssetImage("assets/images/screenshot.png"),
                    color: Colors.white),
                label: "Share ScreenShot",
                labelStyle: const TextStyle(color: Colors.white),
                labelBackgroundColor: Colors.black,
                backgroundColor: screenshotbuttonColor,
                onTap: () async {
                  final shareShotImage = await _screenShotController.capture(
                      pixelRatio: pixelRatio);
                  await shareScreenshot(shareShotImage!);
                }),
          ],
        ),
        appBar: AppBar(
          backgroundColor: colorPrimaryLightBlue,
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: false,
          title: Text(
            "Scan Result",
            style:
                GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 16.0),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset("assets/images/back.png")),
            // IconButton(onPressed: (){}, icon: Icon(Icons.more_vert_sharp,color: Colors.white,))
            PopupMenuButton<int>(
              onSelected: (item) => handleClick(item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: const Text('Copy to Clipboard'),
                  onTap: () async {
                    await FlutterClipboard.copy(getNewSpaecialcharacter!);
                    Fluttertoast.showToast(
                        msg: "Result Copied!",
                        timeInSecForIosWeb: 2,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.black);
                  },
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: const Text('Share Result'),
                  onTap: () async {
                    final box = context.findRenderObject() as RenderBox?;
                    await Share.share(getNewSpaecialcharacter!,
                        sharePositionOrigin:
                            box!.localToGlobal(Offset.zero) & box.size);
                  },
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: const Text('Share ScreenShot'),
                  onTap: () async {
                    final shareShotImage = await _screenShotController.capture(
                      pixelRatio: pixelRatio,
                    );
                    await shareScreenshot(shareShotImage!);
                  },
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: resultbackgroundColor,
                child: Column(
                  children: [
                    resultMap.isNotEmpty
                        ? Text(
                            "DATA MATRIX (GS1)",
                            style: GoogleFonts.roboto(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            'DATA MATRIX',
                            style: GoogleFonts.roboto(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                    const SizedBox(
                      height: 8,
                    ),

                    getSpecialCharacter != '29'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${widget.qrCode}'),
                            ],
                          )
                        : Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: qrResultConvertList.map((item) {
                              if (item == widget.qrCode![0]) {
                                return const Text(
                                  'FNC',
                                  style: TextStyle(
                                    color: colorPrimaryLightBlue,
                                    fontWeight: FontWeight.normal,
                                  ),
                                );
                              } else {
                                return Text(
                                  item.toString(),
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                );
                              }
                              // if (item < 100) {
                              //   return Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Text(
                              //       item.toString(),
                              //       style: const TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.red,
                              //       ),
                              //     ),
                              //   );
                              // }
                              // if (item == 100) {
                              //   return Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Text(
                              //       item.toString(),
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.green,
                              //       ),
                              //     ),
                              //   );
                              // }
                            }).toList()),
                    // Text(
                    //   "${widget.qrCode}",
                    //   style: GoogleFonts.roboto(
                    //       color: Colors.black.withOpacity(0.5),
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w300),
                    // )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              getSpecialCharacter != '29'
                  ? Container(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          'Not Found Valid AI',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              resultMap.length == 0
                                  ? Text(
                                      'Invalid Data Matrix',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.red,
                                      ),
                                    )
                                  : Text(
                                      "SCANNED INFORMATION",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0; i < resultMap.length; i++)
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${resultMap[i]['title']}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: colorPrimaryLightBlue),
                                              ),
                                              Text(
                                                '(${resultMap[i]['identifer']}): ',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: colorPrimaryLightBlue),
                                              ),
                                            ],
                                          )),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                              child: Text(
                                            '${resultMap[i]['value']}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(color: Colors.black54),
                                          )),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(
                height: 20,
              ),
              productName == null && CompanyName == null && suplychain == null
                  ? Container()
                  : Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "MASTER DATA",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          productName == null
                              ? Center()
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'PRODUCT: ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: colorPrimaryLightBlue),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: productName == null
                                          ? Text('')
                                          : Text(
                                              '$productName',
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              // style: const TextStyle(
                                              //     fontWeight: FontWeight.bold,
                                              //     color: blueColor1),
                                            ),
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: 5,
                          ),
                          CompanyName == null
                              ? Center()
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'COMPANY: ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: colorPrimaryLightBlue),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: CompanyName == null
                                          ? Text('')
                                          : Text(
                                              '$CompanyName',
                                              style: TextStyle(
                                                  color: Colors.black54),
                                              //  style: const TextStyle(
                                              //      fontWeight: FontWeight.bold,
                                              //      color: blueColor1),
                                            ),
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: 5,
                          ),
                          suplychain == null && suplychain.runtimeType == Null
                              ? Container()
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'SUPPLY CHAIN: ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: colorPrimaryLightBlue),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${suplychain}',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                            ],

                          ),
                        ),
                      ),
                  ),
              
            ],
          ),
        ),
      ),
    );
  }
}
