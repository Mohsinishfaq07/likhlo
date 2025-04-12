import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:likhlo/Utils/Service/AuthService.dart';
import 'package:likhlo/Utils/Snackbar/Snackbar.dart';
import 'package:likhlo/Views/Auth/Signup/SignupScreen.dart';
import 'package:likhlo/Views/Home/home.dart';
import 'package:likhlo/Widgets/Button/CustomButton.dart';
import 'package:likhlo/Widgets/ExitDialoge/ExitDialoge.dart';
import 'package:likhlo/Widgets/Inpufield/AuthField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _isLoading = false;
  bool _hidePassword = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = await _auth.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user != null && mounted) {
        showSnackBar("Success", "Logged in Successfully");
        // Get.offAll(() => Homescreen());
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _googleLogin() async {
    final user = await _auth.signInWithGoogle();
    if (user != null) Get.offAll(() => Homescreen());
  }

  @override
  Widget build(BuildContext context) {
    return ExitDialog(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome Back!",
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Please login to continue",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email Field using CustomTextField
                        CustomTextField(
                          controller: _emailController,
                          label: "Email",
                          icon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            if (!value.contains('@')) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // Password Field using CustomTextField
                        CustomTextField(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock,
                          obscureText: _hidePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          suffixIcon: Icon(
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.blue.shade700,
                          ),
                          onSuffixIconPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 25),

                        // Login Button
                        ActionButton(
                          label: "Login",
                          isLoading: _isLoading,
                          onPressed: () {
                            if (_isLoading) return;
                            _login();
                          },
                        ),
                        const SizedBox(height: 15),
                        LoginwithGoogle(_googleLogin),
                        const SizedBox(height: 15),
                        // CustomtextButton(
                        //   context,
                        //   " Login With Mobile Number 📞 ",
                        //   () {
                        //     Get.to(Loginwithmobile());
                        //   },
                        // ),
                        CustomtextButton(
                          context,
                          "Don't have an account? Sign up",
                          () {
                            Get.to(() => SignupScreen());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
