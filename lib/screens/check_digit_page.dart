import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Widgets/app_drawer.dart';
import '../utils/colors.dart';

class CheckDigitPage extends StatefulWidget {
  const CheckDigitPage({super.key});

  @override
  State<CheckDigitPage> createState() => _CheckDigitPageState();
}

class _CheckDigitPageState extends State<CheckDigitPage> {
  int sumofTotalNumber = 0;
  List<int> gernateListOFString = [];
  int? checkLastDigit;
  int? multiplyValue;
  final textController = TextEditingController();
  String? messageDisplay = "";
  bool erroType = false;
  final formGlobalKey = GlobalKey<FormState>();
  Color? customColor;
  bool checkerroMessage = false;

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacementNamed('/home_screen');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: const AppDrawer(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: colorPrimaryLightBlue,
          title: const Text(
            "Calculate Check Digit",
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/dna.png'))),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Please enter the number for check digit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              fontSize: 15),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: textController,
                          //       validator: (number) {

                          //         if(number!.isEmpty){
                          //           return "Enter valid value";
                          //         }else if(number.length < 7){
                          //           return "Enter atleast 7 value";

                          //         }

                          //    else
                          //      return null;
                          //  },
                          maxLength: 17,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],

                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),

                          decoration: const InputDecoration(
                              counterText: "",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              hintText: 'Enter Number',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.grey))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          height: 60,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            color: colorPrimaryLightBlue,
                            onPressed: () async {
                              // if(formGlobalKey.currentState!.validate()){
                              setState(() {
                                sumofTotalNumber = 0;
                                gernateListOFString = [];
                                checkLastDigit = null;
                                multiplyValue = 0;
                              });
                              checkGSLastDigitFun(
                                  textController.text.toString().trim());
                            },
                            // },

                            child: const Text(
                              'CALCULATE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // checkLastDigit == null
                        //     ? const Center()
                        //     : Text(
                        //         "Your check digit is: ${checkLastDigit}",
                        //         style: const TextStyle(
                        //             color: Colors.green,
                        //             fontSize: 20,
                        //             fontWeight: FontWeight.w500),
                        //       ),
                        const SizedBox(
                          height: 15,
                        ),
                        checkLastDigit == null
                            ? Container()
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xFF155724)),
                                    color: customColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 40,
                                      color: Color(0xFF155724),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Your check digit is: ${checkLastDigit}",
                                            style: const TextStyle(
                                                color: Color(0xFF155724),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            messageDisplay.toString(),
                                            style: TextStyle(
                                                color: Color(0xFF155724)
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.5,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),

                        checkerroMessage == true
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xFF9d1d26)),
                                    color: customColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.cancel_outlined,
                                      size: 40,
                                      color: Color(0xFF9d1d26),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "OPPS!",
                                            style: const TextStyle(
                                                color: Color(0xFF9d1d26),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            messageDisplay.toString(),
                                            style: TextStyle(
                                                color: Color(0xFF9d1d26)
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.5,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkGSLastDigitFun(String number) {
    if (number.length == 7) {
      setState(() {
        erroType = false;
        checkerroMessage = false;

        multiplyValue = 3;
        messageDisplay =
            "You've entered 7 digits, this corresponds with the GTIN-8 format";
        customColor = Color(0xFFd4edda);
      });

      caluclutefun(number);
    } else if (number.length == 11) {
      setState(() {
        erroType = false;
        checkerroMessage = false;
        multiplyValue = 3;
        messageDisplay =
            "You've entered 11 digits, this corresponds with the GTIN-12 format.";
        customColor = Color(0xFFd4edda);
      });

      caluclutefun(number);
    } else if (number.length == 12) {
      setState(() {
        erroType = false;
        checkerroMessage = false;
        multiplyValue = 1;
        messageDisplay =
            "You've entered 12 digits, this corresponds with the GTIN-13 format. It could also be a GLN or the first 13 digits of a GRAI, GDTI or GCN.";
        customColor = Color(0xFFd4edda);
      });
      caluclutefun(number);
    } else if (number.length == 13) {
      setState(() {
        erroType = false;
        checkerroMessage = false;
        multiplyValue = 3;
        messageDisplay =
            "You've entered 13 digits, this corresponds with a GTIN-14 format of the GTIN.";
        customColor = Color(0xFFd4edda);
      });
      caluclutefun(number);
    } else if (number.length == 16) {
      setState(() {
        erroType = false;
        checkerroMessage = false;
        multiplyValue = 1;
        messageDisplay =
            "You've entered 16 digits, this corresponds with the GSIN key.";
        customColor = Color(0xFFd4edda);
      });
      caluclutefun(number);
    } else if (number.length == 17) {
      setState(() {
        erroType = false;
        checkerroMessage = false;
        multiplyValue = 3;
        messageDisplay =
            "You've entered 17 digits, this corresponds with the SSCC or GSRN key.";
        customColor = Color(0xFFd4edda);
      });
      caluclutefun(number);
    } else {
      setState(() {
        erroType = true;
        checkerroMessage = true;
        messageDisplay =
            "The number you entered is not the right length for a GS1 key. Please try again?";
        customColor = Color(0xFFf8d7da);
      });
    }
  }

  void caluclutefun(String number) {
    for (int i = 0; i < number.length; i++) {
      gernateListOFString.add(int.parse(number[i]));
    }

    for (int i = 0; i < gernateListOFString.length; i++) {
      setState(() {
        sumofTotalNumber =
            sumofTotalNumber + (gernateListOFString[i] * multiplyValue!);
      });
      if (multiplyValue == 1) {
        setState(() {
          multiplyValue = 3;
        });
      } else if (multiplyValue == 3) {
        setState(() {
          multiplyValue = 1;
        });
      }
    }

    int getModules = sumofTotalNumber % 10;

    if (getModules == 0) {
      setState(() {
        checkLastDigit = 0;
      });
    } else {
      setState(() {
        checkLastDigit = 10 - getModules;
      });
    }
  }
}
