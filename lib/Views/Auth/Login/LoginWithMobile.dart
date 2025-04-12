// // lib/Views/Auth/Login/LoginWithMobile.dart
// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:likhlo/Utils/Service/AuthService.dart';
// import 'package:likhlo/Utils/Snackbar/Snackbar.dart';
// import 'package:likhlo/Views/Auth/Login/OtpScren.dart';
// import 'package:likhlo/Views/Auth/Signup/SignupScreen.dart';
// import 'package:likhlo/Views/Home/home.dart';
// import 'package:likhlo/Widgets/Button/CustomButton.dart';
// import 'package:likhlo/Widgets/ExitDialoge/ExitDialoge.dart';
// import 'package:likhlo/Widgets/Inpufield/AuthField.dart';

// class Loginwithmobile extends StatefulWidget {
//   const Loginwithmobile({super.key});

//   @override
//   State<Loginwithmobile> createState() => _LoginwithmobileState();
// }

// class _LoginwithmobileState extends State<Loginwithmobile> {
//   final _mobileController = TextEditingController();
//   final AuthService _auth = AuthService();
//   bool _isLoading = false;
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     _mobileController.dispose();
//     super.dispose();
//   }

//   Future<void> _sendOTP() async {
//     FocusScope.of(context).unfocus();
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);
//     try {
//       await _auth.signInWithPhone(
//         phoneNumber:
//             "+92${_mobileController.text.trim()}", // Ensure country code is included
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           final user = await _auth.signupwithcred(credential);
//           if (user != null && mounted) {
//             showSnackBar("Success", "Logged in with Mobile Automatically!");
//             Get.offAll(() => Homescreen()); // Assuming HomeScreen is defined
//           }
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           setState(() => _isLoading = false);
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() => _isLoading = false);
//           Get.to(() => Otpscren(number: _mobileController.text));
//           showSnackBar("Success", "OTP sent to your mobile number.");
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           setState(() => _isLoading = false);
//           showSnackBar(
//             "Info",
//             "Auto OTP retrieval timed out. Please enter manually.",
//           );
//         },
//       );
//       log("OTP Send initiated for: +92${_mobileController.text.trim()}");
//     } catch (e) {
//       setState(() => _isLoading = false);
//       Get.snackbar(
//         'Error',
//         'Could not initiate OTP send. Please try again.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ExitDialog(
//       child: Scaffold(
//         backgroundColor: Colors.blue,
//         body: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 elevation: 8,
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Login with Mobile",
//                           style: GoogleFonts.poppins(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue.shade700,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           "Enter your mobile number to login",
//                           style: GoogleFonts.poppins(
//                             fontSize: 16,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         // Mobile Number Field using CustomTextField
//                         CustomTextField(
//                           controller: _mobileController,
//                           label: "Mobile Number",
//                           icon: Icons.phone_android,
//                           keyboardType: TextInputType.phone,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter mobile number';
//                             }
//                             if (value.length < 10) {
//                               return 'Enter a valid 10-digit mobile number';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 25),

//                         // Login Button
//                         ActionButton(
//                           label: "Send OTP",
//                           isLoading: _isLoading,
//                           onPressed: () {
//                             if (_isLoading) return;
//                             _sendOTP();
//                           },
//                         ),
//                         const SizedBox(height: 15),
//                         CustomtextButton(
//                           context,
//                           "Login with Email & Password",
//                           () {
//                             Get.back(); // Navigate back to the email/password login screen
//                           },
//                         ),
//                         CustomtextButton(
//                           context,
//                           "Don't have an account? Sign up",
//                           () {
//                             Get.to(() => SignupScreen());
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
