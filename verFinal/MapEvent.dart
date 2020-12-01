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
  List<String> eventNatureTrue = [];
  List<String> eventFormTrue = [];
  /*
    Other possible parameter:
      int _eventPrice;                // if 0 =free,, if negative = vary
      comment?
      photo?
      Time Varaible?DartTime
  */
  void _saveToTrueForm() {
    if (eventForm['show'] == true) {
      eventFormTrue.add('show');
    }
    if (eventForm['carnival'] == true) {
      eventFormTrue.add('carnival');
    }
    if (eventForm['exhibition'] == true) {
      eventFormTrue.add('exhibition');
    }
    if (eventForm['sale'] == true) {
      eventFormTrue.add('sale');
    }
    if (eventForm['trip'] == true) {
      eventFormTrue.add('trip');
    }
    if (eventForm['race'] == true) {
      eventFormTrue.add('race');
    }
    if (eventForm['party'] == true) {
      eventFormTrue.add('party');
    }
    if (eventForm['experience'] == true) {
      eventFormTrue.add('experience');
    }
    if (eventForm['workshop'] == true) {
      eventFormTrue.add('workshop');
    }
    if (eventForm['class'] == true) {
      eventFormTrue.add('class');
    }
  }

  void _saveToTrueNature() {
    if (eventNature['photo spot'] == true) {
      eventNatureTrue.add('photo spot');
    }
    if (eventNature['nightlife'] == true) {
      eventNatureTrue.add('nighlife');
    }
    if (eventNature['sports'] == true) {
      eventNatureTrue.add('sports');
    }
    if (eventNature['jetso'] == true) {
      eventNatureTrue.add('jetso');
    }
    if (eventNature['music'] == true) {
      eventNatureTrue.add('music');
    }
    if (eventNature['art'] == true) {
      eventNatureTrue.add('art');
    }
    if (eventNature['festival'] == true) {
      eventNatureTrue.add('festival');
    }
    if (eventNature['food&drink'] == true) {
      eventNatureTrue.add('food&drink');
    }
    if (eventNature['film&TV'] == true) {
      eventNatureTrue.add('film&TV');
    }
    if (eventNature['kid'] == true) {
      eventNatureTrue.add('kid');
    }
    if (eventNature['lohas'] == true) {
      eventNatureTrue.add('lohas');
    }
    if (eventNature['style'] == true) {
      eventNatureTrue.add('style');
    }
  }

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
    if (eventNature != null) {
      _saveToTrueNature();
    }
    if (eventForm != null) {
      _saveToTrueForm();
    }
    print(
        'MapEvent Class Test: $eventName is $eventNatureTrue and $eventFormTrue');
  }
}
