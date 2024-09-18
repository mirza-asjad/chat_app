import 'package:chat_app/config/app_colors.dart';
import 'package:chat_app/config/app_const.dart';
import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyController extends GetxController {
  late WebViewController webController;

  // Observable to track loading state
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.WHITE_COLOR)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Handle progress updates
          },
          onPageStarted: (String url) {
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
          },
          onHttpError: (HttpResponseError error) {
            isLoading.value = false;
          },
          onWebResourceError: (WebResourceError error) {
            isLoading.value = false;
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(AppURLS.PRIVACY_POLICY)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(AppURLS.PRIVACY_POLICY));
  }
}
