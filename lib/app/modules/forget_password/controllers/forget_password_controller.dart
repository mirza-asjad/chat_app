import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordController extends GetxController {
  final AuthService _authService = AuthService(); // Initialize AuthService
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;

  Future<void> sendPasswordResetEmail() async {
    if (emailController.text.isEmpty) {
      errorMessage.value = 'Please enter your email';
      successMessage.value = ''; // Clear success message if email is empty
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      await _authService.sendPasswordResetEmail(emailController.text);
      successMessage.value =
          'Reset Password has successfully been sent to ${emailController.text}';
      emailController.clear();
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'An error occurred';
    } finally {
      isLoading.value = false;
    }
  }
}
