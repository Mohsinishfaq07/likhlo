import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileFields extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData? icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? hintText;

  const ProfileFields({
    super.key,
    this.controller,
    required this.label,
    this.icon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.enabled = true,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      enabled: enabled,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
        prefixIcon:
            icon != null ? Icon(icon, color: Colors.blue.shade700) : null,
        suffixIcon:
            suffixIcon != null
                ? InkWell(onTap: onSuffixIconPressed, child: suffixIcon)
                : null,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}
