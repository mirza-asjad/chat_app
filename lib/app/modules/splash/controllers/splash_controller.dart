import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:chat_app/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateBasedOnLoginStatus();
  }

  void _navigateBasedOnLoginStatus() async {
    // Wait for a short duration to simulate splash screen
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Reload the user state to ensure the currentUser information is up to date
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.reload(); // Force reload to refresh the user's state
        currentUser =
            FirebaseAuth.instance.currentUser; // Get the updated user state
      }

      // Check if the user is still logged in
      bool isLoggedin = currentUser != null;

      if (isLoggedin) {
        Get.offNamed(Routes.HOME);
       
      } else {
        // If the user is not logged in (or was deleted), navigate to the Login screen
        Get.offNamed(Routes.LOGIN);
      }
    } catch (e) {
      // Handle any error (like user not found) and navigate to login
      log("Error during user reload: $e");
      Get.offNamed(Routes.LOGIN);
    }
  }
}
