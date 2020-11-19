import 'dart:async';
import 'user.dart';
import 'AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //convert firebase user instance into custom user instance
  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      id: user.uid,
      email: user.email,
    );
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    // ignore: omit_local_variable_types
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> getCurrentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
