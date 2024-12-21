// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_scrnner/qr_screen/qr_screen.dart';
import 'package:qr_scrnner/scanner_history.dart';
import 'package:qr_scrnner/scanner_screen.dart';
import 'package:qr_scrnner/setting_screen.dart';

enum SelectedTab { home, qr, hostory, setting }

class BottomBarController extends GetxController {
  var selectedTab = SelectedTab.home;

  List<Widget> screenList = [
    ScannerScreen(),
    QRGeneratorScreen(),
    ScanHistory(),
    SettingScreen(),
  ];

  void handleIndexChanged(int i) {
    selectedTab = SelectedTab.values[i];
    update();
  }
}
