import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({String email, String password}) async {
    try {
      UserCredential login_result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      debugPrint('debug: sigin called with ac = ' + email);
      return 'signed in';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signOut() async {
    await _firebaseAuth.signOut();
    debugPrint('debug: signout called');
    return 'SignOut called';
  }

  Future<User> currentUser() async {
    User testing_var = await _firebaseAuth.currentUser;
    if (testing_var == null) {
      debugPrint('debug: null returned');
      return null;
    } else {
      debugPrint('debug:' + testing_var.email);
      return testing_var;
    }
  }
}
