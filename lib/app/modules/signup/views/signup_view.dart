import 'package:chat_app/app/routes/app_pages.dart';
import 'package:chat_app/config/app_colors.dart';
import 'package:chat_app/config/app_images.dart';
import 'package:chat_app/widgets/customized_google_button.dart';
import 'package:chat_app/widgets/customized_reuse_button.dart';
import 'package:chat_app/widgets/customized_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: screenWidth * 0.04,
          right: screenWidth * 0.04,
          bottom:
              bottomInset, // Adjust bottom padding based on keyboard visibility
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.1),
            _buildTitle(screenHeight, theme),
            SizedBox(height: screenHeight * 0.05),
            _buildHeaderRow(theme),
            SizedBox(height: screenHeight * 0.02),
            Obx(() => CustomTextFields(
                  controller: controller.emailController,
                  hintText: 'Email',
                  imagePath: AppImages.EMAIL_ICON,
                  errorText: controller.emailError.value,
                  keyboardType: TextInputType.emailAddress,
                )),
            SizedBox(height: screenHeight * 0.015),
            Obx(() => CustomTextFields(
                  controller: controller.nameController,
                  hintText: 'Name',
                  imagePath: AppImages.USER_ICON,
                  errorText: controller.nameError.value,
                  keyboardType: TextInputType.emailAddress,
                )),
            SizedBox(height: screenHeight * 0.015),
            Obx(() => CustomTextFields(
                  controller: controller.phoneController,
                  hintText: 'Phone Number',
                  imagePath: AppImages.CALL_ICON,
                  errorText: controller.phoneError.value,
                  keyboardType: TextInputType.phone,
                )),
            SizedBox(height: screenHeight * 0.015),
            Obx(() => CustomTextFields(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  imagePath: AppImages.UNLOCK_ICON,
                  alternativeImagePath: AppImages.PASSWORD_ICON,
                  errorText: controller.passwordError.value,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: controller.isObscureText.value,
                  isClickableIcon: true,
                  isImagePrimary: controller.isImagePrimary.value,
                  onIconTap: () {
                    controller.isImagePrimary.value =
                        !controller.isImagePrimary.value;
                    controller.isObscureText.value =
                        !controller.isObscureText.value;
                  },
                )),
            SizedBox(height: screenHeight * 0.015),
            Obx(() => CustomTextFields(
                  controller: controller.confirmPasswordController,
                  hintText: 'Confirm Password',
                  imagePath: AppImages.UNLOCK_ICON,
                  alternativeImagePath: AppImages.PASSWORD_ICON,
                  errorText: controller.confirmPasswordError.value,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: controller.isObscureTextforRePassword.value,
                  isClickableIcon: true,
                  isImagePrimary: controller.isImagePrimaryforeRePassword.value,
                  onIconTap: () {
                    controller.isImagePrimaryforeRePassword.value =
                        !controller.isImagePrimaryforeRePassword.value;
                    controller.isObscureTextforRePassword.value =
                        !controller.isObscureTextforRePassword.value;
                  },
                )),
            SizedBox(height: screenHeight * 0.03),
            CustomButton(
              buttonText: 'SIGNUP',
              onTap: () {
                controller.signUp(context);
              },
              isLoading: controller.isLoading,
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildTermsAndConditionsCheckbox(theme, context),
            SizedBox(height: screenHeight * 0.02),
            GoogleLoginButton(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              isLoading: controller.isGoogleLoading,
              onTap: () {
                controller.googleSignUp(context);
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
          'SIGNUP',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.LOGIN);
          },
          child: Text(
            'LOGIN',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditionsCheckbox(
      ThemeData theme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(
          () => MSHCheckbox(
            size: 16,
            value: controller.isTermsAccepted.value,
            colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
              checkedColor: theme.colorScheme.secondary,
            ),
            style: MSHCheckboxStyle.fillScaleColor,
            onChanged: (selected) {
              controller.isTermsAccepted.value = selected;
            },
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Obx(
          () => Text(
            'Accept Terms and Conditions',
            style: theme.textTheme.labelSmall?.copyWith(
              color: controller.isTermsAccepted.value
                  ? theme.colorScheme.onSurface.withOpacity(0.7)
                  : AppColors
                      .RED_COLOR, // Change text color based on checkbox state
            ),
          ),
        ),
      ],
    );
  }
}
