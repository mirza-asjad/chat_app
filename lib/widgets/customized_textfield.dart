import 'package:chat_app/config/app_colors.dart';
import 'package:chat_app/config/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {
  final String hintText;
  final String? imagePath;
  final String? alternativeImagePath;
  final Color color;
  final double width;
  final TextEditingController? controller;
  final String? errorText;
  final String? successText;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool hasIcon;
  final bool isClickableIcon;
  final bool isImagePrimary;
  final void Function()? onIconTap;
  final void Function(String)? onSubmitted; // Add this line

  const CustomTextFields({
    super.key,
    required this.hintText,
    this.imagePath,
    this.alternativeImagePath,
    this.color = Colors.white,
    this.width = double.infinity,
    this.controller,
    this.errorText,
    this.successText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.hasIcon = false,
    this.isClickableIcon = false,
    this.isImagePrimary = true,
    this.onIconTap,
    this.onSubmitted, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    final hintStyle = AppTextStyles.labelSmallRegular.copyWith(
      color: AppColors.LIGHT_GREY_COLOR,
    );

    final currentImagePath = obscureText && isClickableIcon
        ? (isImagePrimary ? imagePath : alternativeImagePath)
        : imagePath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: hasIcon ? 46 : 53,
          width: width,
          child: Stack(
            children: [
              Container(
                width: width,
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: currentImagePath != null ? 60.0 : 20.0,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: hasIcon
                          ? Colors.black.withOpacity(0.0)
                          : Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextField(
                  cursorColor: AppColors.BLACK_COLOR,
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  onSubmitted: onSubmitted, // Add this line
                  decoration: InputDecoration(
                    fillColor: hasIcon
                        ? AppColors.LIGHT_WHITE_COLOR
                        : AppColors.WHITE_COLOR,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    hintText: hintText,
                    hintStyle: hintStyle,
                  ),
                  style: hintStyle.copyWith(
                    color: AppColors.BLACK_COLOR,
                  ),
                ),
              ),
              if (currentImagePath != null)
                Positioned(
                  right: 8.0,
                  top: 3.0,
                  child: GestureDetector(
                    onTap: isClickableIcon ? onIconTap : null,
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 17.0,
                          height: 17.0,
                          child: Image.asset(
                            currentImagePath,
                            fit: BoxFit.contain,
                            color: AppColors.LIGHTER_GREY_COLOR,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0),
            child: Text(
              errorText!,
              style: AppTextStyles.labelMediumRegular.copyWith(
                fontSize: 12,
                color: AppColors.RED_COLOR,
              ),
            ),
          ),
        if (successText != null && successText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0),
            child: Text(
              successText!,
              style: AppTextStyles.labelMediumRegular.copyWith(
                fontSize: 12,
                color: AppColors.GREEN_COLOR,
              ),
            ),
          ),
      ],
    );
  }
}
