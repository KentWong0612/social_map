import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Firebase/EmailPasswordSignInPage.dart';

//implement update frequency setting
class SettingPageTest extends StatefulWidget {
  @override
  _SettingPageTestState createState() => _SettingPageTestState();
}

class _SettingPageTestState extends State<SettingPageTest> {
  bool flag = true;
  SharedPreferences prefs;
  final String timePeriod = "timePeriod";

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.push(
        MaterialPageRoute(builder: (context) => EmailPasswordSignInPage()));
  }

  @override
  void dispose() {
    debugPrint('setting idspose called');
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Section',
          tiles: [
            SettingsTile(
              title: 'Login',
              subtitle: 'For business user only',
              leading: Icon(Icons.account_box),
              //to do use valuenotifier to implement after login ge log out interaface
              onTap: () {
                _signInWithEmailAndPassword(context);
              }, //() => _signInWithEmailAndPassword(context),
            ),
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
              title: 'testing',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
