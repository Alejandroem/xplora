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
    String name,
    String username,
  );
  Future<void> signOut();

  Future<void> deleteAccount();

  Future<void> sendEmailVerification();
}
