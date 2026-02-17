import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../domain/models/xplora_user.dart';
import '../../domain/services/auth_service.dart';

class FirebaseAuthService extends AuthService {
  final Duration _timeoutDuration = const Duration(seconds: 10);

  @override
  Future<XploraUser> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential = await auth
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .timeout(_timeoutDuration);

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot documentSnapshot = await collectionReference
        .doc(userCredential.user!.uid)
        .get()
        .timeout(_timeoutDuration);

    if (documentSnapshot.exists == false) {
      await collectionReference.doc(userCredential.user!.uid).set({
        'email': email,
        'id': userCredential.user!.uid,
        'name': '',
        'username': '',
      }).timeout(_timeoutDuration);
    }

    documentSnapshot = await collectionReference
        .doc(userCredential.user!.uid)
        .get()
        .timeout(_timeoutDuration);

    final data = documentSnapshot.data() as Map<String, dynamic>;
    return XploraUser(
      id: userCredential.user!.uid,
      email: userCredential.user!.email!,
      displayName: data['name'] ?? '',
      username: data['username'] ?? '',
      isEmailVerified: userCredential.user!.emailVerified,
    );
  }

  @override
  Future<void> signOut() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.signOut();
  }

  @override
  Future<XploraUser> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential = await auth
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .timeout(_timeoutDuration);

    final now = Timestamp.now();

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    await collectionReference.doc(userCredential.user!.uid).set({
      'email': email,
      'id': userCredential.user!.uid,
      'name': displayName,
      'username': '',
      'type': 'user',
      'createdAt': now,
      'updatedAt': now,
    }).timeout(_timeoutDuration);

    //send verification email
    // await userCredential.user!.sendEmailVerification();

    return XploraUser(
      id: userCredential.user!.uid,
      email: userCredential.user!.email!,
      displayName: displayName,
      username: '',
      isEmailVerified: userCredential.user!.emailVerified,
    );
  }

  @override
  Stream<bool> get isSignedIn {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.authStateChanges().map((user) => user != null);
  }

  @override
  Future<XploraUser?> getAuthUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return null;
    }

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(user.uid).get();

    // Check if document exists and get data safely
    final data = documentSnapshot.exists && documentSnapshot.data() != null
        ? documentSnapshot.data() as Map<String, dynamic>
        : <String, dynamic>{};

    return XploraUser(
      id: user.uid,
      email: user.email!,
      displayName: data['name'] ?? '',
      username: data['username'] ?? '',
      isEmailVerified: user.emailVerified,
    );
  }

  @override
  Stream<String?> getAuthUserStreamUserId() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }

      return user.uid;
    });
  }

  @override
  Future<bool> isSignedInFuture() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user != null;
  }

  @override
  Future<void> deleteAccount() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  @override
  Stream<XploraUser?> getAuthUserStream() {
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    return auth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        return null;
      }
      await user.reload();

      DocumentSnapshot documentSnapshot =
          await collectionReference.doc(user.uid).get();

      // Check if document exists and get data safely
      final data = documentSnapshot.exists && documentSnapshot.data() != null
          ? documentSnapshot.data() as Map<String, dynamic>
          : <String, dynamic>{};

      return XploraUser(
        id: user.uid,
        email: user.email!,
        displayName: data['name'] ?? '',
        username: data['username'] ?? '',
        isEmailVerified: user.emailVerified,
      );
    });
  }

  @override
  Future<void> sendEmailVerification() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<bool> changePassword(String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      await user.updatePassword(password);
      return true;
    }
    return false;
  }

  @override
  Future<void> updateEmail(String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      await user.verifyBeforeUpdateEmail(email);
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('users');
      await collectionReference.doc(user.uid).update({'email': email});
    }
  }

  @override
  Future<({XploraUser user, bool isNewUser, String? photoUrl})>
      signInWithGoogle() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      // Get GoogleSignIn instance and initialize if needed
      final googleSignIn = GoogleSignIn.instance;

      try {
        // Initialize Google Sign-In (call this only once, but it's safe to call multiple times)
        // Network call: may fetch configuration from Google servers
        await googleSignIn.initialize().timeout(_timeoutDuration);
        print('Google Sign-In initialized');
      } catch (e) {
        print('Google Sign-In initialization failed: $e');
        // If already initialized, this might throw - that's okay
      }

      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential (Firebase only requires idToken for Google Sign-In)
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential =
          await auth.signInWithCredential(credential).timeout(_timeoutDuration);

      print('userCredential.user: ${userCredential.user}');

      // Check if this is a new user using Firebase's built-in check
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('users');

      print('isNewUser: $isNewUser');

      // If this is a new user, create a user document (same flow as email signup)
      if (isNewUser) {
        final now = Timestamp.now();

        await collectionReference.doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'id': userCredential.user!.uid,
          'name': userCredential.user!.displayName ?? '',
          'username': '',
          'type': 'user',
          'createdAt': now,
          'updatedAt': now,
        }).timeout(_timeoutDuration);
      }

      // Fetch user document from Firestore
      DocumentSnapshot documentSnapshot = await collectionReference
          .doc(userCredential.user!.uid)
          .get()
          .timeout(_timeoutDuration);

      // Return the user, isNewUser flag, and photoUrl from Google
      final data = documentSnapshot.data() as Map<String, dynamic>;
      return (
        user: XploraUser(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          displayName: data['name'] ?? '',
          username: data['username'] ?? '',
          isEmailVerified: userCredential.user!.emailVerified,
        ),
        isNewUser: isNewUser,
        photoUrl: userCredential.user!.photoURL,
      );
    } on GoogleSignInException catch (e) {
      print('GoogleSignInException: $e');
      // Handle Google Sign-In specific exceptions
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('sign_in_canceled');
      }
      rethrow;
    } catch (e) {
      // Re-throw other exceptions so they can be handled by the notifier
      rethrow;
    }
  }

  /// Generate nonce for Apple Sign In
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Generate SHA256 hash of nonce
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<({XploraUser user, bool isNewUser, String? photoUrl})>
      signInWithApple() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      // Generate nonce for security (prevents replay attacks)
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request Apple credentials with email and fullName scopes
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce, // Send hashed nonce to Apple
      );

      print('Apple ID Token: ${appleCredential.identityToken}');
      print('Apple User ID: ${appleCredential.userIdentifier}');

      // Create Firebase OAuth credential for Apple
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce, // Send original nonce to Firebase for verification
      );

      // Sign in to Firebase with the Apple credential
      UserCredential userCredential =
          await auth.signInWithCredential(credential).timeout(_timeoutDuration);

      print('userCredential.user: ${userCredential.user}');

      // Check if this is a new user using Firebase's built-in check
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      // Extract name from Apple's response
      // Apple only provides name on first sign-in
      String displayName = '';
      if (appleCredential.givenName != null &&
          appleCredential.familyName != null) {
        displayName =
            '${appleCredential.givenName!.trim()} ${appleCredential.familyName}'.trim();
      } else if (appleCredential.givenName != null) {
        displayName = appleCredential.givenName!.trim();
      } else if (userCredential.user?.displayName != null) {
        // Fallback to Firebase user display name if available
        displayName = userCredential.user!.displayName!.trim();
      }

      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('users');

      print('isNewUser: $isNewUser');

      // If this is a new user, create a user document (same flow as Google/email signup)
      if (isNewUser) {
        final now = Timestamp.now();

        await collectionReference.doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email ?? '',
          'id': userCredential.user!.uid,
          'name': displayName,
          'username': '',
          'type': 'user',
          'createdAt': now,
          'updatedAt': now,
        }).timeout(_timeoutDuration);
      }

      // Fetch user document from Firestore
      DocumentSnapshot documentSnapshot = await collectionReference
          .doc(userCredential.user!.uid)
          .get()
          .timeout(_timeoutDuration);

      // Return the user, isNewUser flag, and photoUrl (Apple doesn't provide photos)
      final data = documentSnapshot.data() as Map<String, dynamic>;
      return (
        user: XploraUser(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          displayName: data['name'] ?? '',
          username: data['username'] ?? '',
          isEmailVerified: userCredential.user!.emailVerified,
        ),
        isNewUser: isNewUser,
        photoUrl: null, // Apple doesn't provide profile photos
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      print('SignInWithAppleAuthorizationException: $e');
      // Handle Apple Sign-In specific exceptions
      if (e.code == AuthorizationErrorCode.canceled) {
        throw Exception('sign_in_canceled');
      } else if (e.code == AuthorizationErrorCode.failed) {
        throw Exception('Apple Sign-In failed. Please try again.');
      } else if (e.code == AuthorizationErrorCode.invalidResponse) {
        throw Exception('Invalid response from Apple. Please try again.');
      } else if (e.code == AuthorizationErrorCode.notHandled) {
        throw Exception('Apple Sign-In was not handled. Please try again.');
      } else if (e.code == AuthorizationErrorCode.unknown) {
        throw Exception('An unknown error occurred with Apple Sign-In.');
      }
      rethrow;
    } catch (e) {
      // Re-throw other exceptions so they can be handled by the notifier
      rethrow;
    }
  }
}
