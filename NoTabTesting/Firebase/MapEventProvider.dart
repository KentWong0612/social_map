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
    debugPrint('right after clear');
    print(testinglist.length);

    var snapshot2 = await firebaseDB.child('event').once();
    Map map2 = snapshot2.value;

    for (var element in map2.keys.toList()) {
      final innersnapshot =
          await firebaseDB.child('event').child(element).once();
      testinglist.add(innersnapshot.value);
      debugPrint('after entering');
      print(testinglist.length);
    }
    debugPrint('end entering');
    print(testinglist.length);
    debugPrint('end');
    await notifyListeners();
  }
}
