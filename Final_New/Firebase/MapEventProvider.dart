import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../MapEvent.dart';

class EventTableFromDB extends ChangeNotifier {
  //constructor that subscribe to to DB change
  EventTableFromDB(this.firebaseDB) {
    fireBaseDBSubScriptionInProvider =
        firebaseDB.child('event').onValue.listen((Event event) {
      _getEventData();
    });
  }

  final DatabaseReference firebaseDB;
  StreamSubscription<Event> fireBaseDBSubScriptionInProvider;

  //2 List that offer to descendants
  List<Map> testinglist = [];
  //List<MapEvent> eventlist = [];
  Map<String, MapEvent> eventMap = Map();
  //update function
  Future<void> _getEventData() async {
    //list clear
    testinglist.clear();
    debugPrint(
        'ProviderTest: right after clear and the length is ${testinglist.length}');
    eventMap.clear();
    debugPrint(
        'ProviderTest: right after clear and the eventlist length is ${eventMap.length}');

    //Obtain event table
    var eventID_table = await firebaseDB.child('event').once();
    // obtain Map for each event
    Map eventID_map = eventID_table.value;

    //for each event
    for (var element in eventID_map.keys.toList()) {
      //Obtain prop table
      final innersnapshot =
          await firebaseDB.child('event').child(element).once();
      //obtain map for each prop
      Map property_map = innersnapshot.value;

      //list of possible prop
      double lattitude;
      double longitude;
      String eventName;
      String eventHost;
      String eventAddress;
      Map eventNature;
      Map eventForm;
      //change to Map<string.bool>?
      String eventDescription;
      String startDate;
      String endDate;
      //TODO: add eventID?
      for (var key in property_map.keys.toList()) {
        if (key == 'lattitude') {
          if (property_map[key] != null) {
            lattitude = double.tryParse(property_map[key].toString());
          }
        } else if (key == 'longitude') {
          if (property_map[key] != null) {
            longitude = double.tryParse(property_map[key].toString());
          }
        } else if (key == 'eventName') {
          if (property_map[key] != null) {
            eventName = property_map[key];
          }
        } else if (key == 'eventHost') {
          if (property_map[key] != null) {
            eventHost = property_map[key];
          }
        } else if (key == 'eventAddress') {
          if (property_map[key] != null) {
            eventAddress = property_map[key];
          }
        } else if (key == 'eventDescription') {
          if (property_map[key] != null) {
            eventDescription = property_map[key];
          }
        } else if (key == 'startDate') {
          if (property_map[key] != null) {
            startDate = property_map[key];
          }
        } else if (key == 'endDate') {
          if (property_map[key] != null) {
            endDate = property_map[key];
          }
        } else if (key == 'eventNature') {
          if (property_map[key] != null) {
            final natureSnapshot = await firebaseDB
                .child('event')
                .child(element)
                .child('eventNature')
                .once();
            eventNature = natureSnapshot.value;
          }
        } else if (key == 'eventForm') {
          if (property_map[key] != null) {
            final formSnapshot = await firebaseDB
                .child('event')
                .child(element)
                .child('eventForm')
                .once();
            eventForm = formSnapshot.value;
          }
        } else {
          print('ProviderTest: error $key');
        }
      }
      eventMap[eventName] = MapEvent(
          LatLng(lattitude, longitude),
          eventName,
          eventHost,
          eventAddress,
          eventDescription,
          startDate,
          endDate,
          eventNature,
          eventForm);
      /*
      eventlist.add(MapEvent(
          LatLng(lattitude, longitude),
          eventName,
          eventHost,
          eventAddress,
          eventDescription,
          startDate,
          endDate,
          eventNature,
          eventForm));
      */
      testinglist.add(innersnapshot.value);
    }

    debugPrint(
        'ProviderTest: end entering and the length is ${testinglist.length}');
    debugPrint(
        'ProviderTest: end entering and the length of event Map is ${eventMap.length}');
    await notifyListeners();
  }
}
