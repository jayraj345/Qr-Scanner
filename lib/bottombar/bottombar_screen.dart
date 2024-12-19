// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scrnner/bottombar/bottombar_controller.dart';

class BottomBarScreen extends StatefulWidget {
  BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  BottomBarController controller = Get.put(BottomBarController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomBarController>(builder: (_) {
      return Scaffold(
        extendBody: true,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: controller.screenList[controller.selectedTab.index],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CrystalNavigationBar(
            currentIndex: SelectedTab.values.indexOf(controller.selectedTab),
            unselectedItemColor: Colors.white,
            backgroundColor: Color(0xFF575799),
            paddingR: EdgeInsets.zero,
            margin: EdgeInsets.only(top: 0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                offset: const Offset(
                  3.0,
                  3.0,
                ),
                blurRadius: 5.0,
                spreadRadius: 1.0,
              ),
            ],
            onTap: controller.handleIndexChanged,
            items: [
              CrystalNavigationBarItem(
                icon: Icons.home,
                unselectedIcon: Icons.home,
                selectedColor: Color(0xFFd3d3ff),
              ),
              CrystalNavigationBarItem(
                icon: Icons.qr_code_2_sharp,
                unselectedIcon: Icons.qr_code_2_sharp,
                selectedColor: Color(0xFFd3d3ff),
              ),
              CrystalNavigationBarItem(
                icon: Icons.history,
                unselectedIcon: Icons.history,
                selectedColor: Color(0xFFd3d3ff),
              ),
              CrystalNavigationBarItem(
                icon: Icons.settings,
                unselectedIcon: Icons.settings,
                selectedColor: Color(0xFFd3d3ff),
              ),
            ],
          ),
        ),
      );
    });
  }
}
