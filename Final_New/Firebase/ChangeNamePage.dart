import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthenticationService.dart';

class ChangeNamePage extends StatefulWidget {
  @override
  _ChangeNamePageState createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  TextEditingController currentnameController;
  final TextEditingController displaynameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    // suspicious here

    if (firebaseUser != null) {
      if (firebaseUser.displayName != null) {
        debugPrint('debug: display name = ' + firebaseUser.displayName);
      } else {
        debugPrint('debug: no display name');
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('New Display Name'),
      ),
      body: Column(children: [
        RichText(
            text: TextSpan(
          text: 'current display name: ' + firebaseUser.displayName,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        )),
        TextField(
          controller: displaynameController,
          decoration: InputDecoration(
            labelText: 'display name',
          ),
        ),
        RaisedButton(
          onPressed: () {
            firebaseUser.updateProfile(
                displayName: displaynameController.text.trim());
            debugPrint('debug: displayname texted ' +
                displaynameController.text.trim());
            context.read<AuthenticationService>().signOut();
            Navigator.pop(context);
          },
          child: Text('Submit'),
        ),
      ]),
    );
  }
}
