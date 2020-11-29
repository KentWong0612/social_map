import 'package:google_maps_flutter/google_maps_flutter.dart';

//TODO: eventTvalidTime or EventexpireTime
//TODO: add an eventAdress <String>
//TODO: category by form
//TODO: category by nature
//event class type to store necessary info
//TODO: list bool -> list int such that 2 = major 1= minor 0 = not
class MapEvent {
  LatLng eventLocation;
  //Latlng info
  String eventName;
  //User input in apps
  int eventID;
  //TODO: implement a function computed event id from database
  String eventHost;
  //Problem: current auth service store no user name, need a table to store user name
  List<bool> eventNature;
  List<bool> eventForm;
  //User selected in apps, multi-select available, Idea [0] = NightLife, [1] = food
  //TODO: need to design the category
  String eventDescription;
  //User input in apps
  List<bool> targetAgeRange;
  //User selected in apps, multi-select available, Idea: [0]=all, [1]=0-10 ...

  /*
    Other possible parameter:
      int _eventPrice;                // if 0 =free,, if negative = vary
      comment?
      photo?
      Time Varaible?DartTime
  */

  //constructor
  //TODO: add assert function
  MapEvent(
      LatLng _eventLocation,
      String _eventName,
      List<bool> _eventNature,
      List<bool> _eventForm,
      String _eventDescription,
      List<bool> _targetAgeRange) {
    eventLocation = _eventLocation;
    eventName = _eventName;
    eventNature = _eventNature;
    eventForm = _eventForm;
    eventDescription = _eventDescription;
    targetAgeRange = _targetAgeRange;
  }

  MapEvent.fromFirebase(Map<dynamic, dynamic> json) {
    eventDescription = json['eventDescription'];
    eventHost = json['eventHost'];
    eventName = json['eventName'];
    eventLocation = LatLng(
        double.parse(json['lattitude']), double.parse(json['longitude']));
    //category and age missing
  }

  //setter and getter

}
/*
  //testing event
  //suppose database return a list of event
  _allMarkers.add(createMarkerFromEvent(basketballMatch));
  MapEvent basketballMatch = MapEvent(
      LatLng(22.465942018277172, 114.00185947335554),
      'basketballMatch',
      [false, true, false],
      [false, true, false],
      'this is a basketball match',
      [false, true, false]);

  //create marker out of event
  Marker createMarkerFromEvent(MapEvent event) {
    return Marker(
      markerId: MarkerId(event.eventName),
      draggable: false,
      position: event.eventLocation,
      onTap: () {
        debugPrint('debug: ' + event.eventName + ' tapped');
      },
    );
  }
*/
