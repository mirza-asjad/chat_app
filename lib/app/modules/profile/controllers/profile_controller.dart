import 'dart:developer';
import 'package:chat_app/app/modules/home/controllers/home_controller.dart';

import 'package:chat_app/services/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/user_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  HomeController homeController = Get.find<HomeController>();

  // Observable for edit mode
  RxBool isEditingName = false.obs;

  // Reactive variables for user info
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString userPhoneNumber = ''.obs;

  RxBool isEditingPhone = false.obs;

  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();

  // Observable for loading state
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize user info from HomeController
    fetchUserInfo();
  }

  // Method to handle logout
  Future<void> logout() async {
    try {
      // Get FCM token
      final token = await FCMManager.getFCMToken();

      // Remove FCM token from Firestore
      await _authService.removeFCMToken(token);

      // // Set isLoggedin to false in SharedPreferences
      // await AppPreferences.setUserLoggedIn(false);

      _authService.signOut();

      // Navigate to the login screen
      Get.offAllNamed(Routes.LOGIN); // Replace with your login route
    } catch (e) {
      log('Logout error: $e');
    }
  }

  void updateUserName(String newName, BuildContext context) async {
    if (newName.isEmpty) {
      isLoading.value = false;
      nameTextController.clear();
      return;
    }

    if (newName == userName.value) {
      //clear the phoneText
      nameTextController.clear();
      isLoading.value = false;

      return;
    }

    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update the user's name in Firestore
        await _userService.updateUserName(user.uid, newName);
        // Update the local state
        userName.value = newName;
        // Notify HomeController about the change
        homeController.userName.value = newName;

        nameTextController.clear();
      }
    } catch (e) {
      log('Error updating name: $e');
      nameTextController.clear();
      isLoading.value = false;
    } finally {
      isLoading.value = false;
      nameTextController.clear();
    }
  }

  void updateUserPhoneNumber(
      String newPhoneNumber, BuildContext context) async {
    if (newPhoneNumber.isEmpty) {
      isLoading.value = false;
      phoneTextController.clear();

      return;
    }

    if (newPhoneNumber == userPhoneNumber.value) {
      //clear the phoneText

      isLoading.value = false;
      phoneTextController.clear();

      return;
    }

    if (!RegExp(r'^\+\d{7,15}$').hasMatch(newPhoneNumber)) {
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update the user's phone number in Firestore
        await _userService.updateUserPhoneNumber(user.uid, newPhoneNumber);
        // Update the local state
        userPhoneNumber.value = newPhoneNumber;
        // Notify HomeController about the change
        homeController.userPhoneNumber.value = newPhoneNumber;
        // Clear error message

        //clear the phoneText
        phoneTextController.clear();
      }
    } catch (e) {
      log('Error updating phone number: $e');
      isLoading.value = false;
      phoneTextController.clear();
    } finally {
      isLoading.value = false;
      phoneTextController.clear();
    }
  }

  // Method to delete the current user
  Future<void> deleteAccount() async {
    try {
      // Set isLoading to true while the deletion is in progress
      isLoading.value = true;

      // Get the current user
      final userUID = _authService.getCurrentUserId();

      if (userUID != null) {
        // Delete the user document from Firestore
        await _userService.deleteUserDocument(userUID);

        // Delete the user account
        await _authService.deleteUser();

        // // Set isLoggedin to false in SharedPreferences
        // await AppPreferences.setUserLoggedIn(false);

        _authService.signOut();

        // Navigate to the login screen or any other desired screen
        Get.offAllNamed(Routes.LOGIN); // Change to your login route
      }
    } catch (e) {
      // Handle any errors if necessary
      log('Delete account error: $e');
    } finally {
      // Set isLoading to false when the operation is complete
      isLoading.value = false;
    }
  }

  void fetchUserInfo() {
    userName.value = homeController.userName.value ?? 'Not available';
    userEmail.value = homeController.userEmail.value ?? 'Not available';
    userPhoneNumber.value =
        homeController.userPhoneNumber.value ?? 'e.g., +1 (555) 555-5555';
  }
}
