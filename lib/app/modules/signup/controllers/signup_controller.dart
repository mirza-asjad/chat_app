import 'package:chat_app/app/routes/app_pages.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/push_notification_service.dart';

import 'package:chat_app/widgets/customized_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupController extends GetxController {
  final AuthService _authService = AuthService();
  RxBool isTermsAccepted = false.obs;
  RxBool isLoading = false.obs;
  RxBool isGoogleLoading = false.obs;

  var isObscureText = true.obs;
  var isImagePrimary = false.obs;
  var isObscureTextforRePassword = true.obs;
  var isImagePrimaryforeRePassword = false.obs;

  // Controllers for form fields
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  // Error messages
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;
  RxString confirmPasswordError = ''.obs;
  RxString phoneError = ''.obs;
  RxString nameError = ''.obs;
  bool validateFields() {
    bool isValid = true;

    // Clear all errors initially
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    phoneError.value = '';
    nameError.value = '';

    // Email validation
    if (emailController.text.isEmpty) {
      emailError.value = 'Please Enter Email';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Invalid Email Format (i.e. developer@gmail.com)';
      isValid = false;
    } else {
      // Proceed with other validations if email is valid

      // Name validation
      if (nameController.text.isEmpty) {
        nameError.value = 'Please Enter Name';
        isValid = false;
      } else {
        // Proceed with other validations if name is valid

        // Phone validation
        if (phoneController.text.isEmpty) {
          phoneError.value = 'Please Enter Phone Number';
          isValid = false;
        } else if (!RegExp(r'^\+\d{7,15}$').hasMatch(phoneController.text)) {
          phoneError.value = 'Invalid Format (e.g., +1 (555) 555-5555)';
          isValid = false;
        } else {
          // Proceed with other validations if phone number is valid

          // Password validation
          if (passwordController.text.isEmpty) {
            passwordError.value = 'Please Enter Password';
            isValid = false;
          } else if (passwordController.text.length < 6) {
            passwordError.value = 'Password must be at least 6 characters';
            isValid = false;
          } else {
            // Proceed with other validations if password is valid

            // Confirm password validation
            if (confirmPasswordController.text.isEmpty) {
              confirmPasswordError.value = 'Please Enter Your Password Again';
              isValid = false;
            } else if (confirmPasswordController.text !=
                passwordController.text) {
              confirmPasswordError.value = "Passwords don't match";
              isValid = false;
            }

            // Terms and Conditions validation
            if (!isTermsAccepted.value) {
              isValid = false;
            }
          }
        }
      }
    }

    return isValid;
  }

  Future<void> signUp(BuildContext context) async {
    if (validateFields()) {
      try {
        // Set isLoading to true
        isLoading.value = true;

        // Request permission and get FCM token
        String fcmToken = await FCMManager.getFCMToken();

        User? user = await _authService.signUp(
          email: emailController.text,
          name: nameController.text,
          password: passwordController.text,
          phoneNumber: phoneController.text,
          fcmToken: [fcmToken],
        );

        if (user != null) {
          // // Set isLoggedin to true in SharedPreferences
          // await AppPreferences.setUserLoggedIn(true);
          // Navigate to the next screen after signup
          Get.offAllNamed(Routes.HOME);
        }
      } on AuthException catch (e) {
        // Handle specific auth errors
        if (e.code == 'email-already-in-use') {
          emailError.value = 'Email is already in use';
        } else {
          SnackbarUtils.showErrorSnackbar(
            title: 'Error',
            message: e.message ?? 'An error occurred',
            context: context,
          );
        }
      } catch (e) {
        SnackbarUtils.showErrorSnackbar(
          title: 'Error',
          message: e.toString(),
          context: context,
        );
      } finally {
        // Set isLoading to false regardless of success or failure
        isLoading.value = false;
      }
    }
  }

  Future<void> googleSignUp(BuildContext context) async {
    try {
      isGoogleLoading.value = true;
      // Request permission and get FCM token
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
            title: 'Authenication Error',
            message: 'Unable to connect with Google',
            context: context);
      }
    } catch (e) {
      // Handle errors from Google sign-in if needed
    } finally {
      isGoogleLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose the controllers when the controller is closed
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
