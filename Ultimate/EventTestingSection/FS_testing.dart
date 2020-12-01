import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../addEventPageFS.dart';

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
  final FirebaseFirestore storeRef = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot> fireStoreDBFSSubscription;
  String eventnamefs = '';
  String eventhostfs = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireStoreDBFSSubscription = storeRef.collection('event').where('').snapshots().listen((QuerySnapshot event) {
      if (event.docs != null) {
        //detect sucess
        setState(() {
          _getEventDataFS();
        });
      }
    });
  }

  Future<void> _addEvent(BuildContext context) async {
    final navigator2 = Navigator.of(context);
    await navigator2.push(MaterialPageRoute(builder: (context) => AddEventPage(LatLng(22.470412589523242, 113.99946647258345))));
  }

  //TODO: change then into await
  List<String> namelist = [];
  List<QueryDocumentSnapshot> eventID_FS_List = [];
  Map<String, Map> eventList = {};
  Future<void> _getEventDataFS() async {
    eventID_FS_List.clear();
    var snapshot = await storeRef.collection('event').get();
    print('Testing FS: snapshot is ${snapshot}');

    eventID_FS_List = snapshot.docs;
    print('Testing FS: snapshot.docs is ${eventID_FS_List}');

    for (var element in eventID_FS_List) {
      //element.data() = property of the event
      namelist.add(element.data()['eventName']);
      eventList[element.data()['eventName']] = element.data();
      print('Testing FS: tell me eventNature = ${element.data()['eventNature']}');
    }
    await _get1stEventIntoVarFS();
  }

  void _get1stEventIntoVarFS() {
    if (eventList.isEmpty == true) {
      print('data is not in yet');
    } else {
      setState(() {
        eventnamefs = eventList[namelist[0]]['eventName'];
        eventhostfs = eventList[namelist[0]]['eventHost'];
      });
    }
  }

  void _printlist() {
    print('Testing FS: The total length of the collection is ${eventID_FS_List.length}');
    print('Testing FS: looking into mapping of one ${eventID_FS_List[0].data()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Testing  function related FS'),
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
                child: Text('get event Data'),
                color: Colors.teal,
                onPressed: () {
                  _getEventDataFS();
                },
              ),
              RaisedButton(
                child: Text('print sth idk'),
                color: Colors.teal,
                onPressed: () {
                  _printlist();
                },
              ),
              Text('eventName:${eventnamefs}  eventhost:${eventhostfs} ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            ],
          ),
        ));
  }
}
