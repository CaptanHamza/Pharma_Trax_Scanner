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

import '../utils/globalValue.dart';
import '../utils/globalValueList.dart';

class BarCodeResultScreen extends StatefulWidget {
  String? qrCode;
  String? typeText;
  bool? isScanFile;
  String? rawByteCode;
  BarCodeResultScreen(this.qrCode, this.typeText, this.isScanFile,
      {Key? key, this.rawByteCode})
      : super(key: key);

  @override
  State<BarCodeResultScreen> createState() => _BarCodeResultScreenState();
}

class _BarCodeResultScreenState extends State<BarCodeResultScreen> {
  String? getCountryName = "";
  String? getPrefixString = "";
  String? getCGPLengthofString = "";

  final dbhelper = DataBaseHelper.instance;
  List<Map<String, dynamic>> resultMap = [];

  List getLocalstoreData = [];
  List qrResultConvertList = [];
  String? getSpecialCharacter;
  String? getSpecialCharacterLastIndex;
  String? afterAlldataNewstringg;
  String? getSpecialcharcatershape;

  String? productName;
  String? CompanyName;
  String? suplychain = null;

  String? getNewSpaecialcharacter = '';
  bool isGTINExistValue = false;

  String? replaceAllspecialcharacter;

  List<String>? afterFormateList = [];
  List<int>? getList = [];
  List<String> addSpecialCharcter = [];

  String? afterConvert;

  String? getqrcoderesult;

  @override
  void initState() {
    if (widget.isScanFile!) {
      if (widget.rawByteCode!.substring(0, 3) == "]C1") {
        afterConvert =
            widget.rawByteCode!.replaceAll("]C1", String.fromCharCode(29));
      } else {
        afterConvert = widget.rawByteCode;
      }
    }

    CheckValueExitInDbb();

    getqrcoderesult =
        widget.isScanFile! == true ? afterConvert!.toString() : widget.qrCode;

    replaceAllspecialcharacter =
        getqrcoderesult!.replaceAll(RegExp('[^A-Za-z0-9]'), 'FNC');
    log(getqrcoderesult!);
    getSpecialcharcatershape = getqrcoderesult![0];

    getSpecialCharacter = getqrcoderesult!.codeUnitAt(0).toString();
    getSpecialCharacterLastIndex =
        getqrcoderesult!.codeUnitAt(getqrcoderesult!.length - 1).toString();

    if (getSpecialCharacter == "29") {
      for (int i = 0; i < getqrcoderesult!.length; i++) {
        qrResultConvertList.add(getqrcoderesult![i].toString());
      }

      // log(qrResultConvertList.toString());

      CheckValueForTest(getqrcoderesult.toString());
    } else {
      log("invalid  Code 128");
    }

    if (getSpecialCharacter == "29") {
      for (int i = 0; i < getqrcoderesult!.length; i++) {
        if (getqrcoderesult![0] == qrResultConvertList[i]) {
          getNewSpaecialcharacter = "$getNewSpaecialcharacter" + "FNC";
        } else {
          getNewSpaecialcharacter =
              "$getNewSpaecialcharacter" + getqrcoderesult![i];
        }
      }
    }

    if (widget.isScanFile!) {
      insertScanData(
        afterConvert!,
        resultMap.isNotEmpty ? 'GS1 128' : 'CODE 128',
      );
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
          getqrcoderesult!.substring(getqrcoderesult!.length - 1)) {
        // ShowDialogBox("The Value of Last Index ${getqrcoderesult!.length-1}");
        if (newStringafterSpecialCharcter.codeUnitAt(0).toString() == "29") {
          ShowDialogBox(
              'FNC Not Required At Index ${getqrcoderesult!.length - 1}');

          setState(() {
            resultMap = [];
          });
        }
      }
    } else {
      if (newStringafterSpecialCharcter.codeUnitAt(0).toString() == "29") {
        String? newStringDeleteFirstIndex = newStringafterSpecialCharcter
            .substring(1, newStringafterSpecialCharcter.length);
        if (newStringDeleteFirstIndex.length > 1) {
          getDataMatrixCodeRemoveFirstIndex(newStringDeleteFirstIndex);
        }
      } else {
        if (newStringafterSpecialCharcter.length > 1) {
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

  afterGetLengthThanAgainParsing(
      Map<String, dynamic> key, int getLength, String getLengthafterCode) {
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
        String? afterAlldataNewstringgnoExistSpecial = getLengthafterCode;

        if (key["identifer"].contains("11") ||
            key["identifer"].contains("12") ||
            key["identifer"].contains("13") ||
            key["identifer"].contains("15") ||
            key["identifer"].contains("17")) {
          String? afterAlldataNewstringgnoExistSpecial =
              getLengthafterCode.toString();
          String getDateString = afterAlldataNewstringgnoExistSpecial;
          String? getYearSubString =
              afterAlldataNewstringgnoExistSpecial.substring(0, 2);
          String getMonthSubString =
              afterAlldataNewstringgnoExistSpecial.substring(2, 4);
          String getDaysSubString =
              afterAlldataNewstringgnoExistSpecial.substring(4, 6);

          String? dateFormateParse;

          String? addNewYearMakeFullYear = "20" + getYearSubString.toString();

          if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00") &&
              getYearSubString.contains("00")) {
            dateFormateParse = "$afterAlldataNewstringgnoExistSpecial";
          } else if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00")) {
            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${addNewYearMakeFullYear})";
          } else if (getDaysSubString.contains("00") &&
              !getMonthSubString.contains("00")) {
            String formatedate = DateFormat('MMMM')
                .format(DateTime(0, int.parse(getMonthSubString)));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial($formatedate $addNewYearMakeFullYear)";
          } else if (getMonthSubString.contains("00")) {
            dateFormateParse = afterAlldataNewstringgnoExistSpecial;
          } else {
            String formatedate = DateTime.parse(
                    addNewYearMakeFullYear.toString() +
                        getMonthSubString.toString() +
                        getDaysSubString.toString())
                .toIso8601String();

            String? formateDateData =
                DateFormat.yMMMMd().format(DateTime.parse(formatedate));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${formateDateData})";
          }

          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': dateFormateParse
          });
        } else {
          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': afterAlldataNewstringgnoExistSpecial
          });
        }

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

        if (key["identifer"].contains("11") ||
            key["identifer"].contains("12") ||
            key["identifer"].contains("13") ||
            key["identifer"].contains("15") ||
            key["identifer"].contains("17")) {
          String? afterAlldataNewstringgnoExistSpecial =
              getFirstVIIStringg.toString();
          String getDateString = afterAlldataNewstringgnoExistSpecial;
          String? getYearSubString =
              afterAlldataNewstringgnoExistSpecial.substring(0, 2);
          String getMonthSubString =
              afterAlldataNewstringgnoExistSpecial.substring(2, 4);
          String getDaysSubString =
              afterAlldataNewstringgnoExistSpecial.substring(4, 6);

          String? dateFormateParse;

          String? addNewYearMakeFullYear = "20" + getYearSubString.toString();

          if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00") &&
              getYearSubString.contains("00")) {
            dateFormateParse = "$afterAlldataNewstringgnoExistSpecial";
          } else if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00")) {
            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${addNewYearMakeFullYear})";
          } else if (getDaysSubString.contains("00") &&
              !getMonthSubString.contains("00")) {
            String formatedate = DateFormat('MMMM')
                .format(DateTime(0, int.parse(getMonthSubString)));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial($formatedate $addNewYearMakeFullYear)";
          } else if (getMonthSubString.contains("00")) {
            dateFormateParse = afterAlldataNewstringgnoExistSpecial;
          } else {
            String formatedate = DateTime.parse(
                    addNewYearMakeFullYear.toString() +
                        getMonthSubString.toString() +
                        getDaysSubString.toString())
                .toIso8601String();

            String? formateDateData =
                DateFormat.yMMMMd().format(DateTime.parse(formatedate));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${formateDateData})";
          }

          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': dateFormateParse
          });
        } else {
          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': getFirstVIIStringg
          });
        }
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

  afterGetMaximumLengthThanAgainParsing(Map<String, dynamic> key, int getLength,
      String getLengthafterCode, int minimumLength) {
    if (minimumLength > getLengthafterCode.length) {
      ShowDialogBox(
          "The Required ${key['title']} the minimum Length $minimumLength");
      resultMap = [];
    } else if (getLength > getLengthafterCode.length) {
      String? getFirstVIIStringg = getLengthafterCode;

      if (getFirstVIIStringg.contains(getSpecialcharcatershape!)) {
        int? getIndex = getFirstVIIStringg.indexOf(getSpecialcharcatershape!);
        getFirstVIIStringg = getLengthafterCode.substring(0, getIndex);
        afterAlldataNewstringg =
            getLengthafterCode.substring(getIndex, getLengthafterCode.length);

        if (getFirstVIIStringg.length >= minimumLength) {
          if (key["identifer"].contains("11") ||
              key["identifer"].contains("12") ||
              key["identifer"].contains("13") ||
              key["identifer"].contains("15") ||
              key["identifer"].contains("17")) {
            String? afterAlldataNewstringgnoExistSpecial =
                getFirstVIIStringg.toString();
            String getDateString = afterAlldataNewstringgnoExistSpecial;
            String? getYearSubString =
                afterAlldataNewstringgnoExistSpecial.substring(0, 2);
            String getMonthSubString =
                afterAlldataNewstringgnoExistSpecial.substring(2, 4);
            String getDaysSubString =
                afterAlldataNewstringgnoExistSpecial.substring(4, 6);

            String? dateFormateParse;

            String? addNewYearMakeFullYear = "20" + getYearSubString.toString();

            if (getDaysSubString.contains("00") &&
                getMonthSubString.contains("00")) {
              dateFormateParse =
                  "$afterAlldataNewstringgnoExistSpecial(${addNewYearMakeFullYear})";
            } else if (getDaysSubString.contains("00") &&
                !getMonthSubString.contains("00")) {
              String formatedate = DateFormat('MMMM')
                  .format(DateTime(0, int.parse(getMonthSubString)));

              dateFormateParse =
                  "$afterAlldataNewstringgnoExistSpecial($formatedate $addNewYearMakeFullYear)";
            } else if (getMonthSubString.contains("00")) {
              dateFormateParse = afterAlldataNewstringgnoExistSpecial;
            } else {
              String formatedate = DateTime.parse(
                      addNewYearMakeFullYear.toString() +
                          getMonthSubString.toString() +
                          getDaysSubString.toString())
                  .toIso8601String();

              String? formateDateData =
                  DateFormat.yMMMMd().format(DateTime.parse(formatedate));

              dateFormateParse =
                  "$afterAlldataNewstringgnoExistSpecial(${formateDateData})";
            }

            resultMap.add({
              'identifer': key["identifer"],
              'title': key["title"],
              'value': dateFormateParse
            });
          } else {
            resultMap.add({
              'identifer': key["identifer"],
              'title': key["title"],
              'value': getFirstVIIStringg
            });
          }
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
          ShowDialogBox(
              "The Required ${key['title']} the minimum Length $minimumLength");
          resultMap = [];
        }
      } else {
        String afterAlldataNewstringgnoExistSpecial = getLengthafterCode;

        if (key["identifer"].contains("11") ||
            key["identifer"].contains("12") ||
            key["identifer"].contains("13") ||
            key["identifer"].contains("15") ||
            key["identifer"].contains("17")) {
          String? afterAlldataNewstringgnoExistSpecial =
              getLengthafterCode.toString();
          String getDateString = afterAlldataNewstringgnoExistSpecial;
          String? getYearSubString =
              afterAlldataNewstringgnoExistSpecial.substring(0, 2);
          String getMonthSubString =
              afterAlldataNewstringgnoExistSpecial.substring(2, 4);
          String getDaysSubString =
              afterAlldataNewstringgnoExistSpecial.substring(4, 6);

          String? dateFormateParse;

          String? addNewYearMakeFullYear = "20" + getYearSubString.toString();

          if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00") &&
              getYearSubString.contains("00")) {
            dateFormateParse = "$afterAlldataNewstringgnoExistSpecial";
          } else if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00")) {
            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${addNewYearMakeFullYear})";
          } else if (getDaysSubString.contains("00") &&
              !getMonthSubString.contains("00")) {
            String formatedate = DateFormat('MMMM')
                .format(DateTime(0, int.parse(getMonthSubString)));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial($formatedate $addNewYearMakeFullYear)";
          } else if (getMonthSubString.contains("00")) {
            dateFormateParse = afterAlldataNewstringgnoExistSpecial;
          } else {
            String formatedate = DateTime.parse(
                    addNewYearMakeFullYear.toString() +
                        getMonthSubString.toString() +
                        getDaysSubString.toString())
                .toIso8601String();

            String? formateDateData =
                DateFormat.yMMMMd().format(DateTime.parse(formatedate));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${formateDateData})";
          }

          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': dateFormateParse
          });
        } else {
          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': afterAlldataNewstringgnoExistSpecial
          });
        }
      }
    } else if (getLength == getLengthafterCode.length) {
      String? getFirstVIIStringg = getLengthafterCode;

      if (getFirstVIIStringg.contains(getSpecialcharcatershape!)) {
        int? getIndex = getFirstVIIStringg.indexOf(getSpecialcharcatershape!);
        getFirstVIIStringg = getLengthafterCode.substring(0, getIndex);
        afterAlldataNewstringg =
            getLengthafterCode.substring(getIndex, getLengthafterCode.length);

        if (key["identifer"].contains("11") ||
            key["identifer"].contains("12") ||
            key["identifer"].contains("13") ||
            key["identifer"].contains("15") ||
            key["identifer"].contains("17")) {
          String? afterAlldataNewstringgnoExistSpecial =
              getFirstVIIStringg.toString();
          String getDateString = afterAlldataNewstringgnoExistSpecial;
          String? getYearSubString =
              afterAlldataNewstringgnoExistSpecial.substring(0, 2);
          String getMonthSubString =
              afterAlldataNewstringgnoExistSpecial.substring(2, 4);
          String getDaysSubString =
              afterAlldataNewstringgnoExistSpecial.substring(4, 6);

          String? dateFormateParse;

          String? addNewYearMakeFullYear = "20" + getYearSubString.toString();

          if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00") &&
              getYearSubString.contains("00")) {
            dateFormateParse = "$afterAlldataNewstringgnoExistSpecial";
          } else if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00")) {
            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${addNewYearMakeFullYear})";
          } else if (getDaysSubString.contains("00") &&
              !getMonthSubString.contains("00")) {
            String formatedate = DateFormat('MMMM')
                .format(DateTime(0, int.parse(getMonthSubString)));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial($formatedate $addNewYearMakeFullYear)";
          } else if (getMonthSubString.contains("00")) {
            dateFormateParse = afterAlldataNewstringgnoExistSpecial;
          } else {
            String formatedate = DateTime.parse(
                    addNewYearMakeFullYear.toString() +
                        getMonthSubString.toString() +
                        getDaysSubString.toString())
                .toIso8601String();

            String? formateDateData =
                DateFormat.yMMMMd().format(DateTime.parse(formatedate));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${formateDateData})";
          }

          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': dateFormateParse
          });
        } else {
          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': getFirstVIIStringg
          });
        }
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

        if (key["identifer"].contains("11") ||
            key["identifer"].contains("12") ||
            key["identifer"].contains("13") ||
            key["identifer"].contains("15") ||
            key["identifer"].contains("17")) {
          String? afterAlldataNewstringgnoExistSpecial =
              getLengthafterCode.toString();
          String getDateString = afterAlldataNewstringgnoExistSpecial;
          String? getYearSubString =
              afterAlldataNewstringgnoExistSpecial.substring(0, 2);
          String getMonthSubString =
              afterAlldataNewstringgnoExistSpecial.substring(2, 4);
          String getDaysSubString =
              afterAlldataNewstringgnoExistSpecial.substring(4, 6);

          String? dateFormateParse;

          String? addNewYearMakeFullYear = "20" + getYearSubString.toString();

          if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00") &&
              getYearSubString.contains("00")) {
            dateFormateParse = "$afterAlldataNewstringgnoExistSpecial";
          } else if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00")) {
            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${addNewYearMakeFullYear})";
          } else if (getDaysSubString.contains("00") &&
              !getMonthSubString.contains("00")) {
            String formatedate = DateFormat('MMMM')
                .format(DateTime(0, int.parse(getMonthSubString)));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial($formatedate $addNewYearMakeFullYear)";
          } else if (getMonthSubString.contains("00")) {
            dateFormateParse = afterAlldataNewstringgnoExistSpecial;
          } else {
            String formatedate = DateTime.parse(
                    addNewYearMakeFullYear.toString() +
                        getMonthSubString.toString() +
                        getDaysSubString.toString())
                .toIso8601String();

            String? formateDateData =
                DateFormat.yMMMMd().format(DateTime.parse(formatedate));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${formateDateData})";
          }

          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': dateFormateParse
          });
        } else {
          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': afterAlldataNewstringgnoExistSpecial
          });
        }
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

        if (key["identifer"].contains("11") ||
            key["identifer"].contains("12") ||
            key["identifer"].contains("13") ||
            key["identifer"].contains("15") ||
            key["identifer"].contains("17")) {
          String? afterAlldataNewstringgnoExistSpecial =
              getFirstVIIStringg.toString();
          String getDateString = afterAlldataNewstringgnoExistSpecial;
          String? getYearSubString =
              afterAlldataNewstringgnoExistSpecial.substring(0, 2);
          String getMonthSubString =
              afterAlldataNewstringgnoExistSpecial.substring(2, 4);
          String getDaysSubString =
              afterAlldataNewstringgnoExistSpecial.substring(4, 6);

          String? dateFormateParse;

          String? addNewYearMakeFullYear = "20" + getYearSubString.toString();

          if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00") &&
              getYearSubString.contains("00")) {
            dateFormateParse = "$afterAlldataNewstringgnoExistSpecial";
          } else if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00")) {
            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${addNewYearMakeFullYear})";
          } else if (getDaysSubString.contains("00") &&
              !getMonthSubString.contains("00")) {
            String formatedate = DateFormat('MMMM')
                .format(DateTime(0, int.parse(getMonthSubString)));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial($formatedate $addNewYearMakeFullYear)";
          } else if (getMonthSubString.contains("00")) {
            dateFormateParse = afterAlldataNewstringgnoExistSpecial;
          } else {
            String formatedate = DateTime.parse(
                    addNewYearMakeFullYear.toString() +
                        getMonthSubString.toString() +
                        getDaysSubString.toString())
                .toIso8601String();

            String? formateDateData =
                DateFormat.yMMMMd().format(DateTime.parse(formatedate));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${formateDateData})";
          }

          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': dateFormateParse
          });
        } else {
          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': getFirstVIIStringg
          });
        }
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

        if (key["identifer"].contains("11") ||
            key["identifer"].contains("12") ||
            key["identifer"].contains("13") ||
            key["identifer"].contains("15") ||
            key["identifer"].contains("17")) {
          String? afterAlldataNewstringgnoExistSpecial =
              getFirstVIIStringg.toString();
          String getDateString = afterAlldataNewstringgnoExistSpecial;
          String? getYearSubString =
              afterAlldataNewstringgnoExistSpecial.substring(0, 2);
          String getMonthSubString =
              afterAlldataNewstringgnoExistSpecial.substring(2, 4);
          String getDaysSubString =
              afterAlldataNewstringgnoExistSpecial.substring(4, 6);

          String? dateFormateParse;

          String? addNewYearMakeFullYear = "20" + getYearSubString.toString();

          if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00") &&
              getYearSubString.contains("00")) {
            dateFormateParse = "$afterAlldataNewstringgnoExistSpecial";
          } else if (getDaysSubString.contains("00") &&
              getMonthSubString.contains("00")) {
            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${addNewYearMakeFullYear})";
          } else if (getDaysSubString.contains("00") &&
              !getMonthSubString.contains("00")) {
            String formatedate = DateFormat('MMMM')
                .format(DateTime(0, int.parse(getMonthSubString)));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial($formatedate $addNewYearMakeFullYear)";
          } else if (getMonthSubString.contains("00")) {
            dateFormateParse = afterAlldataNewstringgnoExistSpecial;
          } else {
            String formatedate = DateTime.parse(
                    addNewYearMakeFullYear.toString() +
                        getMonthSubString.toString() +
                        getDaysSubString.toString())
                .toIso8601String();

            String? formateDateData =
                DateFormat.yMMMMd().format(DateTime.parse(formatedate));

            dateFormateParse =
                "$afterAlldataNewstringgnoExistSpecial(${formateDateData})";
          }

          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': dateFormateParse
          });
        } else {
          resultMap.add({
            'identifer': key["identifer"],
            'title': key["title"],
            'value': getFirstVIIStringg
          });
        }

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

        CalculateCompanyPrefix(getData);

        for (int i = 0; i < getLocalstoreData.length; i++) {
          if (getData! == getLocalstoreData[i]['id']) {
            setState(() {
              productName = getLocalstoreData[i]['plain1'];
              CompanyName = getLocalstoreData[i]['cline3'];
              suplychain = getLocalstoreData[i]['sline4'];

              log("Supplu chain ${suplychain.toString()}");
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
  // Future shareScreenshot(Uint8List bytes) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final image = File("${directory.path}/flutter.png"); //for share ScreenShot
  //   image.writeAsBytesSync(bytes);
  //   await Share.shareFiles([image.path]);
  // }

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
      ShowDialogBox("image null");
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
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/dna.png',
                    ),
                    fit: BoxFit.cover)),
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  color: resultbackgroundColor,
                  child: Column(
                    children: [
                      Text(
                        resultMap.isNotEmpty ? 'GS1 128' : 'CODE 128',
                        style: GoogleFonts.roboto(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      getSpecialCharacter != '29'
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('${getqrcoderesult}'),
                              ],
                            )
                          : Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: qrResultConvertList.map((item) {
                                if (item == getqrcoderesult![0]) {
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
                      //   "${getqrcoderesult}",
                      //   style: GoogleFonts.roboto(
                      //       color: Colors.black.withOpacity(0.5),
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.w300),
                      // )
                    ],
                  ),
                ),
                getSpecialCharacter != '29'
                    ? Container(
                        padding: EdgeInsets.only(top: 10),
                        margin: EdgeInsets.symmetric(horizontal: 20),
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
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              resultMap.length == 0
                                  ? Text(
                                      'Invalid Code 128',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.red,
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(top: 10),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Table(
                                        columnWidths: const <int,
                                            TableColumnWidth>{
                                          0: FlexColumnWidth(1),
                                        },
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        children: <TableRow>[
                                          TableRow(children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(
                                                          color: Colors.black45,
                                                          width: 0.5),
                                                      left: BorderSide(
                                                          color: Colors.black45,
                                                          width: 0.5),
                                                      right: BorderSide(
                                                          color: Colors.black45,
                                                          width: 0.5))),
                                              child: Text(
                                                "SCANNED INFORMATION",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: <Widget>[
                                            getCountryName!.isEmpty
                                                ? Container()
                                                : Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 5),
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            top: BorderSide(
                                                                color: Colors
                                                                    .black45,
                                                                width: 0.5),
                                                            left: BorderSide(
                                                                color: Colors
                                                                    .black45,
                                                                width: 0.5),
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .black45,
                                                                width: 0.5))),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "The Product is from",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .black54),
                                                                ),
                                                                Text(
                                                                  " ${getCountryName}(${getPrefixString})",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color:
                                                                          colorPrimaryLightBlue),
                                                                ),
                                                              ]),
                                                          getCGPLengthofString!
                                                                  .isEmpty
                                                              ? Container()
                                                              : Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "GCP is",
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.black54),
                                                                    ),
                                                                    Text(
                                                                      " ${getCGPLengthofString}",
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              colorPrimaryLightBlue),
                                                                    ),
                                                                  ],
                                                                )
                                                        ]),
                                                  ),
                                          ]),
                                          TableRow(children: <Widget>[
                                            Table(
                                              border: TableBorder.all(
                                                  color: Colors.black45,
                                                  width: 0.5),
                                              columnWidths: <int,
                                                  TableColumnWidth>{
                                                0: MinColumnWidth(
                                                  const IntrinsicColumnWidth(),
                                                  FixedColumnWidth(
                                                    MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4 +
                                                        05,
                                                  ),
                                                ),
                                                1: const FlexColumnWidth(1)
                                              },
                                              defaultVerticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              children: <TableRow>[
                                                for (int i = 0;
                                                    i < resultMap.length;
                                                    i++) ...[
                                                  TableRow(children: <Widget>[
                                                    TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .top,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          right: 5,
                                                          top: 8,
                                                          bottom: 8,
                                                          left: 5,
                                                        ),
                                                        child: Text(
                                                          '${resultMap[i]['title']}(${resultMap[i]['identifer']})',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  colorPrimaryLightBlue),
                                                        ),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      verticalAlignment:
                                                          TableCellVerticalAlignment
                                                              .top,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          right: 5,
                                                          top: 8,
                                                          bottom: 8,
                                                          left: 5,
                                                        ),
                                                        child: Text(
                                                          '${resultMap[i]['value']}',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ]
                                              ],
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ),
                              SizedBox(height: 10),
                              productName == null &&
                                      CompanyName == null &&
                                      suplychain == null
                                  ? Container()
                                  : Container(
                                      padding: EdgeInsets.only(top: 10),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Table(
                                          columnWidths: const <int,
                                              TableColumnWidth>{
                                            0: FlexColumnWidth(1),
                                          },
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          children: <TableRow>[
                                            TableRow(children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                  top: BorderSide(
                                                      color: Colors.black45,
                                                      width: 0.5),
                                                  left: BorderSide(
                                                      color: Colors.black45,
                                                      width: 0.5),
                                                  right: BorderSide(
                                                      color: Colors.black45,
                                                      width: 0.5),
                                                )),
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Text(
                                                  "MASTER DATA",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: <Widget>[
                                              Table(
                                                  border: TableBorder.all(
                                                      color: Colors.black45,
                                                      width: 0.5),
                                                  columnWidths: <int,
                                                      TableColumnWidth>{
                                                    0: MinColumnWidth(
                                                      const IntrinsicColumnWidth(),
                                                      FixedColumnWidth(
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.4 +
                                                            05,
                                                      ),
                                                    ),
                                                    1: const FlexColumnWidth(1)
                                                  },
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  children: <TableRow>[
                                                    productName == null
                                                        ? TableRow(
                                                            children: <Widget>[
                                                                Container(),
                                                                Container(),
                                                              ])
                                                        : TableRow(
                                                            children: <Widget>[
                                                                TableCell(
                                                                  verticalAlignment:
                                                                      TableCellVerticalAlignment
                                                                          .top,
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      right: 5,
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      left: 5,
                                                                    ),
                                                                    child: Text(
                                                                      'PRODUCT',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              colorPrimaryLightBlue),
                                                                    ),
                                                                  ),
                                                                ),
                                                                productName ==
                                                                        null
                                                                    ? Text('')
                                                                    : TableCell(
                                                                        verticalAlignment:
                                                                            TableCellVerticalAlignment.top,
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.only(
                                                                            right:
                                                                                5,
                                                                            top:
                                                                                8,
                                                                            bottom:
                                                                                8,
                                                                            left:
                                                                                5,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            '$productName',
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(color: Colors.black54),
                                                                          ),
                                                                        ),
                                                                      ),
                                                              ]),
                                                    CompanyName == null
                                                        ? TableRow(
                                                            children: <Widget>[
                                                                Container(),
                                                                Container(),
                                                              ])
                                                        : TableRow(
                                                            children: <Widget>[
                                                                TableCell(
                                                                  verticalAlignment:
                                                                      TableCellVerticalAlignment
                                                                          .top,
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      right: 5,
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      left: 5,
                                                                    ),
                                                                    child: Text(
                                                                      'COMPANY',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              colorPrimaryLightBlue),
                                                                    ),
                                                                  ),
                                                                ),
                                                                CompanyName ==
                                                                        null
                                                                    ? Text('')
                                                                    : TableCell(
                                                                        verticalAlignment:
                                                                            TableCellVerticalAlignment.top,
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.only(
                                                                            right:
                                                                                5,
                                                                            top:
                                                                                8,
                                                                            bottom:
                                                                                8,
                                                                            left:
                                                                                5,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            '$CompanyName',
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(color: Colors.black54),
                                                                          ),
                                                                        ),
                                                                      ),
                                                              ]),
                                                    suplychain == null &&
                                                            suplychain
                                                                    .runtimeType ==
                                                                Null
                                                        ? TableRow(
                                                            children: <Widget>[
                                                                Container(),
                                                                Container(),
                                                              ])
                                                        : TableRow(
                                                            children: <Widget>[
                                                                TableCell(
                                                                  verticalAlignment:
                                                                      TableCellVerticalAlignment
                                                                          .top,
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      right: 5,
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      left: 5,
                                                                    ),
                                                                    child: Text(
                                                                      'SUPPLY CHAIN',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              colorPrimaryLightBlue),
                                                                    ),
                                                                  ),
                                                                ),
                                                                TableCell(
                                                                  verticalAlignment:
                                                                      TableCellVerticalAlignment
                                                                          .top,
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      right: 5,
                                                                      top: 8,
                                                                      bottom: 8,
                                                                      left: 5,
                                                                    ),
                                                                    child: Text(
                                                                      '${suplychain}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black54),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]),
                                                  ]),
                                            ]),
                                          ]),
                                    ),
                              SizedBox(height: 60),
                            ]),
                      ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  CalculateCompanyPrefix(String? gTIN) {
    //  log("data funcatoion call");
    // log(gTIN!.toString());

    String? deleteFirstDidgit = gTIN!.substring(1, gTIN.length);
    log(deleteFirstDidgit.toString());

    String getFirstSevenDigit = deleteFirstDidgit.substring(0, 7);
    String getFirstFiveDigit = deleteFirstDidgit.substring(0, 5);
    String getFirstFourDigit = deleteFirstDidgit.substring(0, 4);
    String getFirstThreeDigit = deleteFirstDidgit.substring(0, 3);

    //  log(getFirstSevenDigit.toString());
    //  log(getFirstFiveDigit.toString());
    //  log(getFirstFourDigit.toString());
    //  log(getFirstThreeDigit.toString());

    for (int i = 0; i < companyPrefix.length; i++) {
      if (companyPrefix[i]['prefix'].toString() ==
          getFirstSevenDigit.toString()) {
        // log(companyPrefix[i]['Country'].toString());

        setState(() {
          getCountryName = companyPrefix[i]['Country'].toString();
          getPrefixString = getFirstSevenDigit.toString();
        });
        getGCPLengthFromPRefix(deleteFirstDidgit, getFirstSevenDigit);
      } else if (companyPrefix[i]['prefix'].toString() ==
              getFirstFiveDigit.toString() ||
          companyPrefix[i]['minValue'] == getFirstFiveDigit.toString() ||
          companyPrefix[i]['maxValue'] == getFirstFiveDigit.toString() ||
          (int.parse(companyPrefix[i]['minValue'].toString()) <
                  int.parse(getFirstFiveDigit.toString()) &&
              int.parse(companyPrefix[i]['maxValue'].toString()) >
                  int.parse(getFirstFiveDigit.toString()))) {
        // log(companyPrefix[i]['Country'].toString());
        setState(() {
          getCountryName = companyPrefix[i]['Country'].toString();
          getPrefixString = getFirstFiveDigit.toString();
        });
        getGCPLengthFromPRefix(deleteFirstDidgit, getFirstFiveDigit);
      } else if (companyPrefix[i]['prefix'].toString() ==
              getFirstFourDigit.toString() ||
          companyPrefix[i]['minValue'] == getFirstFourDigit.toString() ||
          companyPrefix[i]['maxValue'] == getFirstFourDigit.toString() ||
          int.parse(companyPrefix[i]['minValue'].toString()) <
                  int.parse(getFirstFourDigit) &&
              int.parse(companyPrefix[i]['maxValue'].toString()) >
                  int.parse(getFirstFourDigit)) {
        // log(companyPrefix[i]['Country'].toString());
        setState(() {
          getCountryName = companyPrefix[i]['Country'].toString();
          getPrefixString = getFirstFourDigit.toString();
        });
        getGCPLengthFromPRefix(deleteFirstDidgit, getFirstFourDigit);
      } else if (companyPrefix[i]['prefix'].toString() ==
              getFirstThreeDigit.toString() ||
          companyPrefix[i]['minValue'] == getFirstThreeDigit.toString() ||
          companyPrefix[i]['maxValue'] == getFirstThreeDigit.toString() ||
          int.parse(companyPrefix[i]['minValue'].toString()) <
                  int.parse(getFirstThreeDigit) &&
              int.parse(companyPrefix[i]['maxValue'].toString()) >
                  int.parse(getFirstThreeDigit)) {
        setState(() {
          getCountryName = companyPrefix[i]['Country'].toString();
          getPrefixString = getFirstThreeDigit.toString();
        });
        getGCPLengthFromPRefix(deleteFirstDidgit, getFirstThreeDigit);

        // log(companyPrefix[i]['Country'].toString());

      }
    }
  }

  getGCPLengthFromPRefix(String? gTNILength, String? subStringPrefix) {
    // log(gTNILength.toString());
    // log(subStringPrefix.toString());

    String? getSubStringt13Digit = gTNILength!.substring(0, gTNILength.length);
    String? getSubString12Digit =
        gTNILength.substring(0, gTNILength.length - 1);
    String? getSubString11Digit =
        gTNILength.substring(0, gTNILength.length - 2);
    String? getSubString10Digit =
        gTNILength.substring(0, gTNILength.length - 3);
    String? getSubStringth9Digit =
        gTNILength.substring(0, gTNILength.length - 4);
    String? getSubString8Digit = gTNILength.substring(0, gTNILength.length - 5);
    String? getSubString7Digit = gTNILength.substring(0, gTNILength.length - 6);
    String? getSubString6Digit = gTNILength.substring(0, gTNILength.length - 7);
    String? getSubString5Digit = gTNILength.substring(0, gTNILength.length - 8);
    String? getSubString4Digit = gTNILength.substring(0, gTNILength.length - 9);
    String? getSubString3Digit =
        gTNILength.substring(0, gTNILength.length - 10);

    for (int i = 0; i < gCPPrefixList.length; i++) {
      if (gCPPrefixList[i]["prefix"].toString() ==
          getSubStringt13Digit.toString()) {
        int? getLength = int.parse(gCPPrefixList[i]["gcpLength"].toString());
        setState(() {
          getCGPLengthofString = gTNILength.substring(0, getLength).toString();
        });
      } else if (gCPPrefixList[i]["prefix"].toString() ==
          getSubString12Digit.toString()) {
        int? getLength = int.parse(gCPPrefixList[i]["gcpLength"].toString());
        setState(() {
          getCGPLengthofString = gTNILength.substring(0, getLength).toString();
        });
      } else if (gCPPrefixList[i]["prefix"].toString() ==
          getSubString11Digit.toString()) {
        int? getLength = int.parse(gCPPrefixList[i]["gcpLength"].toString());
        setState(() {
          getCGPLengthofString = gTNILength.substring(0, getLength).toString();
        });
      } else if (gCPPrefixList[i]["prefix"].toString() ==
          getSubString10Digit.toString()) {
        int? getLength = int.parse(gCPPrefixList[i]["gcpLength"].toString());
        setState(() {
          getCGPLengthofString = gTNILength.substring(0, getLength).toString();
        });
      } else if (gCPPrefixList[i]["prefix"].toString() ==
          getSubStringth9Digit.toString()) {
        int? getLength = int.parse(gCPPrefixList[i]["gcpLength"].toString());
        setState(() {
          getCGPLengthofString = gTNILength.substring(0, getLength).toString();
        });
      } else if (gCPPrefixList[i]["prefix"].toString() ==
          getSubString8Digit.toString()) {
        int? getLength = int.parse(gCPPrefixList[i]["gcpLength"].toString());
        setState(() {
          getCGPLengthofString = gTNILength.substring(0, getLength).toString();
        });
      } else if (gCPPrefixList[i]["prefix"].toString() ==
          getSubString7Digit.toString()) {
        int? getLength = int.parse(gCPPrefixList[i]["gcpLength"].toString());
        setState(() {
          getCGPLengthofString = gTNILength.substring(0, getLength).toString();
        });
      } else if (gCPPrefixList[i]["prefix"].toString() ==
          getSubString6Digit.toString()) {
        int? getLength = int.parse(gCPPrefixList[i]["gcpLength"].toString());
        setState(() {
          getCGPLengthofString = gTNILength.substring(0, getLength).toString();
        });
      } else if (gCPPrefixList[i]["prefix"].toString() ==
          getSubString5Digit.toString()) {
        int? getLength = int.parse(gCPPrefixList[i]["gcpLength"].toString());
        setState(() {
          getCGPLengthofString = gTNILength.substring(0, getLength).toString();
        });
      } else if (gCPPrefixList[i]["prefix"].toString() ==
          getSubString4Digit.toString()) {
        int? getLength = int.parse(gCPPrefixList[i]["gcpLength"].toString());
        setState(() {
          getCGPLengthofString = gTNILength.substring(0, getLength).toString();
        });
      } else if (gCPPrefixList[i]["prefix"].toString() ==
          getSubString3Digit.toString()) {
        int? getLength = int.parse(gCPPrefixList[i]["gcpLength"].toString());
        setState(() {
          getCGPLengthofString = gTNILength.substring(0, getLength).toString();
        });
      }
    }

    //  log("the length get is");
    //  log(getCGPLengthofString.toString());
  }
}
