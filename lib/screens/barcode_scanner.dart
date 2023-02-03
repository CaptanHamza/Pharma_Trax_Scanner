import 'dart:developer';

import 'package:fast_barcode_scanner/fast_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/colors.dart';
import 'barcode__resultscreen.dart';

class BarCodeScanner extends StatefulWidget {
  const BarCodeScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BarCodeScannerState();
}

class _BarCodeScannerState extends State<BarCodeScanner>
    with SingleTickerProviderStateMixin {
 
  AnimationController? _animationController;

  @override
  initState() {
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    _animationController!.repeat(reverse: true);
  
    setState(() {});
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      //DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

  

    super.initState();
    // checkResult();
  }

  String? code;

  @override
  Widget build(BuildContext context) {
    


    return Scaffold(
      appBar: AppBar(
        title: Text("SCAN GS1 128 BARCODE"),
        centerTitle: true,
        backgroundColor: colorPrimaryLightBlue,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Transform.rotate(
              angle: -1.6 + 0.06,
              child: BarcodeCamera(
                types: const [BarcodeType.code128],
                resolution: Resolution.hd720,
                framerate: Framerate.fps30,
                mode: DetectionMode.pauseDetection,
                onScan: (code) {
                  log(code.value.toString());

                  if (code.value.substring(0, 3) == "]C1") {
                    // log("yes");

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BarCodeResultScreen(
                                "",
                                rawByteCode: code.value.toString(),
                                "GS1 128 ",
                                true)));
                  } else {
                    //  log("No");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BarCodeResultScreen(
                                "",
                                rawByteCode: code.toString(),
                                "CODE 128",
                                true)));
                  }
                },
                children: [
                  // Transform.rotate(
                  //   angle: -1.6,
                  //   child: MaterialPreviewOverlay(
                  //       aspectRatio: 16 / 3, animateDetection: false),
                  // ),
                  // BlurPreviewOverlay(),

                  Transform.rotate(
                    angle: -1.6,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: ShapeDecoration(
                        shape: CardScannerOverlayShape(
                          borderColor: Colors.white,
                          borderRadius: 12,
                          borderLength: 32,
                          borderWidth: 8,
                        ),
                      ),
                      child: FadeTransition(
                        opacity: _animationController!,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              height: MediaQuery.of(context).size.height,
                              color: Colors.red,
                              width: 1,
                            ),
                            Positioned(
                                child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.red,
                              height: 1,
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  color: Colors.transparent,
                  child: Text(
                    'Point at any  GS1 128  Barcode to scan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // controller?.dispose();
    super.dispose();
  }
}

class CardScannerOverlayShape extends ShapeBorder {
  const CardScannerOverlayShape({
    this.borderColor = Colors.blue,
    this.borderWidth = 8.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 10,
    this.borderLength = 32,
    this.cutOutBottomOffset = 0,
  });

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutBottomOffset;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final cardWidth = rect.width - 20;
    final cardHeight = rect.height - 40;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + 10,
      rect.top + 30,
      cardWidth,
      cardHeight,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - borderLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + borderLength,
          topRight: Radius.circular(0),
        ),
        borderPaint,
      )
      // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + borderLength,
          cutOutRect.top + borderLength,
          topLeft: Radius.circular(0),
        ),
        borderPaint,
      )
      // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - borderLength,
          cutOutRect.bottom - borderLength,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(0),
        ),
        borderPaint,
      )
      // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - borderLength,
          cutOutRect.left + borderLength,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(0),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(0),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return CardScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
