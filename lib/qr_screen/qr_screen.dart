import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scrnner/helper/fontfamily.dart';
import 'package:qr_scrnner/qr_screen/qr_controller.dart';

class QRGeneratorScreen extends StatelessWidget {
  final QRController controller = Get.put(QRController());

  QRGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Code Generator',
          style: TextStyle(
            color: Colors.white,
            fontFamily: FontFamily.satoshiMedium,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF575799),
        leading: SizedBox(),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select QR Code Type:',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: FontFamily.satoshiBold,
                ),
              ),
              const SizedBox(height: 30),
              _buildQRTypeButtons(),
              const SizedBox(height: 80),
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
              const SizedBox(height: 60),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     _generateQRData();
              //     controller.triggerAnimation();
              //   },
              //   icon: const Icon(Icons.qr_code),
              //   label: const Text(
              //     'Generate QR',
              //     style: TextStyle(
              //       fontFamily: FontFamily.satoshiMedium,
              //     ),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.blue.shade200,
              //     minimumSize: const Size(double.infinity, 50),
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  _generateQRData();
                  controller.triggerAnimation();
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
                          blurRadius: 0)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildAnimatedQR(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // Build QR type buttons
  Widget _buildQRTypeButtons() {
    final types = [
      "Text",
      "WhatsApp",
      "Instagram",
      "Gmail",
      "Spotify",
      "Twitter",
      "TikTok",
      "Facebook",
      "LinkedIn"
    ];
    final logo = [
      "assets/text.png",
      "assets/whatsapp.png",
      "assets/instagram.png",
      "assets/gmail.png",
      "assets/spotify.png",
      "assets/twitter.png",
      "assets/tik-tok.png",
      "assets/facebook.png",
      "assets/linkedin.png"
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(
        types.length,
        (index) => GestureDetector(
          onTap: () {
            controller.qrType.value = types[index];
            controller.qrData.value = "";
            controller.showQR.value = false;
            controller.inputController.clear();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Color(0xFFd3d3ff),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xFF575799),
                      offset: Offset(6, 6),
                      blurRadius: 0)
                ]),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  logo[index],
                  height: 20,
                  width: 20,
                  color: Color(0xFF575799),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  types[index],
                  style: TextStyle(
                    fontFamily: FontFamily.satoshiRegular,
                    color: Color(0xFF575799),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
        const SizedBox(height: 10),
        _buildField(controller.subjectController, 'Enter Subject'),
        const SizedBox(height: 10),
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
