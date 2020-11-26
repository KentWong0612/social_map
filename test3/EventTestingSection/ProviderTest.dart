import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../MapEvent.dart';
import 'package:provider/provider.dart';
import 'addEventPageTest.dart';

class EventTableFromDB extends ChangeNotifier {
  DatabaseReference firebaseDB;

  //List<MapEvent> mapEventList;

  List<Map> testinglist = [];
  EventTableFromDB(DatabaseReference this.firebaseDB) {
    testinglist.clear();
    debugPrint('right after clear');
    print(testinglist.length);
    firebaseDB.child('event').once().then((DataSnapshot snapshot) {
      Map map = snapshot.value;
      map.keys.toList().forEach((element) {
        firebaseDB
            .child('event')
            .child(element)
            .once()
            .then((DataSnapshot innersnapshot) {
          testinglist.add(innersnapshot.value);
          debugPrint('after entering');
          print(testinglist.length);
        });
      });
    });
    debugPrint('end entering');
    print(testinglist.length);
    debugPrint('end');
    notifyListeners();
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
  String eventname = '';
  String eventhost = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _addEvent(BuildContext context) async {
    final navigator2 = Navigator.of(context);
    await navigator2.push(MaterialPageRoute(
        builder: (context) =>
            AddEventPageTest(LatLng(22.470412589523242, 113.99946647258345))));
  }

  //TODO: change then into await
  List<Map> testinglist = [];
  Future<void> _getEventData() async {
    testinglist.clear();
    debugPrint('right after clear');
    print(testinglist.length);
    var snapshot2 = await fireBaseDB.child('event').once();
    Map map2 = snapshot2.value;
    for (var element in map2.keys.toList()) {
      final innersnapshot =
          await fireBaseDB.child('event').child(element).once();
      testinglist.add(innersnapshot.value);
      debugPrint('after entering');
      print(testinglist.length);
    }
    debugPrint('end entering');
    print(testinglist.length);
    debugPrint('end');
    print(testinglist[1]);
    _get1stEventIntoVar();
  }

  void _get1stEventIntoVar() {
    if (testinglist.isEmpty == true) {
      print('data is not in yet');
    } else {
      setState(() {
        eventname = testinglist[1]['eventName'];
        eventhost = testinglist[1]['eventHost'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventTableFromDB>(
        create: (BuildContext context) {
          EventTableFromDB(fireBaseDB);
        },
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
                    child: Text('Push new event'),
                    color: Colors.redAccent,
                    onPressed: () {
                      _addEvent(context);
                    },
                  ),
                  RaisedButton(
                    child: Text('get evenb Data'),
                    color: Colors.teal,
                    onPressed: () {
                      _getEventData();
                    },
                  ),
                  Text('eventName:${eventname}  eventhost:${eventhost} ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                ],
              ),
            )));
  }
}
