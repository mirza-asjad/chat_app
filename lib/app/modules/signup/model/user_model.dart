import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/config/app_const.dart';

class UserModel {
  final String? uid; // Optional field
  final String? email; // Optional field
  final String? phoneNumber; // Optional field
  final DateTime? createdAt; // Optional field
  final List<String>?
      fcmTokens; // Optional field for a list of Firebase Cloud Messaging tokens
  final String? name; // Optional field
  final String? userSignupMethod; // Optional field for signup method
  final String? profileImageUrl; // New optional field for profile image URL
  final DateTime? lastOnline; // New optional field for last online timestamp
  final String? lastMessage; // New optional field for last message, defaults to "No messages yet"

  UserModel({
    this.uid,
    this.email,
    this.phoneNumber,
    this.createdAt,
    this.fcmTokens,
    this.name,
    this.userSignupMethod,
    this.profileImageUrl, // Initialize profile image field
    this.lastOnline, // Initialize last online field
    this.lastMessage = "No messages yet", // Initialize with default value
  });

  // Factory method to create a UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return UserModel(
      uid: data[UserKey.UID],
      email: data[UserKey.USER_EMAIL],
      phoneNumber: data[UserKey.PHONE_NUMBER],
      createdAt: data[UserKey.CREATED_AT] != null
          ? (data[UserKey.CREATED_AT] as Timestamp).toDate()
          : null,
      fcmTokens: (data[UserKey.FCMTOKEN] as List<dynamic>?)
          ?.map((token) => token as String)
          .toList(),
      name: data[UserKey.USER_NAME],
      userSignupMethod: data[UserKey.USER_SIGNUP_METHOD],
      profileImageUrl: data[UserKey.PROFILE_IMAGE_URL], // Extract profile image
      lastOnline: data[UserKey.LAST_ONLINE] != null
          ? (data[UserKey.LAST_ONLINE] as Timestamp).toDate()
          : null, // Extract and convert lastOnline timestamp
      lastMessage: data[UserKey.LAST_MESSAGE] ?? "No messages yet", // Extract last message with default value
    );
  }

  // Method to convert UserModel to Firestore data (for saving/updating)
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    if (uid != null) data[UserKey.UID] = uid;
    if (email != null) data[UserKey.USER_EMAIL] = email;
    if (phoneNumber != null) data[UserKey.PHONE_NUMBER] = phoneNumber;
    if (createdAt != null) {
      data[UserKey.CREATED_AT] = Timestamp.fromDate(createdAt!);
    }
    if (fcmTokens != null) data[UserKey.FCMTOKEN] = fcmTokens;
    if (name != null) data[UserKey.USER_NAME] = name;
    if (userSignupMethod != null) {
      data[UserKey.USER_SIGNUP_METHOD] = userSignupMethod;
    }
    if (profileImageUrl != null) {
      data[UserKey.PROFILE_IMAGE_URL] = profileImageUrl;
    }
    if (lastOnline != null) {
      data[UserKey.LAST_ONLINE] = Timestamp.fromDate(lastOnline!);
    }
    if (lastMessage != null) {
      data[UserKey.LAST_MESSAGE] = lastMessage;
    }

    return data;
  }
}
