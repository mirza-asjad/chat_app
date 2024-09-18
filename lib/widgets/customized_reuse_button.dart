import 'package:chat_app/config/app_colors.dart';
import 'package:chat_app/config/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String buttonText; // Parameter to pass the button text
  final Color? backgroundColor; // Optional background color parameter
  final Color? textColor; // Optional text color parameter
  final String? fontFamily; // Optional font family parameter
  final double? fontSize; // Optional font size parameter
  final FontWeight? fontWeight; // Optional font weight parameter
  final VoidCallback? onTap; // Optional onTap callback parameter
  final RxBool isLoading; // Parameter to indicate loading state

  const CustomButton({
    Key? key,
    required this.buttonText,
    this.backgroundColor, // Initialize with optional parameter
    this.textColor, // Initialize with optional parameter
    this.fontFamily, // Initialize with optional parameter
    this.fontSize, // Initialize with optional parameter
    this.fontWeight, // Initialize with optional parameter
    this.onTap, // Initialize with optional parameter
    required this.isLoading, // Initialize with RxBool parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(
        () => Container(
          width: double.infinity,
          child: GestureDetector(
            onTap: isLoading.value ? null : onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.BLUE_COLOR,
                borderRadius: BorderRadius.circular(36.0),
              ),
              child: Center(
                child: isLoading.value
                    ? SizedBox(
                        width: 29.0,
                        height: 29.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            textColor ?? AppColors.WHITE_COLOR,
                          ),
                        ),
                      )
                    : Text(
                        buttonText,
                        style: AppTextStyles.labelLargeMedium.copyWith(
                          fontSize: fontSize ?? 16.0,
                          color: textColor ?? AppColors.WHITE_COLOR,
                          fontFamily: fontFamily,
                          fontWeight: fontWeight ?? FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
