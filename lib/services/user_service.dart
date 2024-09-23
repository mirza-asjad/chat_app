import 'dart:developer';

import 'package:chat_app/app/modules/signup/model/user_model.dart';
import 'package:chat_app/config/app_const.dart';
import 'package:chat_app/services/base_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService extends BaseService<UserModel> {
  UserService()
      : super(
          ref: FirebaseFirestore.instance
              .collection(CollectionKey.USERS)
              .withConverter<UserModel>(
                fromFirestore: (snapshot, _) =>
                    UserModel.fromFirestore(snapshot),
                toFirestore: (user, _) => user.toMap(),
              ),
        );

  Future<void> addUser(UserModel user) async {
    try {
      await addDocument(user, user.uid!); // Pass uid as the document ID
    } catch (e) {
      log('Error adding user: $e');
    }
  }

  Future<DocumentReference<UserModel>> docRef(String uid) async {
    return ref.doc(uid);
  }

// Method to update FCM tokens
  Future<void> updateFCMTokens(String uid, List<String> fcmToken) async {
    try {
      DocumentReference<UserModel> userRef = await docRef(uid);
      await userRef.update({
        UserKey.FCMTOKEN: FieldValue.arrayUnion(fcmToken),
      });
    } catch (e) {
      log('Error updating FCM tokens: $e');
    }
  }

  Future<void> deleteUserDocument(String uid) async {
    try {
      await deleteDocument(uid);
    } catch (e) {
      log('Error deleting user document: $e');
    }
  }

  Future<void> removeFCMToken(String uid, String token) async {
    try {
      // Check if the document exists
      final docSnapshot = await ref.doc(uid).get();

      if (!docSnapshot.exists) {
        log('Error removing FCM token: Document with uid $uid does not exist.');
        return; // Exit the function if the document does not exist
      }

      await ref.doc(uid).update({
        UserKey.FCMTOKEN: FieldValue.arrayRemove([token]),
      });
      log('FCM token removed successfully for uid $uid');
    } catch (e) {
      log('Error removing FCM token: $e');
    }
  }

  // Check if a user with the given email exists in Firestore
  Future<bool> doesUserExist(String email) async {
    final normalizedEmail = email.toLowerCase();
    final userQuery = await ref
        .where(UserKey.USER_EMAIL, isEqualTo: normalizedEmail)
        .limit(1)
        .get();

    return userQuery.docs.isNotEmpty;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await ref // Adjust the collection name as needed
          .where(UserKey.USER_EMAIL, isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      log('Error fetching user by email: $e');
      return null;
    }
  }

  // Method to update the user's name
  Future<void> updateUserName(String uid, String newName) async {
    try {
      DocumentReference<UserModel> userRef = await docRef(uid);
      await userRef.update({
        UserKey.USER_NAME: newName,
      });
      log('User name updated successfully for uid $uid');
    } catch (e) {
      log('Error updating user name: $e');
    }
  }

  // Method to update the user's phone number
  Future<void> updateUserPhoneNumber(String uid, String newPhoneNumber) async {
    try {
      DocumentReference<UserModel> userRef = await docRef(uid);
      await userRef.update({
        UserKey.PHONE_NUMBER: newPhoneNumber,
      });
      log('User phone number updated successfully for uid $uid');
    } catch (e) {
      log('Error updating user phone number: $e');
    }
  }

  Future<UserModel?> getUserInfo(String uid) async {
    try {
      DocumentSnapshot<UserModel> doc = await ref.doc(uid).get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      log('Error fetching user info: $e');
      return null;
    }
  }
}
