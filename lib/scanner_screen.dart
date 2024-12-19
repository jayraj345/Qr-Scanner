// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as qr;
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scrnner/helper/fontfamily.dart';
import 'package:qr_scrnner/webview_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Box? scannedDataBox;
  String scanResult = "Not Scanned Yet";
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  XFile? image;
  String? qrCodeResult;
  final ImagePicker picker = ImagePicker();
  final qr.BarcodeScanner barcodeScanner = qr.BarcodeScanner();

  Future<void> pickImageAndScanQR() async {
    try {
      image = await picker.pickImage(source: ImageSource.gallery);
      setState(() {});
      if (image != null) {
        setState(() {
          qrCodeResult = 'Processing image...';
        });

        final inputImage = qr.InputImage.fromFilePath(image!.path);
        final List<qr.Barcode> barcodes =
            await barcodeScanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          setState(() {
            qrCodeResult = barcodes.first.rawValue ?? 'No QR code found';
          });
          print("-------------------1---${qrCodeResult}");
          storeScannedData(
              qrCodeResult ?? "", getWebsiteNameFromUrl(qrCodeResult ?? ""));
          showDialogWidget(qrCodeResult ?? "");
        } else {
          setState(() {
            qrCodeResult = 'No QR code found in the image';
          });
          print("-------------------2---${qrCodeResult}");
          showDialogWidget(qrCodeResult ?? "");
        }
      } else {
        setState(() {
          qrCodeResult = 'No image selected';
        });
        print("-------------------3---${qrCodeResult}");
        showDialogWidget(qrCodeResult ?? "");
      }
    } catch (e) {
      setState(() {
        qrCodeResult = 'Error: ${e.toString()}';
      });
      showDialogWidget(qrCodeResult ?? "");
      print("-------------------4---${qrCodeResult}");
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  Future<void> storeScannedData(String barcode, String title) async {
    await scannedDataBox?.add({
      'title': title,
      'data': barcode,
    });
    print("Scanned data stored: Title - $title, Data - $barcode");
  }

  @override
  void initState() {
    super.initState();
    controller?.pauseCamera();
    scannedDataBox = Hive.box('scannedData');
  }

  String getWebsiteNameFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.host;
  }

  Future<void> safeResumeCamera() async {
    if (controller != null) {
      try {
        await controller?.resumeCamera();
      } catch (e) {
        print("Camera resume error: $e");
      }
    }
  }

  Future<void> safePauseCamera() async {
    if (controller != null) {
      try {
        await controller?.pauseCamera();
      } catch (e) {
        print("Camera pause error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF575799),
        leading: SizedBox(),
        centerTitle: true,
        title: Text(
          "Scan Qr Code",
          style: TextStyle(
            color: Colors.white,
            fontFamily: FontFamily.satoshiBold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        "Place QR code inside the frame to scan please avoid shake to get results quickly",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: FontFamily.satoshiMedium,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 150,
                  width: 150,
                  child: image != null
                      ? Image.file(File(image?.path ?? ""))
                      : _buildQrView(context),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Scanning Code..",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: FontFamily.satoshiMedium,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller?.pauseCamera();
                      pickImageAndScanQR();
                    },
                    child: Image.asset(
                      "assets/gallery.png",
                      height: 20,
                      width: 20,
                    ),
                  ),

                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context, MaterialPageRoute(
                  //       builder: (context) {
                  //         return ScanHistory();
                  //       },
                  //     ));
                  //   },
                  //   child: Image.asset(
                  //     "assets/history.png",
                  //     height: 20,
                  //     width: 20,
                  //   ),
                  // )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () async {
                  if (image != null) {
                    await safePauseCamera();
                    await Future.delayed(Duration(milliseconds: 500));
                    setState(() {
                      controller = null;
                      image = null;
                      qrCodeResult = null;
                    });
                    safeResumeCamera();
                  } else {
                    controller?.resumeCamera();
                  }
                },
                child: Container(
                  height: 45,
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code,
                        color: Color(0xFF575799),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Scan ',
                        style: TextStyle(
                          fontFamily: FontFamily.satoshiMedium,
                          color: Color(0xFF575799),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFd3d3ff),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xFF575799),
                          offset: Offset(6, 6),
                          blurRadius: 0)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    double scanArea = 150.0;

    return QRView(
      key: qrKey,
      formatsAllowed: [BarcodeFormat.qrcode],
      onQRViewCreated: _onQRViewCreated,
      cameraFacing: CameraFacing.back, // Use the back camera by default
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blueGrey,
        borderRadius: 10,
        borderLength: 20,
        borderWidth: 10,
        cutOutSize: scanArea, // This sets the scanning area to 150x150
      ),
    );
  }

  bool isOpen = false;

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      controller.pauseCamera();
      storeScannedData(
          result?.code ?? "", getWebsiteNameFromUrl(result?.code ?? ""));
      showDialogWidget(result?.code ?? "");
    });
  }

  showBottomSheetWidget(String title) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Scannig Data:",
                style: TextStyle(
                  fontFamily: FontFamily.satoshiBold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return WebViewScreen(
                        Url: title,
                      );
                    },
                  ));
                },
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: FontFamily.satoshiMedium,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.white,
          ),
        );
      },
    );
  }

  showDialogWidget(String title) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          clipBehavior: Clip.none,
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 150,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Scannig Result",
                  style: TextStyle(
                    fontFamily: FontFamily.satoshiBold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return WebViewScreen(
                          Url: title,
                        );
                      },
                    ));
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Clik",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.satoshiMedium,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
