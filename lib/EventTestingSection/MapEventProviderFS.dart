import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../MapEvent.dart';

class EventTableFromDBFS extends ChangeNotifier {
  //constructor that subscribe to to DB change
  EventTableFromDBFS(this.firebaseDBFS) {
    fireBaseDBFSSubScriptionInProvider = firebaseDBFS.collection('event').where('').snapshots().listen((QuerySnapshot event) {
      if (event.docs != null) {
        //detect sucess
        _getEventDataFS();
      }
    });
  }
  final FirebaseFirestore firebaseDBFS;
  StreamSubscription<QuerySnapshot> fireBaseDBFSSubScriptionInProvider;

  //proplist[0] = {{eventName:'sth'}, {eventHost:'sthsth'}, ...  }
  List<Map> proplist = [];
  Map<String, MapEvent> eventMapFS = Map();
  Future<void> _getEventDataFS() async {
    //list clear
    proplist.clear();
    debugPrint('ProviderTest: right after clear and the length is ${proplist.length}');
    eventMapFS.clear();
    debugPrint('ProviderTest: right after clear and the eventlist length is ${eventMapFS.length}');

    //Obtain event table
    var eventID_table = await firebaseDBFS.collection('event').get();
    // obtain Map for each event
    List<QueryDocumentSnapshot> eventID_list = eventID_table.docs;

    //for each event
    for (var element in eventID_list) {
      Map property_map = element.data();

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
      //TODO: FS have type check, here may need modify
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
            eventNature = property_map[key];
          }
        } else if (key == 'eventForm') {
          if (property_map[key] != null) {
            eventForm = property_map[key];
          }
        } else {
          print('ProviderTest: error $key');
        }
      }
      eventMapFS[eventName] = MapEvent(LatLng(lattitude, longitude), eventName, eventHost, eventAddress, eventDescription, startDate, endDate, eventNature, eventForm);
      proplist.add(element.data());
    }

    debugPrint('ProviderTest: end entering and the length is ${proplist.length}');
    debugPrint('ProviderTest: end entering and the length of event Map is ${eventMapFS.length}');
    await notifyListeners();
  }
}
