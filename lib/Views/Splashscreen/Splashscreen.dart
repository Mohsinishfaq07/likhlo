import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:likhlo/Utils/Methods/HandleSplash.dart';
import 'package:likhlo/Utils/Textstyle/Textstyle.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool showintro = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HandleSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/money.webp"),
              height: 200,
              width: 200,
            ),
            Gap(20),
            Text(
              "Udhaar Book",
              style: AppStyle(25, FontWeight.bold, Colors.white),
            ),
            Gap(60),
            CircularProgressIndicator(color: Colors.orange),
          ],
        ),
      ),
    );
  }
}
