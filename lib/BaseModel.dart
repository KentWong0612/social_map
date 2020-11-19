import 'package:flutter/cupertino.dart';

class BaseModel extends ChangeNotifier {
  final bool login_flag = false;

  bool get login_state => login_flag;

  // maybe pass in a
  void logined() {}
}
