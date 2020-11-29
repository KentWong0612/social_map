import 'package:firebase_auth/firebase_auth.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Firebase/AuthenticationService.dart';
import 'Firebase/ChangeNamePage.dart';
import 'Firebase/EmailPasswordSignInPage.dart';
import 'package:provider/provider.dart';

//implement update frequency setting
class SettingPage extends StatefulWidget {
  @override
  SettingPageState createState() => SettingPageState();
}

//TODO: implement refresh frequency
class SettingPageState extends State<SettingPage> {
  bool flag = true;
  SharedPreferences prefs;
  final String timePeriod = 'timePeriod';
  var firebaseUser;

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.push(
        MaterialPageRoute(builder: (context) => EmailPasswordSignInPage()));
  }

  Future<void> _changeDisplayName(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator
        .push(MaterialPageRoute(builder: (context) => ChangeNamePage()));
    debugPrint('debug: order check setting page');
  }

  @override
  void dispose() {
    debugPrint('setting dispose called');
    super.dispose();
  }

  Widget accountTiles(BuildContext context) {
    firebaseUser = context.watch<User>();

    if (firebaseUser == null) {
      return SettingsTile(
        title: 'Login',
        subtitle: 'For business user only',
        leading: Icon(Icons.account_box),
        //to do use valuenotifier to implement after login ge log out interaface
        onTap: () {
          _signInWithEmailAndPassword(context);
        },
      );
    } else {
      return SettingsTile(
        title: firebaseUser.email,
        subtitle: 'click here to change display name',
        leading: Icon(Icons.account_box),
        onTap: () {
          _changeDisplayName(context);
        },
        //to do use valuenotifier to implement after login ge log out interaface
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Section',
          tiles: [
            accountTiles(context),
            SettingsTile.switchTile(
              title: 'Use fingerprint',
              leading: Icon(Icons.fingerprint),
              switchValue: flag,
              onToggle: (bool value) {
                setState(() {
                  flag = !flag;
                });
              },
            ),
            SettingsTile(
              title: 'log out',
              leading: Icon(Icons.account_box),
              onTap: () {
                context.read<AuthenticationService>().signOut();
              },
            ),
            SettingsTile(
              title: 'test',
              leading: Icon(Icons.account_box),
              onTap: () {
                final snackBar =
                    new SnackBar(content: new Text('Please log in again'));
                Scaffold.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        ),
      ],
    );
  }
}