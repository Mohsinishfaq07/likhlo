import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:likhlo/Utils/Model/Profilemodel.dart';
import 'package:likhlo/Utils/Provider/ProfileProvider.dart';
import 'package:likhlo/Utils/Service/AuthService.dart';
import 'package:likhlo/Views/Auth/Login/LoginScreen.dart';
import 'package:likhlo/Views/Home/home.dart';
import 'package:likhlo/Widgets/Button/CustomButton.dart';
import 'package:likhlo/Widgets/Inpufield/AuthField.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();
  final firstnamecontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  final mobilenumbercontroller = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _isPasswordVisible = false; // To toggle password visibility
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        final profileRepository = ref.read(userProfileRepositoryProvider);
        final profile = ProfileModel(
          name:
              '${firstnamecontroller.text.trim()} ${lastnamecontroller.text.trim()}',
          email: _emailController.text.trim(),
          mobileNumber: mobilenumbercontroller.text.trim(),
          gender: '', // You might want to add a gender selection field
        );
        profileRepository.addOrUpdateProfile(profile);
        await _authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        setState(() {
          _isLoading = false;
        });
        Get.offAll(Homescreen());
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
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
                          "Create Account",
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Sign up to get started",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: firstnamecontroller,
                          label: "First Name",
                          icon: Icons.abc,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter First Name';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: lastnamecontroller,
                          label: "Last Name",
                          icon: Icons.abc,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Last Name';
                            }

                            return null;
                          },
                        ),
                        // Email Field using CustomTextField
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: mobilenumbercontroller,
                          label: "Mobile Number",
                          keyboardType: TextInputType.number,
                          icon: Icons.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Mobile Number';
                            }

                            return null;
                          },
                        ),
                        // Email Field using CustomTextField
                        const SizedBox(height: 20),
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
                        CustomTextField(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value != confirmpasswordcontroller.text) {
                              return 'Passwords Dont Match';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          suffixIcon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue.shade700,
                          ),
                          onSuffixIconPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: confirmpasswordcontroller,
                          label: "Confirm Password",
                          icon: Icons.lock,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Confirm password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords Dont Match';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          suffixIcon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue.shade700,
                          ),
                          onSuffixIconPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 25),
                        ActionButton(
                          label: "Sign Up",
                          isLoading: _isLoading,
                          onPressed: () {
                            if (_isLoading) return;
                            _signUp();
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomtextButton(
                          context,
                          "Already have an account? Login",
                          () {
                            Get.offAll(LoginScreen());
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
