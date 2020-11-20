import 'dart:async';
import 'user.dart';

abstract class AuthService {
  //Future<User> currentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> getCurrentUser();
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
  void dispose(); //neccessary?
}
