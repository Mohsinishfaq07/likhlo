// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tailor_app/Utils/models/measurmentmodel.dart';

// class MeasurementFields extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator; // Validation function

//   const MeasurementFields({
//     super.key,
//     required this.controller,
//     required this.label,
//     required this.keyboardType,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade100,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.blue.shade300),
//               ),
//               child: Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             flex: 5,
//             child: TextFormField(
//               controller: controller,
//               keyboardType: keyboardType,
//               validator: validator,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: Colors.blue.shade300),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 12,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Widget EditFields(String key, TextEditingController controller) {
//   String label = Measurement.labels[key] ?? key;
//   TextInputType keyboardType =
//       (key == 'name' || key == 'color')
//           ? TextInputType.text
//           : TextInputType.number;

//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Row(
//       children: [
//         Expanded(
//           flex: 3,
//           child: Container(
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade100,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.blue.shade300),
//             ),
//             child: Text(
//               label,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 20),
//         Expanded(
//           flex: 5,
//           child: TextField(
//             controller: controller,
//             keyboardType: keyboardType,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 10,
//                 vertical: 12,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// class NoteSection extends StatelessWidget {
//   final TextEditingController noteController;

//   const NoteSection({super.key, required this.noteController});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Note - نوٹ",
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           SizedBox(
//             height: 150,
//             child: TextField(
//               controller: noteController,
//               maxLines: 5,
//               keyboardType: TextInputType.multiline,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: Colors.blue.shade300),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: EdgeInsets.all(12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
