import 'package:chat_app/app/modules/home/controllers/home_controller.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:chat_app/config/app_common.dart';
import 'package:chat_app/config/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomStartDrawer extends GetView<HomeController> {
  const CustomStartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Retrieve theme and text theme
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Drawer(
      child: Column(
        children: [
          // Header
          SizedBox(
            height: screenWidth * 0.15, // Responsive height for the header
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.PROFILE); // Navigate to profile screen
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Image
                SizedBox(
                  width: screenWidth * 0.05, // Responsive width for spacing
                ),
                Obx(() {
                  return buildCircleAvatar(
                      controller.userName.value ?? '', screenWidth, theme);
                }),

                SizedBox(width: screenWidth * 0.02),

                // Header Name
                Obx(() {
                  return Expanded(
                    child: Text(
                      controller.userName.value ??
                          'Loading...', // Provide a default value or loading state
                      style: textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface, // Color of the text
                      ),
                      overflow: TextOverflow.ellipsis, // Handle long text
                    ),
                  );
                }),
              ],
            ),
          ),

          SizedBox(
            height: screenWidth * 0.05, // Responsive height for spacing
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06), // Responsive padding
            child: Divider(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ), // Divider after header

          // ListTile
          ListTile(
            leading: Image.asset(
                AppImages.SUPPORT_ICON, // Replace with your desired icon
                width: screenWidth * 0.05, // Responsive width for icon
                height: screenWidth * 0.05,
                color: theme
                    .colorScheme.inverseSurface // Responsive height for icon
                ),
            title: Text(
              'Contact Us',
              style: textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.onSurface, // Color of the text
              ),
            ),
            onTap: () {
              // Handle tap
              controller.launchEmail(context);
            },
          ),

          // Theme Switch Tile
          ListTile(
            leading: Image.asset(
              AppImages.THEME_ICON,
              width: screenWidth * 0.05,
              height: screenWidth * 0.05,
              color: theme.colorScheme.inverseSurface,
            ),
            trailing: Obx(() {
              return Switch(
                value: controller.isDarkMode.value,
                onChanged: (value) {
                  controller.toggleTheme(value);
                },
              );
            }),
            title: Text(
              'Switch Theme',
              style: textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            onTap: () {
              // Handle tap if necessary
            },
          ),
          const Spacer(), // Spacer to push the footer to the bottom
          Divider(
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ), // Divider before footer
          // Footer
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Footer Image
                Padding(
                  padding: EdgeInsets.only(
                      right: screenWidth * 0.02), // Responsive spacing
                  child: Image.asset(AppImages.LOAD_ICON,
                      width: screenWidth * 0.04,
                      color: theme.colorScheme
                          .inverseSurface // Responsive width for image
                      ),
                ),
                // Version Text
                Text(
                  'Version:',
                  style: textTheme.labelMedium!.copyWith(
                    color: theme.colorScheme.onSurface, // Color of the text
                  ),
                ),
                SizedBox(width: screenWidth * 0.01), // Responsive spacing
                Obx(() => Text(
                      controller.appVersion.value.isEmpty
                          ? 'Loading...'
                          : controller.appVersion.value,
                      style: textTheme.labelSmall!.copyWith(
                        fontSize: screenWidth * 0.027, // Responsive font size
                        color: theme.colorScheme.onSurface, // Color of the text
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildCircleAvatar(String fullName, double screenWidth, ThemeData theme) {
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
