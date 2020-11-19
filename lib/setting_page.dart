import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _setting = ['Update Frequency', 'Tag Filter', 'Notification Setting'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _setting.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2; /*3*/
          return ListTile(
              onTap: () {},
              title: Text(
                _setting[index],
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ));
        });
  }
}
