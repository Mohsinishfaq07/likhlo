// given_taken_button_widget.dart
import 'package:flutter/material.dart';

class GivenTakenButtonWidget extends StatelessWidget {
  final String loanType;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final VoidCallback onPressed;

  const GivenTakenButtonWidget({
    super.key,
    required this.loanType,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
