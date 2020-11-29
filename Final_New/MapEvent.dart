import 'package:google_maps_flutter/google_maps_flutter.dart';

//TODO: eventTvalidTime or EventexpireTime
//TODO: add an eventAdress <String>
//TODO: category by form
//TODO: category by nature
//event class type to store necessary info
//TODO: list bool -> list int such that 2 = major 1= minor 0 = not
class MapEvent {
  LatLng eventLocation;
  String eventName;
  //int eventID;
  String eventHost;
  String eventAddress;
  dynamic eventNature;
  dynamic eventForm;
  String eventDescription;
  //List<bool> targetAgeRange;
  String startDate;
  String endDate;

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
      this.eventLocation,
      this.eventName,
      this.eventHost,
      this.eventAddress,
      this.eventDescription,
      this.startDate,
      this.endDate,
      this.eventNature,
      this.eventForm) {
    //print('Map event created $eventName and eventNature are ${eventNature}');
  }
  MapEvent.forProvider(
    this.eventLocation,
    this.eventName,
    this.eventHost,
    this.eventAddress,
    this.eventDescription,
    this.startDate,
    this.endDate,
  ) {}
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
