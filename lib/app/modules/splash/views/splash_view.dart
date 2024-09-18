import 'package:chat_app/config/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller using GetBuilder
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        // Check if the current theme is dark or light
        final bool isDarkTheme = Get.isDarkMode;

        return Scaffold(
          body: Center(
            child: Image.asset(
              isDarkTheme ? AppImages.LOGO_ICON : AppImages.LOGO_ICON,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
