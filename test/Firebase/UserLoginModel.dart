import 'package:flutter/cupertino.dart';
import 'Firebase_auth.dart';

class UserLoginModel extends ChangeNotifier {
  Auth auth;
  VoidCallback onSignedIn;
  UserLoginModel(this.auth, this.onSignedIn);

  void login() {
    notifyListeners();
  }

  void logout() {
    notifyListeners();
  }
}
