import 'package:chat_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:chat_app/config/app_common.dart';
import 'package:chat_app/config/app_images.dart';
import 'package:chat_app/widgets/customized_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Retrieve theme and text theme
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Top section with a Row replacing the AppBar
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.06,
              bottom: screenHeight * 0.02,
              left: screenWidth * 0.05,
              right: screenWidth * 0.06,
            ),
            child: Row(
              children: [
                Obx(() {
                  return _buildCircleAvatar(
                      controller.userName.value, screenWidth, theme);
                }),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Obx(() {
                    return controller.isEditingName.value
                        ? SizedBox(
                            width: screenWidth *
                                0.4, // Adjust the width accordingly
                            child: TextField(
                              controller: controller.nameTextController,
                              autofocus: true,
                              onSubmitted: (newName) {
                                controller.updateUserName(newName, context);
                                controller.isEditingName.value =
                                    false; // Exit editing mode
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your name',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01,
                                  horizontal: screenWidth * 0.02,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            controller.userName.value,
                            style: textTheme.labelLarge!.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontSize: screenWidth * 0.04,
                            ),
                          );
                  }),
                ),
                IconButton(
                  icon: Icon(
                    controller.isEditingName.value
                        ? Icons.save
                        : Icons.edit, // Toggle icon
                    size: screenWidth * 0.05,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () {
                    if (controller.isEditingName.value) {
                      // Save the new name and exit editing mode
                      controller.updateUserName(
                          controller.nameTextController.text, context);
                      controller.isEditingName.value = false;
                    } else {
                      // Enter editing mode
                      controller.isEditingName.value = true;
                      controller.nameTextController.text =
                          controller.userName.value;
                    }
                  },
                ),
              ],
            ),
          ),

          // First section with heading and two tiles
          _buildSection(
            title: 'ACCOUNT',
            tiles: [
              Obx(() {
                return _buildListTile(
                  leading: SizedBox(
                    width: screenWidth * 0.05,
                    height: screenWidth * 0.05,
                    child: Image.asset(AppImages.EMAIL_ICON,
                        color: theme.colorScheme.inverseSurface),
                  ),
                  title: 'Email',
                  subtitle: controller.userEmail.value,
                  onTap: () {
                    // Handle tap
                  },
                  context: context,
                  theme: theme,
                  textTheme: textTheme,
                );
              }),
              Obx(() {
                return _buildListTile(
                  leading: SizedBox(
                    width: screenWidth * 0.05,
                    height: screenWidth * 0.05,
                    child: Image.asset(AppImages.CALL_ICON,
                        color: theme.colorScheme.inverseSurface),
                  ),
                  title: 'Phone',
                  subtitle: controller.isEditingPhone.value
                      ? null
                      : controller.userPhoneNumber.value,
                  onTap: () {
                    // Handle tap if needed
                  },
                  trailing: controller.isEditingPhone.value
                      ? IconButton(
                          icon: Icon(Icons.save,
                              size: 18, color: theme.colorScheme.onSurface),
                          onPressed: () {
                            controller.updateUserPhoneNumber(
                                controller.phoneTextController.text, context);
                            controller.isEditingPhone.value =
                                false; // Exit editing mode
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.edit,
                              size: 18, color: theme.colorScheme.onSurface),
                          onPressed: () {
                            controller.phoneTextController.text =
                                controller.userPhoneNumber.value;
                            controller.isEditingPhone.value = true;
                          },
                        ),
                  context: context,
                  theme: theme,
                  textTheme: textTheme,
                  subtitleWidget: controller.isEditingPhone.value
                      ? SizedBox(
                          width:
                              screenWidth * 0.4, // Adjust the width accordingly
                          child: TextField(
                            controller: controller.phoneTextController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Enter phone number',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.02,
                              ),
                              hintStyle: textTheme.labelSmall!.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                            ),
                            style: textTheme.labelSmall!.copyWith(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.025,
                            ),
                          ),
                        )
                      : null,
                );
              }),
            ],
            context: context,
            theme: theme,
            textTheme: textTheme,
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
            ),
            child: Divider(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),

          // Second section with heading and four tiles
          _buildSection(
            title: 'ABOUT',
            tiles: [
              _buildListTile(
                leading: SizedBox(
                  width: screenWidth * 0.05,
                  height: screenWidth * 0.05,
                  child: Image.asset(AppImages.TICK_ICON,
                      color: theme.colorScheme.inverseSurface),
                ),
                title: 'Privacy Policy',
                onTap: () {
                  // Handle tap
                  Get.toNamed(
                    Routes.PRIVACY_POLICY,
                  );
                },
                context: context,
                theme: theme,
                textTheme: textTheme,
              ),
              _buildListTile(
                leading: SizedBox(
                  width: screenWidth * 0.05,
                  height: screenWidth * 0.05,
                  child: Image.asset(AppImages.TERM_ICON,
                      color: theme.colorScheme.inverseSurface),
                ),
                title: 'Terms & Conditions',
                onTap: () {
                  // Handle tap
                  Get.toNamed(
                    Routes.TERMS_AND_CONDITIONS,
                  );
                },
                context: context,
                theme: theme,
                textTheme: textTheme,
              ),
              _buildListTile(
                leading: SizedBox(
                  width: screenWidth * 0.05,
                  height: screenWidth * 0.05,
                  child: Image.asset(AppImages.SHUTDOWN_ICON,
                      color: theme.colorScheme.inverseSurface),
                ),
                title: 'Logout',
                onTap: () {
                  // Handle tap
                  controller.logout();
                },
                context: context,
                theme: theme,
                textTheme: textTheme,
              ),
              _buildListTile(
                leading: SizedBox(
                  width: screenWidth * 0.05,
                  height: screenWidth * 0.05,
                  child: Image.asset(
                    AppImages.DELETE_ICON,
                  ),
                ),
                title: 'Delete Account',
                onTap: () {
                  // Handle tap
                  showCustomDialog(context, () {
                    controller.deleteAccount();
                  },
                      controller.isLoading,
                      'Are you sure you want to delete your account?',
                      AppImages.WARNING_ICON);
                },
                context: context,
                theme: theme,
                textTheme: textTheme,
              ),
            ],
            context: context,
            theme: theme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAvatar(
      String fullName, double screenWidth, ThemeData theme) {
    String initials = getUserNameInitials(fullName);

    return Container(
      width: screenWidth * 0.12, // Responsive diameter of the circle
      height: screenWidth * 0.12, // Responsive diameter of the circle
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.onPrimary.withOpacity(0.1),
      ),
      child: Center(
        child: Text(
          initials,
          style: theme.textTheme.labelLarge!.copyWith(
            color: theme.colorScheme.onPrimary,
            fontSize: screenWidth * 0.04, // Responsive font size
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> tiles,
    required BuildContext context,
    required ThemeData theme,
    required TextTheme textTheme,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.07,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            title,
            style: textTheme.labelSmall!.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: MediaQuery.of(context).size.width * 0.03,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ...tiles,
        ],
      ),
    );
  }

  Widget _buildListTile({
    required Widget leading,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? textColor,
    required BuildContext context,
    required ThemeData theme,
    required TextTheme textTheme,
    Widget? trailing,
    Widget? subtitleWidget, // Add subtitleWidget as an optional parameter
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: leading,
      title: Text(
        title,
        style: textTheme.labelSmall!.copyWith(
          color: textColor ?? theme.colorScheme.onSurface,
          fontSize: MediaQuery.of(context).size.width * 0.03,
        ),
      ),
      subtitle: subtitleWidget ??
          (subtitle != null
              ? Text(
                  subtitle,
                  style: textTheme.labelSmall!.copyWith(
                    fontSize: MediaQuery.of(context).size.width * 0.025,
                    color: textColor ??
                        theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                )
              : null),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
