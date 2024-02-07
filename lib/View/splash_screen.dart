// ignore_for_file: annotate_overrides

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_info/View/home_page.dart';

class Splash_screen extends StatefulWidget {
  const Splash_screen({super.key});

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return const HomePage();
        },
      ));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff0D90EE),
                Color(0xff0A5EE7),
                Color(0xff0D2FEE),
                Color(0xff8603E6),
                Color(0xff0A5EE7),
                Color(0xff0D90EE),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/b1.png",
                  height: MediaQuery.sizeOf(context).height*1,
                ),
                const Center(
                    child: CircularProgressIndicator(
                  color: Color(0xff0A5EE7),
                  backgroundColor: Color(0xff8603E6),
                  strokeWidth: 5,
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
