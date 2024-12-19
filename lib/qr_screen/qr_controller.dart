import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class QRController extends GetxController with GetTickerProviderStateMixin {
  final box = GetStorage();
  var qrType = "Text".obs; // Default QR type
  var qrData = "".obs; // Holds the generated QR data
  var showQR = false.obs; // Controls animation visibility

  final TextEditingController inputController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  // History List
  RxList<String> historyList = <String>[].obs;

  // Store data in GetStorage
  void saveScanData(String data) {
    historyList.add(data); // Add to local list
    box.write('scanHistory', historyList); // Store in local storage
  }

  // Load data from GetStorage
  void loadScanHistory() {
    List<dynamic>? storedHistory = box.read<List>('scanHistory');
    if (storedHistory != null) {
      historyList.assignAll(storedHistory.cast<String>());
    }
  }

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));
  }

  void triggerAnimation() {
    animationController.reset();
    animationController.forward();
    showQR.value = true;
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
