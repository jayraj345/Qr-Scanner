// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scrnner/helper/fontfamily.dart';
import 'package:qr_scrnner/qr_screen/qr_controller.dart';

class QRCodeGeneratorScreen extends StatelessWidget {
  QRCodeGeneratorScreen({super.key});

  final QRController controller = Get.put(QRController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF575799),
        leading: SizedBox(),
        centerTitle: true,
        title: Text(
          "QR Code Generator",
          style: TextStyle(
            color: Colors.white,
            fontFamily: FontFamily.satoshiBold,
            fontSize: 18,
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          _generateQRData();
          controller.triggerAnimation();
        },
        child: Container(
          height: 45,
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                'Generate QR',
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
                blurRadius: 0,
              )
            ],
          ),
        ),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${controller.qrType.value}:',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: FontFamily.satoshiBold,
                ),
              ),
              const SizedBox(height: 20),
              if (controller.qrType.value == "Text")
                _buildTextInputField('Enter any text to generate QR'),
              if (controller.qrType.value == "WhatsApp")
                _buildTextInputField(
                    'Enter WhatsApp number (with country code)'),
              if (controller.qrType.value == "Instagram")
                _buildTextInputField('Enter Instagram profile URL'),
              if (controller.qrType.value == "Gmail") _buildGmailInputFields(),
              if (controller.qrType.value == "Spotify")
                _buildTextInputField('Enter Spotify link'),
              if (controller.qrType.value == "Twitter")
                _buildTextInputField('Enter X (Twitter) profile URL'),
              if (controller.qrType.value == "TikTok")
                _buildTextInputField('Enter TikTok profile URL'),
              if (controller.qrType.value == "Facebook")
                _buildTextInputField('Enter Facebook profile URL'),
              if (controller.qrType.value == "LinkedIn")
                _buildTextInputField('Enter LinkedIn profile URL'),
              const SizedBox(height: 40),
              _buildAnimatedQR(),
            ],
          ),
        );
      }),
    );
  }

  // Build a text input field
  Widget _buildTextInputField(String label) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF575799),
            offset: Offset(6, 6),
            blurRadius: 0,
          )
        ],
      ),
      child: TextField(
        controller: controller.inputController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black,
            fontFamily: FontFamily.satoshiRegular,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // Build Gmail-specific input fields
  Widget _buildGmailInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField(controller.emailController, 'Enter Email Address'),
        const SizedBox(height: 20),
        _buildField(controller.subjectController, 'Enter Subject'),
        const SizedBox(height: 20),
        _buildField(controller.bodyController, 'Enter Email Body'),
      ],
    );
  }

  Widget _buildField(TextEditingController ctrl, String label) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF575799),
            offset: Offset(6, 6),
            blurRadius: 0,
          )
        ],
      ),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black,
            fontFamily: FontFamily.satoshiRegular,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // Generate QR data
  void _generateQRData() {
    switch (controller.qrType.value) {
      case "WhatsApp":
        controller.qrData.value =
            "https://wa.me/${controller.inputController.text}";
        break;
      case "Instagram":
      case "Spotify":
      case "Twitter":
      case "TikTok":
      case "Facebook":
      case "LinkedIn":
        controller.qrData.value = controller.inputController.text;
        break;
      case "Gmail":
        controller.qrData.value =
            "mailto:${controller.emailController.text}?subject=${Uri.encodeComponent(controller.subjectController.text)}&body=${Uri.encodeComponent(controller.bodyController.text)}";
        break;
      default:
        controller.qrData.value = controller.inputController.text;
    }
  }

  // Build the animated QR Code
  Widget _buildAnimatedQR() {
    return Obx(() => controller.showQR.value
        ? SlideTransition(
            position: controller.slideAnimation,
            child: Center(
              child: QrImageView(
                data: controller.qrData.value,
                size: 250,
              ),
            ),
          )
        : const SizedBox());
  }
}
