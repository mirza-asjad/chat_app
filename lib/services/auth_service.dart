import 'dart:developer';
import 'package:chat_app/app/modules/signup/model/user_model.dart';
import 'package:chat_app/config/app_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_service.dart'; // Import UserService

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
      // Optionally, you can perform additional tasks like clearing cache
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
        // Update FCM tokens if provided
        await _userService.updateFCMTokens(user.uid, fcmToken);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      log('Error: ${e.message}');
      throw AuthException(e.code, e.message);
    } catch (e) {
      // Log general errors and rethrow
      log('Error: $e');
      throw AuthException('unknown-error', e.toString());
    }
  }

  //forget password
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Sign up with email and password, then save user details to Firestore
  Future<User?> signUp({
    required String email,
    required String name,
    required String password,
    required String phoneNumber,
    required List<String> fcmToken,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          name: name,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          fcmTokens: fcmToken,
          userSignupMethod: UserKey.USER_SIGNUP_METHOD_IS_EMAIL,
        );
        await _userService.addUser(newUser); // Use UserService to add user

        return user;
      }
    } on FirebaseAuthException catch (e) {
      // Log error and rethrow
      log('Error: $e');
      throw AuthException(e.code, e.message);
    } catch (e) {
      // Log general errors and rethrow
      log('Error: $e');
      throw AuthException('unknown-error', e.toString());
    }
    return null;
  }

  //google signin

  Future<User?> googleSignIn({required List<String> fcmToken}) async {
    try {
      // Step 1: Attempt Google Sign-In and retrieve authentication tokens
      GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: ["profile", "email"],
      ).signIn();

      if (googleUser == null) {
        log('Google sign-in canceled by user.');
        return null; // Sign-in was aborted
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      log('Google sign-in successful. User email: ${googleUser.email}');

      final normalizedEmail = googleUser.email.toLowerCase();

      // Step 2: Fetch sign-in methods associated with this email
      final List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(normalizedEmail);
      log('Sign-in methods for $normalizedEmail: $signInMethods');

      // Step 3: Check if the user exists in Firestore and get the userSignupMethod
      final userExists = await _userService.doesUserExist(normalizedEmail);
      log('User existence check in Firestore: $userExists');

      String? userSignupMethod;
      if (userExists) {
        final userDoc = await _userService.getUserByEmail(normalizedEmail);
        userSignupMethod = userDoc?.userSignupMethod;
        log('User found in Firestore. Signup method: $userSignupMethod');

        // Step 4: Check if the existing sign-up method is 'Email' and block Google sign-in
        if (userSignupMethod == UserKey.USER_SIGNUP_METHOD_IS_EMAIL) {
          log('Google sign-in canceled: Email already associated with an email/password account.');
          return null;
        }

        // If the sign-in method is 'Google', proceed with sign-in
        if (userSignupMethod == UserKey.USER_SIGNUP_METHOD_IS_GOOLE) {
          log('Google sign-in allowed: User created with Google sign-in.');
        } else {
          log('Google sign-in canceled: Unrecognized sign-up method.');
          return null;
        }
      } else {
        log('User does not exist in Firestore. Proceeding with Google sign-in.');
      }

      // Step 5: Proceed with Google sign-in using the authentication credentials
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      log('User signed in with Google. User UID: ${user?.uid}');

      // Step 6: Handle new user sign-up
      if (user != null && !userExists) {
        UserModel newUser = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          createdAt: user.metadata.creationTime ?? DateTime.now(),
          fcmTokens: fcmToken,
          userSignupMethod: UserKey.USER_SIGNUP_METHOD_IS_GOOLE,
        );
        await _userService.addUser(newUser);
        log('New user added to Firestore: ${user.email}');
      }

      // Step 7: Update FCM tokens for existing users
      if (user != null && userExists) {
        await _userService.updateFCMTokens(user.uid, fcmToken);
        log('Updated FCM tokens for user: ${user.email}');
      }

      return user;
    } catch (e) {
      log('Google sign-in failed: $e');
      return null;
    }
  }

  // Delete user
  Future<void> deleteUser() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception('No user is currently logged in');
      }

      await user.delete();
    } catch (e) {
      log('User deletion error: $e');
      // Consider rethrowing or handling the error if needed
    }
  }

  //remove FCMTOKEN
  Future<void> removeFCMToken(String token) async {
    try {
      final uid = getCurrentUserId();
      if (uid == null) {
        throw Exception('No user is currently logged in');
      }

      // Call UserService to remove FCM token
      await _userService.removeFCMToken(uid, token);
    } catch (e) {
      log('Error removing FCM token: $e');
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
