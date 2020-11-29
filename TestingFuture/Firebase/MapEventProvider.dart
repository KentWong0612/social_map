import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class EventTableFromDB extends ChangeNotifier {
  EventTableFromDB(this.firebaseDB) {
    fireBaseDBSubScriptionInProvider =
        firebaseDB.child('event').onValue.listen((Event event) {
      _getEventData();
    });
  }

  final DatabaseReference firebaseDB;
  StreamSubscription<Event> fireBaseDBSubScriptionInProvider;
  List<Map> testinglist = [];

  Future<void> _getEventData() async {
    testinglist.clear();
    debugPrint('right after clear and the length is ${testinglist.length}');
    var eventID = await firebaseDB.child('event').once();
    Map map2 = eventID.value;

    for (var element in map2.keys.toList()) {
      final innersnapshot =
          await firebaseDB.child('event').child(element).once();
      testinglist.add(innersnapshot.value);
    }
    debugPrint('end entering and the length is ${testinglist.length}');
    await notifyListeners();
  }
}
