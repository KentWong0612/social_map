import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'addEventPageTest.dart';

class EventTableFromDB extends ChangeNotifier {
  DatabaseReference firebaseDB;
  StreamSubscription<Event> fireBaseDBSubScriptionInProvider;

  List<Map> testinglist = [];
  //List<Map> get obtainlist => testinglist;
  EventTableFromDB(DatabaseReference this.firebaseDB) {
    fireBaseDBSubScriptionInProvider =
        firebaseDB.child('event').onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        _getEventData();
      }
    });
  }

  Future<void> _getEventData() async {
    testinglist.clear();
    var snapshot2 = await firebaseDB.child('event').once();
    Map map2 = snapshot2.value;
    for (var element in map2.keys.toList()) {
      final innersnapshot =
          await firebaseDB.child('event').child(element).once();
      testinglist.add(innersnapshot.value);
    }
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
  final DatabaseReference fireBaseDB = FirebaseDatabase.instance.reference();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: EventTableFromDB(fireBaseDB))
    ],
    child: MaterialApp(
        home: Scaffold(
      body: ReadDataBasePage(),
    )),
  ));
}

class ReadDataBasePage extends StatefulWidget {
  @override
  _ReadDataBasePageState createState() => _ReadDataBasePageState();
}

class _ReadDataBasePageState extends State<ReadDataBasePage> {
  final DatabaseReference fireBaseDB = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> fireBaseDBSubScription;
  String eventname = '';
  String eventhost = '';
  EventTableFromDB eventTable;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireBaseDBSubScription =
        fireBaseDB.child('event').onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        setState(() {
          _getEventData();
        });
      }
    });
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
    //debugPrint('right after clear');
    //print(testinglist.length);
    var snapshot2 = await fireBaseDB.child('event').once();
    Map map2 = snapshot2.value;
    for (var element in map2.keys.toList()) {
      final innersnapshot =
          await fireBaseDB.child('event').child(element).once();
      testinglist.add(innersnapshot.value);
      //debugPrint('after entering');
      //print(testinglist.length);
    }
    //debugPrint('end entering');
    //print(testinglist.length);
    //debugPrint('end');
    await _get1stEventIntoVar();
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

  void _printfromProvider() {
    print('The total length is ${eventTable.testinglist.length}');
    print('The total length is ${testinglist.length}');
  }

  @override
  Widget build(BuildContext context) {
    eventTable = Provider.of<EventTableFromDB>(context);
    return Scaffold(
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
              RaisedButton(
                child: Text('print sth idk'),
                color: Colors.teal,
                onPressed: () {
                  _printfromProvider();
                },
              ),
              Text('eventName:${eventname}  eventhost:${eventhost} ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            ],
          ),
        ));
  }
}
