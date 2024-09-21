import 'dart:developer';
import 'dart:io';

import 'package:chat_app/app/routes/app_pages.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/push_notification_service.dart';
import 'package:chat_app/widgets/customized_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picking

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
  final profileImageController = TextEditingController(); // Controller for Profile Image URL

  // Error messages
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;
  RxString confirmPasswordError = ''.obs;
  RxString phoneError = ''.obs;
  RxString nameError = ''.obs;
  RxString profileImageError = ''.obs; // Error handling for Profile Image

  Rx<XFile?> pickedImage = Rx<XFile?>(null);

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickProfileImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = image;
      log('Picked image: ${pickedImage.value?.path}');
    } else {
      log('No image selected');
    }
  }

 // Method to convert XFile to File
  File? getFileFromXFile(XFile? xfile) {
    if (xfile != null && xfile.path.isNotEmpty) {
      log("Converting XFile to File: ${xfile.path}");
      return File(xfile.path); // Ensure the path is correctly used here
    } else {
      log("Invalid XFile or path");
      return null;
    }
  }

  
  bool validateFields() {
    bool isValid = true;

    // Clear all errors initially
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    phoneError.value = '';
    nameError.value = '';
    profileImageError.value = ''; // Clear Profile Image Error

    // Email validation
    if (emailController.text.isEmpty) {
      emailError.value = 'Please Enter Email';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Invalid Email Format (i.e. developer@gmail.com)';
      isValid = false;
    } else {
      // Name validation
      if (nameController.text.isEmpty) {
        nameError.value = 'Please Enter Name';
        isValid = false;
      } else {
        // Phone validation
        if (phoneController.text.isEmpty) {
          phoneError.value = 'Please Enter Phone Number';
          isValid = false;
        } else if (!RegExp(r'^\+\d{7,15}$').hasMatch(phoneController.text)) {
          phoneError.value = 'Invalid Format (e.g., +1 (555) 555-5555)';
          isValid = false;
        } else {
          // Password validation
          if (passwordController.text.isEmpty) {
            passwordError.value = 'Please Enter Password';
            isValid = false;
          } else if (passwordController.text.length < 6) {
            passwordError.value = 'Password must be at least 6 characters';
            isValid = false;
          } else {
            // Confirm password validation
            if (confirmPasswordController.text.isEmpty) {
              confirmPasswordError.value = 'Please Enter Your Password Again';
              isValid = false;
            } else if (confirmPasswordController.text != passwordController.text) {
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
        isLoading.value = true;
        String fcmToken = await FCMManager.getFCMToken();
        File? filepath = getFileFromXFile(pickedImage.value);
        User? user = await _authService.signUp(
          email: emailController.text,
          name: nameController.text,
          password: passwordController.text,
          phoneNumber: phoneController.text,
          fcmToken: [fcmToken],
          profileImagePath: filepath, // This could be null
        );

        if (user != null) {
          log("User signed up successfully: ${user.email}");
          Get.offAllNamed(Routes.HOME);
        } else {
          log("User sign-up failed");
        }
      } catch (e) {
        log('Error during sign-up: $e');
        SnackbarUtils.showErrorSnackbar(
          title: 'Error',
          message: e.toString(),
          context: context,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      log("Validation failed");
    }
  }


  Future<void> googleSignUp(BuildContext context) async {
    try {
      isGoogleLoading.value = true;

      // Request permission and get FCM token
      String fcmToken = await FCMManager.getFCMToken();
      
      User? user = await _authService.googleSignIn(
        fcmToken: [fcmToken],
      );

      if (user != null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        SnackbarUtils.showErrorSnackbar(
          title: 'Authentication Error',
          message: 'Unable to connect with Google',
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
      isGoogleLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    profileImageController.dispose(); // Dispose profile image controller
    super.onClose();
  }
}
