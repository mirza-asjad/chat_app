import 'dart:developer';
import 'dart:io';
import 'package:chat_app/app/modules/signup/model/user_model.dart';
import 'package:chat_app/config/app_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_service.dart'; // Import UserService
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService(); // Initialize UserService

  // Get current user ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      log("User signed out successfully.");
    } catch (e) {
      log("Error signing out: $e");
    }
  }

  // Sign in with email and password
  Future<User?> signIn({
    required String email,
    required String password,
    List<String>? fcmToken, // Optional FCM token parameter
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null && fcmToken != null) {
        await _userService.updateFCMTokens(user.uid, fcmToken);
      }

      log("User signed in: ${user?.email}");
      return user;
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.message}');
      throw AuthException(e.code, e.message);
    } catch (e) {
      log('Sign-in error: $e');
      throw AuthException('unknown-error', e.toString());
    }
  }
  // Upload image to Firebase Storage and return the image URL
  Future<String?> uploadProfileImage(String uid, File file) async {
    try {
      log('$file');
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/$uid');
      log('$file');
      UploadTask uploadTask = storageRef.putFile(file);
      log('$file');

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        log('Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}');
      });

      // Wait for the upload to complete and get the image URL
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      log('Profile image uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      log('Error uploading profile image: $e');
      return null; // Return null if upload fails
    }
  }


  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log("Password reset email sent to: $email");
    } catch (e) {
      log("Error sending password reset email: $e");
      throw AuthException('password-reset-error', e.toString());
    }
  }

  // Sign up with email and password, then save user details to Firestore
  Future<User?> signUp({
  required String email,
  required String name,
  required String password,
  required String phoneNumber,
  required List<String> fcmToken,
  File? profileImagePath, // Local file path of the profile image
}) async {
  try {
    // Step 1: Create user with email and password
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;

    if (user != null) {
      // Step 2: Upload profile image to Firebase Storage
      String? profileImageUrl;
      if (profileImagePath != null) {
        profileImageUrl = await uploadProfileImage(user.uid, profileImagePath);
      }

      // Step 3: Create UserModel and save to Firestore
      UserModel newUser = UserModel(
        uid: user.uid,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        fcmTokens: fcmToken,
        userSignupMethod: UserKey.USER_SIGNUP_METHOD_IS_EMAIL,
        profileImageUrl: profileImageUrl, // Use uploaded image URL
        lastOnline: DateTime.now(),
      );
      await _userService.addUser(newUser);

      log("User signed up and saved to Firestore: ${user.email}");
      return user;
    }
  } on FirebaseAuthException catch (e) {
    log('FirebaseAuthException during sign-up: $e');
    throw AuthException(e.code, e.message);
  } catch (e) {
    log('Error during sign-up: $e');
    throw AuthException('unknown-error', e.toString());
  }
  return null;
}


  // Google sign-in
  Future<User?> googleSignIn({
  required List<String> fcmToken,
  String? profileImagePath, // Local file path of the profile image
}) async {
  try {
    // Step 1: Google sign-in logic
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      log('Google sign-in canceled by user.');
      return null;
    }

    final normalizedEmail = googleUser.email.toLowerCase();

    // Step 2: Fetch sign-in methods
    final List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(normalizedEmail);

    final userExists = await _userService.doesUserExist(normalizedEmail);
    String? userSignupMethod;

    if (userExists) {
      final userDoc = await _userService.getUserByEmail(normalizedEmail);
      userSignupMethod = userDoc?.userSignupMethod;

      // Block sign-in if the user was signed up using email/password
      if (userSignupMethod == UserKey.USER_SIGNUP_METHOD_IS_EMAIL) {
        log('Google sign-in canceled: Email associated with email/password account.');
        return null;
      }
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await _auth.signInWithCredential(credential);
    User? user = userCredential.user;

    // Step 3: Handle new user sign-up
    if (user != null && !userExists) {
      // // Upload profile image if provided
      // String? profileImageUrl;
      // if (profileImagePath != null) {
      //   profileImageUrl = await uploadProfileImage(user.uid, profileImagePath);
      // }

      UserModel newUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        createdAt: DateTime.now(),
        fcmTokens: fcmToken,
        userSignupMethod: UserKey.USER_SIGNUP_METHOD_IS_GOOGLE,
        // profileImageUrl: profileImageUrl,
        lastOnline: DateTime.now(),
      );
      await _userService.addUser(newUser);
      log('New user added to Firestore: ${user.email}');
    }

    // Update FCM tokens if user exists
    if (user != null && userExists) {
      await _userService.updateFCMTokens(user.uid, fcmToken);
    }

    return user;
  } catch (e) {
    log('Google sign-in failed: $e');
    throw AuthException('google-sign-in-error', e.toString());
  }
}

  // Delete user account
  Future<void> deleteUser() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception('No user is currently logged in');
      }

      await user.delete();
      log('User deleted successfully.');
    } catch (e) {
      log('User deletion error: $e');
      throw AuthException('delete-user-error', e.toString());
    }
  }

  // Remove FCM token
  Future<void> removeFCMToken(String token) async {
    try {
      final uid = getCurrentUserId();
      if (uid == null) {
        throw Exception('No user is currently logged in');
      }

      await _userService.removeFCMToken(uid, token);
      log('FCM token removed successfully.');
    } catch (e) {
      log('Error removing FCM token: $e');
      throw AuthException('remove-fcm-token-error', e.toString());
    }
  }
}

// Custom exception class for authentication errors
class AuthException implements Exception {
  final String code;
  final String? message;
  AuthException(this.code, [this.message]);

  @override
  String toString() => message ?? code;
}
