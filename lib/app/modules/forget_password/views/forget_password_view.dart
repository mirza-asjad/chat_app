import 'package:chat_app/config/app_images.dart';
import 'package:chat_app/widgets/customized_reuse_button.dart';
import 'package:chat_app/widgets/customized_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.1),
            _buildTitle(theme, textTheme),
            SizedBox(height: screenHeight * 0.05),
            _buildSubTitle(theme, textTheme),
            SizedBox(height: screenHeight * 0.07),
            Obx(() {
              return CustomTextFields(
                hintText: 'Email',
                imagePath: AppImages.EMAIL_ICON,
                errorText: controller.errorMessage.value,
                successText: controller.successMessage.value,
                controller: controller.emailController,
              );
            }),
            SizedBox(height: screenHeight * 0.03),
            CustomButton(
              buttonText: 'CONTINUE',
              isLoading: controller.isLoading,
              onTap: () {
                // Handle continue button press
                controller.sendPasswordResetEmail();
              },
            ),
            SizedBox(height: screenHeight * 0.04),
            _buildBackToLoginButton(theme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme, TextTheme textTheme) {
    return Center(
      child: Text(
        'FORGET PASSWORD',
        style: textTheme.labelLarge!.copyWith(
          color: theme.colorScheme.onBackground,
        ),
      ),
    );
  }

  Widget _buildSubTitle(ThemeData theme, TextTheme textTheme) {
    return Center(
      child: Text(
        'Enter your Email',
        style: textTheme.labelMedium!.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton(ThemeData theme, TextTheme textTheme) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Back to ',
            style: textTheme.labelMedium!.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to LoginView
              Get.back();
            },
            child: Text(
              'Login',
              style: textTheme.labelMedium!.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
