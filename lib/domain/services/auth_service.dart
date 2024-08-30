import '../models/xplora_user.dart';

abstract class AuthService {
  Future<bool> isSignedInFuture();
  Stream<bool> get isSignedIn;
  Stream<String?> getAuthUserStreamUserId();
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
}
