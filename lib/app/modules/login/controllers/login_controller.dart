import 'package:chat_app/app/routes/app_pages.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/push_notification_service.dart';
import 'package:chat_app/widgets/customized_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;
  var isGoogleLoading = false.obs;

  var isObscureText = true.obs;
  var isImagePrimary = false.obs;

  // Error messages
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  // TextEditingControllers for email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Reset error texts
    emailError.value = '';
    passwordError.value = '';

    // Validation
    if (email.isEmpty) {
      emailError.value = 'Please Enter Email';
    } else if (!_isValidEmail(email)) {
      emailError.value = 'Please Enter a valid Email';
    }

    if (password.isEmpty) {
      passwordError.value = 'Please Enter Password';
    }

    // If there's any error, stop further execution
    if (emailError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      return;
    }

    try {
      isLoading.value = true;

      // Get FCM token
      String fcmToken = await FCMManager.getFCMToken();

      User? user = await _authService.signIn(
        email: email,
        password: password,
        fcmToken: [fcmToken], // Pass the FCM token here
      );

      if (user != null) {
        // Navigate to the next screen on successful login
        Get.offAllNamed(Routes.HOME);
      }
    } on AuthException catch (e) {
      // Handle specific auth errors
      if (e.code == 'invalid-credential') {
        emailError.value = 'Email or password is incorrect';
      }
    } finally {
      isLoading.value = false;
    }
  }

// Helper method to validate email format
  bool _isValidEmail(String email) {
    // Regular expression for validating email format
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  Future<void> googleSignIn(BuildContext context) async {
    try {
      isGoogleLoading.value = true;
      String fcmToken = await FCMManager.getFCMToken();
      User? user = await _authService.googleSignIn(fcmToken: [fcmToken]);
      if (user != null) {
        // // Set isLoggedin to true in SharedPreferences
        // await AppPreferences.setUserLoggedIn(true);

        // Navigate to the next screen on successful login
        Get.offAllNamed(Routes.HOME);
      } else {
        // Handle sign-in failure (if needed)
        SnackbarUtils.showErrorSnackbar(
          title: 'Authentication Error',
          message: 'User already exists',
          context: context, //this can lead to error
        );
      }
    } catch (e) {
      // Handle errors from Google sign-in if needed
    } finally {
      isGoogleLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose the controllers when the controller is disposed
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
