import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pharma_trax_scanner/Widgets/app_drawer.dart';
import 'package:pharma_trax_scanner/Widgets/db_helper.dart';
import 'package:pharma_trax_scanner/screens/barcode__resultscreen.dart';
import 'package:pharma_trax_scanner/screens/qr_result.dart';
import 'package:pharma_trax_scanner/utils/colors.dart';

import '../utils/globalValue.dart';

class ScanHistory extends StatefulWidget {
  const ScanHistory({Key? key}) : super(key: key);

  static const routeName = '/scan_history';

  @override
  State<ScanHistory> createState() => _ScanHistoryState();
}

class _ScanHistoryState extends State<ScanHistory> {
  final dbhelper = DataBaseHelper.instance;

  List<Map<String, dynamic>> data = [];

  Future<void> fatchData() async {
    data = await dbhelper.fatchTable2();
    data = data.reversed.toList();

    log(data.toString());
    setState(() {});
  }

  Future<void>? deleteData() {
    _delete(context);
  }

  void _delete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                padding: const EdgeInsets.only(right: 5),
                child: Image.asset(
                  "assets/images/trash.png",
                  color: blueColor2,
                ),
              ),
              const Text('Clear History'),
            ],
          ),
          content: const Text('Do you really want to clear scan history?'),
          actions: [
            TextButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Colors.red.shade700,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.red.shade700,
                  ),
                ),
                onPressed: () async {
                  await dbhelper.deleteTable2();
                  setState(() {
                    data = [];
                    Navigator.of(context).pop();
                  });
                })
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    fatchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
Future<bool> _onWillPop() async {
        indexClicked = 0;
       await Navigator.of(context).pushReplacementNamed('/home_screen');
    return true;
  }
    return WillPopScope(
      onWillPop:_onWillPop,
      child: Scaffold(
        drawer: const AppDrawer(),
        
        appBar: AppBar(
          backgroundColor: colorPrimaryLightBlue,
          title: const Text("Scan History"),
          actions: [
            IconButton(
              icon: const ImageIcon(
                AssetImage("assets/images/trash.png"),
                color: Colors.white,
              ),
              onPressed: deleteData,
            ),
            // add more IconButton
          ],
        ),
        body: SafeArea(
          child: Container(
            
            height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/dna.png',),fit: BoxFit.cover)),
            child: Column(
              children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: resultbackgroundColor,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Scan History',style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w500,fontSize: 14),),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      
                      children: [
                      InkWell(
                        onTap: () {
                             if(data[index]['barcode_type'] == "DATA MATRIX (GS1)"  || data[index]['barcode_type'] == "DATA MATRIX") {
       Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QRCodeResultScreen(
                                    data[index]['id'],
                                    data[index]['barcode_type'],
                                    false),
                              ));

                            }else{
                                     Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BarCodeResultScreen(
                                    data[index]['id'],
                                    data[index]['barcode_type'],
                                    
                                    false),
                              ));
                            }
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Row(children: [
                      
                            CircleAvatar(
                              radius: 28,
                                      backgroundColor: blueColor1,
                                      child: data[index]['barcode_type'].toString() == 'DATA MATRIX (GS1)' || data[index]['barcode_type'].toString() == 'DATA MATRIX' 
                                  ?  ImageIcon(
                                  
                                        AssetImage("assets/images/data_matrix.png",
                                        
                                      
                                        ),
                                        size: 35,
                                        color: Colors.white,
                                      ):ImageIcon(
                                        AssetImage("assets/images/code_128.png"),
                                          size: 35,
                                        color: Colors.white,
                                      ),
                                    ),
                      
                                    SizedBox(width: 5,),
                      
                      
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                                                      "${data[index]['id'].substring(1, data[index]['id'].length)}",
                                                                      style: TextStyle(fontWeight: FontWeight.bold,
                                                                      color: Colors.black87
                                                                      ),
                                                                      overflow: TextOverflow.ellipsis),
                                                                      SizedBox(height: 3,),
                      
                                                 Row(
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                   Text(
                                      "Type: ",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                  Text(
                                      " ${data[index]['barcode_type']}",
                                      
                                      ),
                                ],
                              ),
                                SizedBox(height: 3,),
                                   Row(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                      Text(
                                  "Scanned At: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  
                                       Text(
                                  " ${data[index]['date']}",
                                  
                                  ),
                          
                                     ],
                                   ),                     
                                        ],
                                      ),
                                    ),
                      
                      
                      
                      
                          ],),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                        
                      ),
                    ]);
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
