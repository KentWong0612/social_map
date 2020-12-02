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
        debugPrint('ProviderTestFS: detect success');
        _getEventDataFS();
      } else {
        debugPrint('ProviderTestFS: sth ho wrong');
      }
    });
  }

  final FirebaseFirestore firebaseDBFS;
  StreamSubscription<QuerySnapshot> fireBaseDBFSSubScriptionInProvider;

  //proplist = [element.data(), element.data(), element.data()...]
  List<Map> proplist = [];
  //eventMapFS = {'1v1': element.data(), ...}
  Map<String, MapEvent> eventMapFS = Map();
  Future<void> _getEventDataFS() async {
    proplist.clear();
    debugPrint('ProviderTestFS: right after clear and the length is ${proplist.length}');
    eventMapFS.clear();
    debugPrint('ProviderTestFS: right after clear and the eventlist length is ${eventMapFS.length}');

    //Obtain event table
    var eventID_table = await firebaseDBFS.collection('event').get();
    // eventID_table.docs =[Instance of 'QueryDocumentSnapshot', Instance of 'QueryDocumentSnapshot']
    List<QueryDocumentSnapshot> eventID_list = eventID_table.docs;
    debugPrint('ProviderTestFS: eventID_table.docs is ${eventID_table.docs}');
    //for each event
    for (var element in eventID_list) {
      //element.data() = {eventAddress: Home, lattitude: 22.470412589523242, ...}
      Map property_map = element.data();
      debugPrint('ProviderTestFS: element is $element, property_map is ${property_map}');
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
        } else if (key == 'uid') {
          ;
        } else {
          print('ProviderTestFS: error $key');
        }
      }
      eventMapFS[eventName] = MapEvent(LatLng(lattitude, longitude), eventName, eventHost, eventAddress, eventDescription, startDate, endDate, eventNature, eventForm);
      proplist.add(element.data());
    }

    debugPrint('ProviderTestFS: end entering and the length is ${proplist.length}');
    debugPrint('ProviderTestFS: end entering and the length of event Map is ${eventMapFS.length}');
    //await notifyListeners();
  }
}
