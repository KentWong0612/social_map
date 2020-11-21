import 'package:google_maps_flutter/google_maps_flutter.dart';

//event class type to store necessary info
class Event {
  LatLng _eventLocation;
  //Latlng info
  String _eventName;
  //User input in apps
  int _eventID;
  //TODO: implement a function computed event id from database
  String _eventHost;
  //Problem: current auth service store no user name, need a table to store user name
  List<bool> _eventCatagory;
  //User selected in apps, multi-select available, Idea [0] = NightLife, [1] = food
  //TODO: need to design the category
  String _eventDescription;
  //User input in apps
  List<bool> _targetAgeRange;
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
    this._eventLocation = _eventLocation;
    this._eventName = _eventName;
    this._eventCatagory = _eventCatagory;
    this._eventDescription = _eventDescription;
    this._targetAgeRange = _targetAgeRange;
  }

  //return a testing event
  Event test_home_event() {
    Event home_event = Event(
        LatLng(22.470100, 113.998738),
        'Home_explosion',
        //category have to design first
        [true, false, true],
        'my home exploded',
        [true, false, true]);
  }
}
