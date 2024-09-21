import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chatscreen_controller.dart';

class ChatscreenView extends GetView<ChatscreenController> {
  const ChatscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with User'), // Customize as needed
      ),
      body: Center(
        child: Text('Chat screen for user:'), // Load chat messages here
      ),
    );
  }
}