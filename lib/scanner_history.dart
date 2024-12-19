// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:qr_scrnner/helper/fontfamily.dart';
import 'package:qr_scrnner/helper/history_info.dart';
import 'package:qr_scrnner/webview_screen.dart';

class ScanHistory extends StatefulWidget {
  @override
  State<ScanHistory> createState() => _ScanHistoryState();
}

class _ScanHistoryState extends State<ScanHistory> {
  Box? scannedDataBox;
  List<History> historyList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    historyList = [];
    scannedDataBox = Hive.box('scannedData');
    for (var element in (scannedDataBox?.values ?? [])) {
      setState(() {
        historyList.add(History.fromJson(element));
      });
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
          "Scanning History",
          style: TextStyle(
            color: Colors.white,
            fontFamily: FontFamily.satoshiBold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Pro Scanner will keep your last 5 scanned history. To keep all please purchase pro package.",
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
              height: 20,
            ),
            Expanded(
              child: historyList.isNotEmpty
                  ? ListView.builder(
                      itemCount: historyList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return WebViewScreen(
                                    Url: historyList[index].data ?? "",
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  margin: EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/history.png",
                                    color: Color(0xFF575799),
                                    height: 25,
                                    width: 25,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF575799).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        historyList[index].title ?? "",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: FontFamily.satoshiBold,
                                          fontSize: 17,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        historyList[index].data ?? "",
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontFamily: FontFamily.satoshiMedium,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color(0xFF575799),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFF575799),
                                  offset: Offset(6, 6),
                                  blurRadius: 0,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "History Not Found!",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: FontFamily.satoshiMedium,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
