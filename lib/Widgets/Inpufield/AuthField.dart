import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType; // Make keyboardType nullable
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Function()? onSuffixIconPressed;

  const CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType, // Initialize in the constructor
    this.validator,
    this.suffixIcon,
    this.onSuffixIconPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType, // Use the provided keyboardType
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        suffixIcon:
            suffixIcon != null
                ? IconButton(icon: suffixIcon!, onPressed: onSuffixIconPressed)
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
