import 'package:google_maps_flutter/google_maps_flutter.dart';

//TODO: eventTvalidTime or EventexpireTime
//event class type to store necessary info
class Event {
  LatLng eventLocation;
  //Latlng info
  String eventName;
  //User input in apps
  int eventID;
  //TODO: implement a function computed event id from database
  String eventHost;
  //Problem: current auth service store no user name, need a table to store user name
  List<bool> eventCatagory;
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
  Event(LatLng _eventLocation, String _eventName, List<bool> _eventCatagory,
      String _eventDescription, List<bool> _targetAgeRange) {
    eventLocation = _eventLocation;
    eventName = _eventName;
    eventCatagory = _eventCatagory;
    eventDescription = _eventDescription;
    targetAgeRange = _targetAgeRange;
  }

  Event.fromFirebase(Map<dynamic, dynamic> json) {
    eventDescription = json['eventDescription'];
    eventHost = json['eventHost'];
    eventName = json['eventName'];
    eventLocation = LatLng(
        double.parse(json['lattitude']), double.parse(json['longitude']));
    //category and age missing
  }

  //setter and getter

}
