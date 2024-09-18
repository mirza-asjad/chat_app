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
  final String?
      userSelectedCategory; // New optional field for selected category
  final String?
      userSelectedSubCategory; // New optional field for selected subcategory

  UserModel({
    this.uid,
    this.email,
    this.phoneNumber,
    this.createdAt,
    this.fcmTokens,
    this.name,
    this.userSignupMethod,
    this.userSelectedCategory, // Initialize the new field
    this.userSelectedSubCategory, // Initialize the new field
  });

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
      userSelectedCategory: data[UserKey.CATEGORY], // Extract the new field
      userSelectedSubCategory:
          data[UserKey.SUB_CATEGORY], // Extract the new field
    );
  }

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
    if (userSelectedCategory != null) {
      data[UserKey.CATEGORY] = userSelectedCategory;
    }
    if (userSelectedSubCategory != null) {
      data[UserKey.SUB_CATEGORY] = userSelectedSubCategory;
    }

    return data;
  }
}
