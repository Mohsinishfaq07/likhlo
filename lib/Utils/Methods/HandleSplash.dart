import 'package:get/get.dart';
import 'package:likhlo/Utils/Service/AuthService.dart';
import 'package:likhlo/Views/Auth/Login/LoginScreen.dart';
import 'package:likhlo/Views/Home/home.dart';
import 'package:likhlo/Views/Onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> HandleSplash() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? introShown = prefs.getBool('introShown');
  Future.delayed(Duration(seconds: 3), () {
    AuthService authService = AuthService();
    if (introShown ?? false) {
      if (authService.currentUser != null) {
        Get.offAll(Homescreen());
      } else {
        Get.offAll(LoginScreen());
      }
    } else {
      // If intro has not been shown, show the onboarding screen
      Get.offAll(OnboardingScreen());
      prefs.setBool(
        'introShown',
        true,
      ); // Set the flag to true after showing intro
    }
  });
}
