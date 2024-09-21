import 'package:get/get.dart';

import '../controllers/chatlist_view_controller.dart';

class ChatlistViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatlistViewController>(
      () => ChatlistViewController(),
    );
  }
}
