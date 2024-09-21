import 'package:chat_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatlist_view_controller.dart';

class ChatlistViewView extends GetView<ChatlistViewController> {
  ChatlistViewView({super.key});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No chats available.'));
          }

          // List of users from Firestore
          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              // Extract user data
              var user = users[index];
              String? profileImageUrl = user['profileImageUrl']; // Make this nullable
              String name = user['name'] ?? 'Unknown';
              String lastMessage = user['lastMessage'] ?? 'No messages yet';
              String userId = user['uid'] ?? ''; // Get the user ID for navigation

              String lastOnline;
              if (user['lastOnline'] != null) {
                Timestamp timestamp = user['lastOnline'];
                DateTime lastOnlineDate = timestamp.toDate();
                DateTime now = DateTime.now();

                // Check if the last online date is today
                if (lastOnlineDate.year == now.year &&
                    lastOnlineDate.month == now.month &&
                    lastOnlineDate.day == now.day) {
                  // If today, show only the time
                  lastOnline = "${lastOnlineDate.hour}:${lastOnlineDate.minute.toString().padLeft(2, '0')}";
                } else {
                  // If not today, show full date and time
                  lastOnline = "${lastOnlineDate.year}-${lastOnlineDate.month.toString().padLeft(2, '0')}-${lastOnlineDate.day.toString().padLeft(2, '0')} ${lastOnlineDate.hour}:${lastOnlineDate.minute.toString().padLeft(2, '0')}";
                }
              } else {
                lastOnline = 'Offline';
              }

              return GestureDetector(
                onTap: () {
                  // Navigate to the user chat screen
                  Get.toNamed(Routes.CHATSCREEN); // Pass the user ID to the chat screen
                },
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: profileImageUrl != null && profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : NetworkImage('https://via.placeholder.com/150'), // Placeholder if no image
                        radius: 28,
                      ),
                      title: Text(
                        name,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        lastMessage,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(lastOnline, style: TextStyle(color: Colors.grey, fontSize: 8)),
                          SizedBox(height: 5),
                          if (index % 2 == 0) // Dummy condition for unread messages
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Color(0xFF25D366),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '5', // Replace with actual unread count if available
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(height: 0.5, color: Colors.black12, endIndent: 20, indent: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
