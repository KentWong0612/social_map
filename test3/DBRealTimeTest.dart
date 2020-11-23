import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseReference fireBaseDB = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> fireBaseDBSubScription;

  String userName = "Lufor129";
  String userSubject = "亞太系";
  String userId = "1122334455";

  @override
  void initState() {
    super.initState();
    fireBaseDBSubScription =
        fireBaseDB.child("user/${userId}").onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        Map map = event.snapshot.value;
        this.setState(() {
          userName = map['userName'];
          userSubject = map['userSubject'];
        });
      }
    });
  }
  //firebaseDB.child("table1") = open table1, if not exist, create it

  @override
  void dispose() {
    super.dispose();
    fireBaseDBSubScription.cancel();
  }

  //set(mapping) = insert/overwrite? element to the opened table (could consider as local field of opened table)
  void _set() {
    String userName = "Lufor129";
    String userSubject = "亞太系";
    String userId = "1122334455";

    Map<String, String> data = {
      "userName": userName,
      "userSubject": userSubject
    };

    fireBaseDB.child("user").child(userId).set(data).whenComplete(() {
      print("finish set");
    }).catchError((error) {
      print(error);
    });
  }

  //push() = create a empty table = create a unique key value
  void _push() {
    Map<String, String> favorite = {"興趣": "打電動"};
    fireBaseDB
        .child("user")
        .child(userId)
        .child("favorite")
        .push()
        .set(favorite)
        .whenComplete(() {
      print("push data");
    }).catchError((error) {
      print(error);
    });
  }

  //update a certain entry of the opened table
  void _update() {
    Map<String, String> data = {"userSubject": "資管系"};

    fireBaseDB.child("user/${userId}").update(data).whenComplete(() {
      print("update finish");
    }).catchError((error) {
      print(error);
    });
  }

  //return an table in term of array that indexed with the key
  void _fetch() {
    fireBaseDB.child("user/${userId}").once().then((DataSnapshot snapshot) {
      var user = snapshot.value;
      this.setState(() {
        userSubject = user['userSubject'];
      });
    }).catchError((error) {
      print(error);
    });
  }

  //return an table in term of array that indexed with the key, as this is a table of table and we dont know the key,
  //the table is convert and ordered as list, so that we obtain the key by calling list[0]
  void _remove() {
    fireBaseDB
        .child("user/${userId}/favorite")
        .once()
        .then((DataSnapshot snapshot) {
      Map map = snapshot.value;
      String key = map.keys.toList()[0];
      fireBaseDB
          .child("user/${userId}/favorite")
          .child(key)
          .remove()
          .whenComplete(() {
        print("remove finish");
      }).catchError((error) {
        print(error);
      });
    });
  }

  void _removeMajor() {
    fireBaseDB
        .child("user/${userId}")
        .child('userSubject')
        .remove()
        .whenComplete(() {
      print("remove finish");
    }).catchError((error) {
      print(error);
    });
  }

  void _getEventData() {
    fireBaseDB.child('event').once().then((DataSnapshot snapshot) {
      print(snapshot.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("CRUD DEMO"),
          backgroundColor: Colors.redAccent,
        ),
        body: new Container(
          padding: EdgeInsets.all(50),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new RaisedButton(
                child: new Text("SET"),
                onPressed: _set,
                color: Colors.redAccent,
              ),
              new RaisedButton(
                child: new Text("PUSH"),
                onPressed: _push,
                color: Colors.teal,
              ),
              new RaisedButton(
                  child: new Text("UPDATE"),
                  onPressed: _update,
                  color: Colors.amber),
              new RaisedButton(
                child: new Text("DELETE"),
                onPressed: _remove,
                color: Colors.greenAccent,
              ),
              new RaisedButton(
                  child: new Text("Fetch"),
                  onPressed: _fetch,
                  color: Colors.indigoAccent),
              new RaisedButton(
                child: new Text("Remove Major"),
                onPressed: _removeMajor,
                color: Colors.redAccent,
              ),
              new RaisedButton(
                child: new Text("print data"),
                onPressed: _getEventData,
                color: Colors.teal,
              ),
              new Text("userName: ${userName} userSubject: ${userSubject}",
                  style:
                      new TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            ],
          ),
        ));
  }
}
