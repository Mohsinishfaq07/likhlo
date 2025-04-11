import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle AppStyle(double size, FontWeight weight, Color color) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(color: color, fontWeight: weight, fontSize: size),
  );
}
