import 'package:google_maps_flutter/google_maps_flutter.dart';

//event class type to store necessary info
class Event {
  LatLng _eventLocation; //Latlng info
  String _eventName;
  int _eventID;
  String _eventHost; // name of organizer
  List<bool> _eventCatagory; // Idea [0] = NightLife, [1] = food
  String _eventDescription;
  List<bool> _targetAgeRange; //Idea: [0]=all, [1]=0-10 ...
  //int _eventPrice;                // if 0 =free,, if negative = vary
  //comment?
  //photo?
  //Time Varaible?DartTime

  //constructor
  Event(
      LatLng _eventLocation,
      String _eventName,
      int _eventID,
      String _eventHost,
      List<bool> _eventCatagory,
      String _eventDescription,
      int _eventPrice,
      List<bool> _targetAgeRange) {
    this._eventLocation = _eventLocation;
    this._eventName = _eventName;
    this._eventID = _eventID;
    this._eventHost = _eventHost;
    this._eventCatagory = _eventCatagory;
    this._eventDescription = _eventDescription;
    this._targetAgeRange = _targetAgeRange;
  }
}
