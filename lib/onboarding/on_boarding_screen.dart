import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:get/get.dart';
import 'package:qr_scrnner/bottombar/bottombar_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        pageBackgroundColor: Colors.white,
        finishButtonText: 'Get Started',
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        skipTextButton: const Text(
          'Skip',
          style: TextStyle(fontSize: 16, color: Colors.blueAccent),
        ),
        controllerColor: Colors.blueAccent,
        totalPage: 3,
        background: [
          _buildBackgroundImage('assets/slide_1.jpg'),
          _buildBackgroundImage('assets/slide_2.jpg'),
          _buildBackgroundImage('assets/slider_3.jpg'),
        ],
        pageBodies: [
          _buildOnboardingContent(
            title: 'Scan QR Codes',
            description: 'Easily scan any QR code to get instant information.',
          ),
          _buildOnboardingContent(
            title: 'Generate QR Codes',
            description: 'Create your own QR codes for sharing and access.',
          ),
          _buildOnboardingContent(
            title: 'Save Scan History',
            description:
                'Your scanned QR codes are saved locally for quick access anytime.',
          ),
        ],
        onFinish: () {
          Get.to(BottomBarScreen());
        },
        speed: 5,
      ),
    );
  }

  Widget _buildOnboardingContent(
      {required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(String assetPath) {
    return Container(
      width: Get.width,
      color: Colors.white,
      child: Center(
        child: Image.asset(assetPath, height: 300, fit: BoxFit.contain),
      ),
    );
  }
}
