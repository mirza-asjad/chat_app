import 'dart:developer';

import 'package:chat_app/app/modules/signup/model/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:chat_app/widgets/customized_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/config/app_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var isDarkMode = false.obs;
  final AppPreferences _themePreferences = AppPreferences();

  var createNewChatId = false.obs; // New variable to track chat creation status

  var response = "".obs;
  var messages = <Map<String, String>>[].obs; // List of messages with direction

  // Topic selection
  var selectedCategory = Rxn<String>();
  var selectedSubcategory = Rxn<String>();
  var subcategories = <String, List<String>>{}.obs;
  var currentSubcategories = <String>[].obs;
  var isLoading = false.obs;
  var isMessageSent = false.obs; // Add this line
  var isApiResposneLoading = false.obs;
  final TextEditingController messageController =
      TextEditingController(); // Create a controller
  final ScrollController scrollController = ScrollController(); // Add this

  //user info
  var userName = Rxn<String>();
  var userEmail = Rxn<String>();
  var userPhoneNumber = Rxn<String>();
  // Define a variable to store the context
  String previousResponseContext = "";

  //app version
  var appVersion = ''.obs;

  final AuthService _authService = AuthService();

  final UserService _userService = UserService();

  var currentChatId = ''.obs;

  var isChatLoading = true.obs;

 
  @override
  void onInit() {
    super.onInit();

    _loadThemePreference();

    fetchAppVersion();

    fetchUserInfo();
  }

  Future<void> _loadThemePreference() async {
    isDarkMode.value = await _themePreferences.getTheme();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme(bool value) async {
    isDarkMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    await _themePreferences.setTheme(value);
  }

  //app version
  Future<void> fetchAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
    } catch (e) {
      log("Failed to get app version: $e");
    }
  }

  //launch email
  void launchEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'gpuccini@skullworks.dev',
      queryParameters: {
        'subject': 'Support',
      },
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        SnackbarUtils.showErrorSnackbar(
          title: 'Error sending email',
          message: 'Could not launch email client.',
          context: context,
        );
      }
    } catch (e) {
      SnackbarUtils.showErrorSnackbar(
        title: 'Error sending email',
        message: 'Failed to send email.',
        context: context,
      );
    }
  }

  //fetch user info
  Future<void> fetchUserInfo() async {
    try {
      String? uid = _authService.getCurrentUserId();
      if (uid != null) {
        UserModel? userInfo = await _userService.getUserInfo(uid);
        if (userInfo != null) {
          userName.value = userInfo.name;
          userEmail.value = userInfo.email;
          userPhoneNumber.value = userInfo.phoneNumber;

          // Log the fetched user information
          log('Name: ${userInfo.name}, Email: ${userInfo.email}, Phone Number: ${userInfo.phoneNumber}');
        } else {
          log('No user info found for UID: $uid', name: 'fetchUserInfo');
        }
      } else {
        log('No user is currently signed in.', name: 'fetchUserInfo');
      }
    } catch (e, stacktrace) {
      log('Error fetching user info: $e',
          name: 'fetchUserInfo', error: e, stackTrace: stacktrace);
    }
  }
}
