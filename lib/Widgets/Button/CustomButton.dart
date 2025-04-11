import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const ActionButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.blue.shade700,
        ),
        child:
            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }
}

Widget CustomtextButton(
  BuildContext context,
  String label,
  VoidCallback onPressed,
) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      label,
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.blue.shade700),
    ),
  );
}

ElevatedButton LoginwithGoogle(VoidCallback googleLogin) {
  return ElevatedButton.icon(
    onPressed: googleLogin,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.blue.shade700),
    ),
    icon: Image.asset('assets/googleicon.webp', height: 22),
    label: Text(
      "Login with Google",
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
  );
}
