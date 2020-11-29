import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PushUserPage(),
    );
  }
}

class PushUserPage extends StatefulWidget {
  @override
  PushUserPageState createState() => PushUserPageState();
}

class PushUserPageState extends State<PushUserPage> {
  final DatabaseReference firebaseDB = FirebaseDatabase.instance.reference();

  //push an event to database(incomplete)
  //TODO: implement with eventcategory and eventage

  void pushEvent() {
    Map<String, String> event = {
      'eventDescription': 'fuckfuckfuck',
      'eventHost': 'Ku',
      'eventName': '1v1',
    };
    Map<String, double> eventOtherPart = {
      'lattitude': 1234.0,
      'longitude': 4321.0,
    };
    DatabaseReference pushEventDB = firebaseDB.child('event').push();
    pushEventDB.set(event).whenComplete(() {
      print('event pushed please check');
    }).catchError((error) {
      print(error);
    });
    pushEventDB.update(eventOtherPart).whenComplete(() {
      print('other part of event pushed please check');
    }).catchError((error) {
      print(error);
    });
    Map<String, bool> eventCategory = {
      'market': false,
      'nightlife': false,
      'sport': true,
      'photo spot': false,
      'sales': false, //TODO: rename to special promotion? + category=workshop?
    };
    Map<String, bool> targetAgeRange = {
      '0to10': false, //TODO: not start from 0 for sure?
      '11to17': true,
      '18+': true,
    };
    Map<String, Map<String, bool>> eventExtra = {
      'eventCategory': eventCategory,
      'targetAgeRange': targetAgeRange,
    };
    pushEventDB.update(eventExtra).whenComplete(() {
      print('Extra part of event pushed please check');
    }).catchError((error) {
      print(error);
    });
  }

  void testDataRetrieval() {
    DatabaseReference eventRef = firebaseDB.child('event');
    eventRef
        .orderByChild('eventName')
        .equalTo('1v1new')
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PushUserPage'),
        backgroundColor: Colors.amber,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 4,
            child: Container(
              height: 100,
              alignment: Alignment.center,
              child: ListTile(
                leading: CircleAvatar(
                  maxRadius: 30,
                  child: Image.network(
                    'https://cdn.iconscout.com/icon/free/png-256/avatar-372-456324.png',
                  ),
                ),
                title: new Text('lufor129'),
                subtitle: new Text('Lxsdaw51dsadwds'),
                trailing: new IconButton(
                  onPressed: () => {},
                  iconSize: 36,
                  icon: new Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Card(
            elevation: 4,
            child: new Container(
              height: 100,
              alignment: Alignment.center,
              child: new ListTile(
                leading: new CircleAvatar(
                  maxRadius: 30,
                  child: new Image.network(
                    'https://cdn.iconscout.com/icon/free/png-256/avatar-372-456324.png',
                  ),
                ),
                title: new Text('lufor129'),
                subtitle: new Text('Lxsdaw51dsadwds'),
                trailing: new IconButton(
                  onPressed: () => {},
                  iconSize: 36,
                  icon: new Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Card(
            elevation: 4,
            child: new Container(
              height: 100,
              alignment: Alignment.center,
              child: new ListTile(
                leading: new CircleAvatar(
                  maxRadius: 30,
                  child: new Image.network(
                    'https://cdn.iconscout.com/icon/free/png-256/avatar-372-456324.png',
                  ),
                ),
                title: new Text('lufor129'),
                subtitle: new Text('Lxsdaw51dsadwds'),
                trailing: new IconButton(
                  onPressed: () => {},
                  iconSize: 36,
                  icon: new Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Card(
            elevation: 4,
            child: new Container(
              height: 100,
              alignment: Alignment.center,
              child: new ListTile(
                leading: new CircleAvatar(
                  maxRadius: 30,
                  child: new Image.network(
                    'https://cdn.iconscout.com/icon/free/png-256/avatar-372-456324.png',
                  ),
                ),
                title: new Text('testing data retrival'),
                subtitle: new Text('Lxsdaw51dsadwds'),
                trailing: new IconButton(
                  onPressed: () {
                    print('tapped');
                    testDataRetrieval();
                  },
                  iconSize: 36,
                  icon: new Icon(Icons.clear),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushEvent();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
