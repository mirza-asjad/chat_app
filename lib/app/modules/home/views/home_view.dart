import 'package:chat_app/app/modules/home/views/start_drawer.dart';
import 'package:chat_app/config/app_images.dart';
import 'package:chat_app/widgets/customized_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Keep this true to handle keyboard appearance
      drawer: const CustomStartDrawer(),
      key: controller.scaffoldKey,
      body: _buildInitialView(
          context, screenWidth, screenHeight, bottomInset, theme),
    );
  }

  Widget _buildInitialView(BuildContext context, double screenWidth,
      double screenHeight, double bottomInset, ThemeData theme) {
    return Column(
      children: [
        _buildHeader(context, screenWidth, screenHeight),
        const Spacer(), // Pushes the logo to the center vertically
        _buildLogo(screenWidth, theme), // Add the logo here
        const Spacer(), // Pushes the bottom bar to the bottom

        _buildBottomBar(
            context, bottomInset, theme, controller.messageController),
      ],
    );
  }

  Widget _buildLogo(double screenWidth, ThemeData theme) {
    String logoAsset = theme.brightness == Brightness.dark
        ? AppImages.LOGO_ICON
        : AppImages.LOGO_ICON;

    return Center(
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(logoAsset),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, double bottomInset,
      ThemeData theme, TextEditingController messageController) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).padding.left + 20,
        top: 10,
        bottom: 10, // Correctly applying the bottomInset
      ),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.72,
            child: CustomTextFields(
              controller: messageController,
              hasIcon: true,
              hintText: 'Message',
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: theme.colorScheme.error, // Normal color when not loading
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                AppImages.SEND_ICON,
                width: 18,
                height: 18,
                color: theme.colorScheme.onSecondaryFixed,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, double screenWidth, double screenHeight) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: screenHeight * 0.05,
        left: screenWidth * 0.03,
        right: screenWidth * 0.03,
        bottom: screenHeight * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              controller.scaffoldKey.currentState?.openDrawer();
            },
            child: Image.asset(
              AppImages.DRAWER_ICON,
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              color: theme.iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}
