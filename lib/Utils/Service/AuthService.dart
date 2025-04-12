import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:likhlo/Utils/Snackbar/Snackbar.dart';
import 'package:likhlo/Views/Auth/Login/LoginScreen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return null;
    }
  }

  // Login with email and password
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // showSnackBar("Success", "Logged in Successfully");
      // Get.offAll(Homescreen());
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return null;
    }
  }

  // ✅ Google Sign-In (NEW)
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      // showSnackBar("Success", "Logged in with Google");
      return userCredential.user;
    } catch (e) {
      log(e.toString());
      Get.snackbar(
        'Error',
        "Google sign-in failed",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  // ✅ Forgot Password (NEW)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showSnackBar("Success", "Password reset email sent");
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Fluttertoast.showToast(msg: "Logged Out");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }

  Future<User?> signupwithcred(AuthCredential credential) async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      log("Signed up with credential for user: ${userCredential.user?.uid}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log("Signup with credential failed: ${e.code} - ${e.message}");
      _handleAuthError(e);
      return null;
    } catch (e) {
      log("Unexpected error during signup with credential: $e");
      Get.snackbar(
        'Error',
        'An unexpected error occurred during signup.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  String? _verificationId;
  int? _resendToken;
  bool _isResendAvailable = false;
  Timer? _resendTimer;
  final int _resendTime = 60; // Initial resend timeout in seconds
  final RxInt resendTimeLeft = 60.obs;

  Future<void> signInWithPhone({
    required String phoneNumber,
    required Function(PhoneAuthCredential credential) verificationCompleted,
    required Function(FirebaseAuthException e) verificationFailed,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(String verificationId) codeAutoRetrievalTimeout,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    try {
      _isResendAvailable = false;
      resendTimeLeft.value = _resendTime;
      _startResendTimer();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: (verificationId, forceResendingToken) {
          _verificationId = verificationId;
          _resendToken = forceResendingToken;
          codeSent(verificationId, forceResendingToken);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
          codeAutoRetrievalTimeout(verificationId);
          Get.snackbar(
            'Info',
            "Auto OTP retrieval timed out. Please enter manually.",
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        timeout: timeout,
      );
      log("Phone verification initiated for: $phoneNumber");
    } on FirebaseAuthException catch (e) {
      log("Error initiating phone verification: ${e.code} - ${e.message}");
      _handleAuthError(e);
      verificationFailed(e);
    } catch (e) {
      log("Unexpected error initiating phone verification: $e");
      Get.snackbar(
        'Error',
        'Could not start phone verification. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> resendOtp(
    String phoneNumber, {
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(FirebaseAuthException e) verificationFailed,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (_isResendAvailable) {
      try {
        _isResendAvailable = false;
        resendTimeLeft.value = _resendTime;
        _startResendTimer();
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          forceResendingToken: _resendToken,
          verificationCompleted: (credential) {}, // Not handling here
          verificationFailed: verificationFailed,
          codeSent: (verificationId, forceResendingToken) {
            _verificationId = verificationId;
            _resendToken = forceResendingToken;
            codeSent(verificationId, forceResendingToken);
          },
          codeAutoRetrievalTimeout: (verificationId) {}, // Not handling here
          timeout: timeout,
        );
        log("OTP Resent to: $phoneNumber");
      } on FirebaseAuthException catch (e) {
        log("Error resending OTP: ${e.code} - ${e.message}");
        _handleAuthError(e);
        verificationFailed(e);
      } catch (e) {
        log("Unexpected error resending OTP: $e");
        Get.snackbar(
          'Error',
          'Could not resend OTP. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      showSnackBar("Warning", "Please wait for the timeout to resend.");
    }
  }

  Future<User?> verifyOtpAndSignIn(
    String verificationId,
    String smsCode,
  ) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      log("OTP Verified Successfully for user: ${userCredential.user?.uid}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log("OTP Verification Error: ${e.code} - ${e.message}");
      _handleAuthError(e);
      return null;
    } catch (e) {
      log("Unexpected error during OTP verification: $e");
      Get.snackbar(
        'Error',
        'An unexpected error occurred during OTP verification.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  void _startResendTimer() {
    _isResendAvailable = false;
    resendTimeLeft.value = _resendTime;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimeLeft.value > 0) {
        resendTimeLeft.value--;
      } else {
        _isResendAvailable = true;
        _resendTimer?.cancel();
      }
    });
  }

  // Current user
  User? get currentUser => _auth.currentUser;

  // Error handling
  void _handleAuthError(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'Email already in use';
        break;
      case 'invalid-email':
        errorMessage = 'Invalid email address';
        break;
      case 'weak-password':
        errorMessage = 'Password should be at least 6 characters';
        break;
      case 'user-not-found':
        errorMessage = 'No user found with this email';
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password';
        break;
      default:
        errorMessage = 'Authentication failed';
    }
    Get.snackbar(
      'Error',
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
