import '../models/xplora_user.dart';

abstract class AuthService {
  Stream<bool> get isSignedIn;
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
