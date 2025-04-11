import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:likhlo/Utils/Service/AuthService.dart';
import 'package:likhlo/Views/Auth/Login/LoginScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  AuthService authService = AuthService();
  void _onIntroEnd(context) {
    Get.offAll(LoginScreen());
  }

  Widget _buildImage(String assetName) {
    return Image.asset('assets/$assetName', width: 200);
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(fontSize: 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.only(top: 40.0),
      imageAlignment: Alignment.center, // Ensure image is centered
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Welcome to UdhaarBook",
          body:
              "Easily manage all your personal and business loan records in one place.",
          image: _buildImage('money.webp'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Track & Remind",
          body: "Get alerts for due payments and never miss a loan date again.",
          image: _buildImage('bell.webp'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Safe & Secure",
          body:
              "Your data is backed up securely and available anytime from any device.",
          image: _buildImage('secure.webp'),
          decoration: pageDecoration.copyWith(
            bodyAlignment: Alignment.center, // Center the body text
            imageAlignment: Alignment.center,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.teal,
        color: Colors.black26,
        spacing: EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
