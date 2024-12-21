// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qr_scrnner/helper/fontfamily.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF575799),
        leading: SizedBox(),
        centerTitle: true,
        title: Text(
          "Setting",
          style: TextStyle(
            color: Colors.white,
            fontFamily: FontFamily.satoshiBold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
             
            ],
          )
        ],
      ),
    );
  }
}
