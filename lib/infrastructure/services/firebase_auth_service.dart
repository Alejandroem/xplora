import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        'name': '',
        'username': '',
      });
    }

    documentSnapshot =
        await collectionReference.doc(userCredential.user!.uid).get();

    return XploraUser(
      id: userCredential.user!.uid,
      email: userCredential.user!.email!,
      name: documentSnapshot['name'],
      username: documentSnapshot['username'],
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
    String name,
    String username,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    await collectionReference.doc(userCredential.user!.uid).set({
      'email': email,
      'id': userCredential.user!.uid,
      'name': name,
      'username': username,
    });

    return XploraUser(
      id: userCredential.user!.uid,
      email: userCredential.user!.email!,
      name: name,
      username: username,
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

    return XploraUser(
      id: user.uid,
      email: user.email!,
      name: documentSnapshot['name'],
      username: documentSnapshot['username'],
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
}
