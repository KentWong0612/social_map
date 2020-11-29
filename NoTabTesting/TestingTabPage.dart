import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Firebase/MapEventProvider.dart';

class TestingTabPage extends StatefulWidget {
  @override
  _TestingTabPageState createState() => _TestingTabPageState();
}

class _TestingTabPageState extends State<TestingTabPage> {
  @override
  Widget build(BuildContext context) {
    final eventTableDB = context.watch<EventTableFromDB>();
    return Container(
      child: Text('tsting,${eventTableDB.testinglist.length}'),
    );
  }
}
