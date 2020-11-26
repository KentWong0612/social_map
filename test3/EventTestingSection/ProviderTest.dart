import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../MapEvent.dart';
import 'package:provider/provider.dart';
import 'addEventPageTest.dart';

class EventTableFromDB extends ChangeNotifier {
  final DatabaseReference firebaseDB = FirebaseDatabase.instance.reference();

  List<MapEvent> mapEventList;

  EventTableFromDB() {
    firebaseDB.child('event').once().then((DataSnapshot snapshot) {
      var sthReturned = snapshot.value;
      debugPrint('Trying to print out data obtained from DB');
      print(sthReturned);
    });
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      home: Scaffold(
    body: ReadDataBasePage(),
  )));
}

class ReadDataBasePage extends StatefulWidget {
  @override
  _ReadDataBasePageState createState() => _ReadDataBasePageState();
}

class _ReadDataBasePageState extends State<ReadDataBasePage> {
  final DatabaseReference fireBaseDB = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _addEvent(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.push(MaterialPageRoute(
        builder: (context) => AddEventPage(LatLng(123.0, 321.0))));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventTableFromDB>(
        create: (BuildContext context) {},
        child: Scaffold(
            appBar: AppBar(
              title: Text('Testing Event function related DB'),
              backgroundColor: Colors.redAccent,
            ),
            body: Container(
              padding: EdgeInsets.all(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RaisedButton(
                    child: Text('SET'),
                    color: Colors.redAccent,
                    onPressed: () {
                      _addEvent(context);
                    },
                  ),
                  RaisedButton(
                    child: Text('PUSH'),
                    color: Colors.teal,
                    onPressed: () {},
                  ),
                  RaisedButton(
                    child: Text('UPDATE'),
                    color: Colors.amber,
                    onPressed: () {},
                  ),
                  RaisedButton(
                    child: Text('DELETE'),
                    color: Colors.greenAccent,
                    onPressed: () {},
                  ),
                  RaisedButton(
                    child: Text('Fetch'),
                    color: Colors.indigoAccent,
                    onPressed: () {},
                  ),
                  RaisedButton(
                    child: Text('Remove Major'),
                    color: Colors.redAccent,
                    onPressed: () {},
                  ),
                  RaisedButton(
                    child: Text('print data'),
                    color: Colors.teal,
                    onPressed: () {},
                  ),
                  Text('userName:  userSubject: ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                ],
              ),
            )));
  }
}
