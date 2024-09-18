import 'package:chat_app/app/routes/app_pages.dart';

import 'package:chat_app/config/app_images.dart';

import 'package:chat_app/widgets/customized_google_button.dart';
import 'package:chat_app/widgets/customized_reuse_button.dart';
import 'package:chat_app/widgets/customized_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.1),
            _buildTitle(screenHeight, theme),
            SizedBox(height: screenHeight * 0.1),
            _buildHeaderRow(theme),
            SizedBox(height: screenHeight * 0.02),
            Obx(() => CustomTextFields(
                  hintText: 'Email ID',
                  imagePath: AppImages.EMAIL_ICON,
                  controller: controller.emailController,
                  errorText: controller.emailError.value.isEmpty
                      ? null
                      : controller.emailError.value,
                )),
            SizedBox(height: screenHeight * 0.015),
            Obx(() => CustomTextFields(
                  hintText: 'Password',
                  obscureText: controller.isObscureText.value,
                  imagePath: AppImages.UNLOCK_ICON,
                  alternativeImagePath: AppImages.PASSWORD_ICON,
                  controller: controller.passwordController,
                  isClickableIcon: true,
                  isImagePrimary: controller.isImagePrimary.value,
                  onIconTap: () {
                    controller.isImagePrimary.value =
                        !controller.isImagePrimary.value;
                    controller.isObscureText.value =
                        !controller.isObscureText.value;
                  },
                  errorText: controller.passwordError.value.isEmpty
                      ? null
                      : controller.passwordError.value,
                )),
            SizedBox(height: screenHeight * 0.03),
            CustomButton(
              buttonText: 'LOGIN',
              isLoading: controller.isLoading,
              onTap: () {
                controller.loginUser();
              },
              // You can customize button colors using theme if needed
            ),
            SizedBox(height: screenHeight * 0.04),
            _buildForgotPasswordButton(theme),
            SizedBox(height: screenHeight * 0.03),
            GoogleLoginButton(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              isLoading: controller.isGoogleLoading,
              onTap: () {
                controller.googleSignIn(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(double screenHeight, ThemeData theme) {
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    return Center(
      child: Image.asset(
        isDarkTheme ? AppImages.LOGO_ICON : AppImages.LOGO_ICON,
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildHeaderRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'LOGIN',
          style: theme.textTheme.labelLarge!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.SIGNUP);
          },
          child: Text(
            'NEW USER ? SIGNUP NOW',
            style: theme.textTheme.labelSmall!.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildForgotPasswordButton(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.FORGET_PASSWORD);
      },
      child: Text(
        'Forget Password?',
        style: theme.textTheme.labelMedium!.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }
}
