import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sumpyo/screens/login_screen.dart';

class introScreen extends StatelessWidget {
  const introScreen({super.key});
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const loginScreen()));
    });
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Container(
            //height : MediaQuery.of(context).size.height,
            //color: kPrimaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.384375),
                Container(
                  child: Image.asset(
                    'assets/logo.png',
                    width: screenWidth * 0.616666,
                    height: screenHeight * 0.0859375,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Align(
                  child: Text("© Copyright 2023, imzu와 아이들",
                      style: TextStyle(
                        fontSize: screenWidth * (14 / 360),
                        color: const Color.fromRGBO(255, 255, 255, 0.6),
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0625,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
