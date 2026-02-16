import '../models/xplora_user.dart';

abstract class AuthService {
  Future<bool> changePassword(String password);
  Future<bool> isSignedInFuture();
  Stream<bool> get isSignedIn;
  Stream<String?> getAuthUserStreamUserId();
  Stream<XploraUser?> getAuthUserStream();
  Future<XploraUser?> getAuthUser();
  Future<XploraUser> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<XploraUser> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  );
  Future<void> signOut();

  Future<void> deleteAccount();

  Future<void> sendEmailVerification();

  Future<void> updateEmail(String email);

  /// Returns a record with the user, whether this is a new user (first Google sign-in), and optional photo URL
  Future<({XploraUser user, bool isNewUser, String? photoUrl})>
      signInWithGoogle();

  /// Returns a record with the user, whether this is a new user (first Apple sign-in), and optional photo URL
  Future<({XploraUser user, bool isNewUser, String? photoUrl})>
      signInWithApple();
}
