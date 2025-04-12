// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:likhlo/Widgets/Button/CustomButton.dart';
// import 'package:likhlo/Widgets/ExitDialoge/ExitDialoge.dart';
// import 'package:pinput/pinput.dart';

// class Otpscren extends ConsumerStatefulWidget {
//   final String number;
//   const Otpscren({super.key, required this.number});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _OtpscrenState();
// }

// class _OtpscrenState extends ConsumerState<Otpscren> {
//   final pinController = TextEditingController();
//   final focusNode = FocusNode();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     pinController.dispose();
//     focusNode.dispose();
//     super.dispose();
//   }

//   Future<void> _verifyOTP() async {
//     FocusScope.of(context).unfocus();
//     if (pinController.text.isEmpty || pinController.text.length != 6) {
//       // Show an error message for invalid OTP
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a 6-digit OTP')),
//       );
//       return;
//     }
//     setState(() => _isLoading = true);
//     try {
//       // Simulate OTP verification
//       await Future.delayed(const Duration(seconds: 2));
//       // Replace this with your actual OTP verification logic
//       if (pinController.text == "123456") {
//         // OTP is valid, navigate to the next screen (e.g., Home)
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder:
//                 (context) =>
//                     const Scaffold(body: Center(child: Text("OTP Verified!"))),
//           ), // Replace with your Homescreen
//         );
//       } else {
//         // OTP is invalid, show an error message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Invalid OTP. Please try again.')),
//         );
//       }
//     } catch (e) {
//       // Handle potential errors during OTP verification
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error verifying OTP: $e')));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: GoogleFonts.poppins(fontSize: 22, color: Colors.black),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.blue.shade300),
//         borderRadius: BorderRadius.circular(15),
//       ),
//     );

//     final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       border: Border.all(color: Colors.blue.shade700, width: 2),
//       borderRadius: BorderRadius.circular(15),
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         color: Colors.blue.shade50,
//       ),
//     );

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
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "Verify OTP",
//                         style: GoogleFonts.poppins(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue.shade700,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         "Please enter the 6-digit OTP sent to your mobile number",
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       Pinput(
//                         controller: pinController,
//                         focusNode: focusNode,
//                         defaultPinTheme: defaultPinTheme,
//                         focusedPinTheme: focusedPinTheme,
//                         submittedPinTheme: submittedPinTheme,
//                         validator: (s) {
//                           if (s?.isEmpty ?? true) {
//                             return 'OTP is required';
//                           }
//                           if (s!.length != 6) {
//                             return 'Please enter a 6-digit OTP';
//                           }
//                           return null;
//                         },
//                         pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
//                         showCursor: true,
//                         onCompleted: (pin) => debugPrint('OTP completed: $pin'),
//                       ),
//                       const SizedBox(height: 30),
//                       ActionButton(
//                         label: "Verify OTP",
//                         isLoading: _isLoading,
//                         onPressed: _verifyOTP,
//                       ),
//                       const SizedBox(height: 20),
//                       TextButton(
//                         onPressed: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                 'Resend OTP functionality not implemented yet',
//                               ),
//                             ),
//                           );
//                         },
//                         child: Text(
//                           "Resend OTP",
//                           style: TextStyle(color: Colors.blue.shade700),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(
//                             context,
//                           ); // Go back to the previous screen (e.g., Login with Mobile)
//                         },
//                         child: const Text(
//                           "Go Back",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     ],
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
