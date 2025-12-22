import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/models/xplora_user.dart';
import '../../domain/services/auth_service.dart';

class FirebaseAuthService extends AuthService {
  @override
  Future<XploraUser> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(userCredential.user!.uid).get();

    if (documentSnapshot.exists == false) {
      collectionReference.doc(userCredential.user!.uid).set({
        'email': email,
        'id': userCredential.user!.uid,
        'displayName': '',
        'username': '',
      });
    }

    documentSnapshot =
        await collectionReference.doc(userCredential.user!.uid).get();

    final data = documentSnapshot.data() as Map<String, dynamic>;
    return XploraUser(
      id: userCredential.user!.uid,
      email: userCredential.user!.email!,
      displayName: data['displayName'] ?? '',
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
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final now = DateTime.now().toUtc().toIso8601String();

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    await collectionReference.doc(userCredential.user!.uid).set({
      'email': email,
      'id': userCredential.user!.uid,
      'displayName': displayName,
      'username': '',
      'type': 'user',
      'createdAt': now,
      'updatedAt': now,
    });

    //send verification email
    await userCredential.user!.sendEmailVerification();

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
      displayName: data['displayName'] ?? '',
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
        displayName: data['displayName'] ?? '',
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
  Future<void> updateName(String name) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('users');
      await collectionReference.doc(user.uid).update({'name': name});
    }
  }

  @override
  Future<({XploraUser user, bool isNewUser})> signInWithGoogle() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      // Get GoogleSignIn instance and initialize if needed
      final googleSignIn = GoogleSignIn.instance;

      try {
        // Initialize Google Sign-In (call this only once, but it's safe to call multiple times)
        await googleSignIn.initialize();
      } catch (e) {
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
      UserCredential userCredential = await auth.signInWithCredential(credential);

      print('userCredential.user: ${userCredential.user}');

      // Check if this is a new user using Firebase's built-in check
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('users');

      print('isNewUser: $isNewUser');

      // If this is a new user, create a user document (same flow as email signup)
      if (isNewUser) {
        final now = DateTime.now().toUtc().toIso8601String();

        await collectionReference.doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'id': userCredential.user!.uid,
          'displayName': userCredential.user!.displayName ?? '',
          'username': '',
          'type': 'user',
          'createdAt': now,
          'updatedAt': now,
        });
      }

      // Fetch user document from Firestore
      DocumentSnapshot documentSnapshot =
          await collectionReference.doc(userCredential.user!.uid).get();

      // Return the user and isNewUser flag
      final data = documentSnapshot.data() as Map<String, dynamic>;
      return (
        user: XploraUser(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          displayName: data['displayName'] ?? '',
          username: data['username'] ?? '',
          isEmailVerified: userCredential.user!.emailVerified,
        ),
        isNewUser: isNewUser,
      );
    } on GoogleSignInException catch (e) {
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
}
