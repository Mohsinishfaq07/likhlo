import 'package:flutter/material.dart';

class ExitDialog extends StatelessWidget {
  final Widget child; // Child widget to be wrapped

  const ExitDialog({super.key, required this.child});

  // Function to show the exit dialog
  Future<bool> _showExitDialog(BuildContext context) async {
    return (await showDialog(
          context: context,
          barrierDismissible:
              false, // Prevent closing the dialog by tapping outside
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade700, // Start gradient color
                      Colors.blue.shade300, // End gradient color
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16), // Round corners
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Confirm Exit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Are you sure you want to exit the app?',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // No button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pop(false); // Close dialog with "No"
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                            backgroundColor: Colors.white, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 30,
                            ),
                          ),
                          child: const Text(
                            'No',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Yes button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pop(true); // Close dialog with "Yes"
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                            backgroundColor: Colors.white, // Text color

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 30,
                            ),
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )) ??
        false; // If dialog is dismissed, return false (no exit)
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the exit confirmation dialog when the back button is pressed
        bool shouldExit = await _showExitDialog(context);
        return shouldExit; // If true, exit the app
      },
      child: child,
    );
  }
}
