import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

//event class type to store necessary info
class Event {
  LatLng _eventLocation;
  String _eventName;
  int _eventID;
  String _eventHost;
  List<bool> _eventCatagory;
  // Idea [0] = NightLife, [1] = food
  String _eventDescription;
  int _eventPrice;
  // if 0 =free,, if negative = vary
  List<bool> _targetAgeRange;
  //Idea: [0]=all, [1]=0-10 ...
  //comment?
  //photo?
  //Time Varaible?DartTime

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
    this._eventPrice = _eventPrice;
    this._targetAgeRange = _targetAgeRange;
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;

  //maker
  final LatLng _hospital = const LatLng(22.458576, 113.995721);
  final LatLng _home = const LatLng(22.470100, 113.998738);
  final List<Marker> _allMarkers = [];

  //location tracker
  final Location _locationTracker = Location();
  StreamSubscription _locationSubscription;
  //Circle circle;
  Marker userLocation;

  //camera setting
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(22.470100, 113.998738),
    zoom: 15.0,
  );

  //Testing Event
  Event _tinFaiExplosion;
  Event _tTownExplosion;
  List<Event> _eventList;
  void _eventSetting() {
    List<bool> _alist = [false, true, false, true, true];

    _tinFaiExplosion = Event(
      LatLng(22.464974, 113.996749),
      'tinFaiExplosion',
      1,
      'Ku lo',
      _alist,
      'Tin Fai just boom!!!!!!',
      0,
      _alist,
    );
    _tTownExplosion = Event(
      LatLng(22.462556, 113.999685),
      'tTownExplosion',
      1,
      'Kent',
      _alist,
      'T town just boom!!!!!!',
      0,
      _alist,
    );

    _eventList.add(_tinFaiExplosion);
    _eventList.add(_tTownExplosion);
  }

  Marker createMarkerFromEvent(LatLng location) {
    return Marker(
      markerId: MarkerId('test'),
      draggable: false,
      position: location,
    );
  }

  Marker createMarker(LatLng location) {
    return Marker(
      markerId: MarkerId('test'),
      draggable: false,
      position: location,
    );
  }

  @override
  void initState() {
    super.initState();
    _allMarkers.add(Marker(
      markerId: MarkerId('hospital'),
      draggable: false,
      position: _hospital,
      onTap: () {
        print('hospital tapped');
      },
    ));
    _allMarkers.add(createMarker(_home));
    if (userLocation != null) {
      _allMarkers.add(userLocation);
    }
    _getCurrentLocation();
    _eventSetting();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _moveToHome() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _home, zoom: 15.0)));
  }

  void _updateMarker(LocationData newLocalData) {
    var newLocation = LatLng(newLocalData.latitude, newLocalData.longitude);
    setState(() {
      userLocation = Marker(
        markerId: MarkerId('Your Location'),
        position: newLocation,
        draggable: false,
        zIndex: 2.0,
        flat: true,
      );
    });
    _allMarkers.add(userLocation);
  }

  void _getCurrentLocation() async {
    try {
      var location = await _locationTracker.getLocation();
      _updateMarker(location);

      if (_locationSubscription != null) {
        await _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
/*
        if (mapController != null) {
          mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            zoom: 15.0,
            target: LatLng(newLocalData.latitude, newLocalData.longitude),
          )));
        }
*/
        _updateMarker(newLocalData);
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('PERMISSION_DENIED');
      }
    }
  }

  void _moveToCurrentLocation() {
    //ar location = await _locationTracker.getLocation();
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        zoom: 15.0,
        target: LatLng(
            userLocation.position.latitude, userLocation.position.longitude),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          compassEnabled: true,
          zoomGesturesEnabled: true,
          rotateGesturesEnabled: true,
          initialCameraPosition: initialLocation,
          markers: Set.from(_allMarkers),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () {
            _moveToHome();
          },
          child: Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), color: Colors.blue),
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: FloatingActionButton(
          onPressed: () {
            //_getCurrentLocation();
            _moveToCurrentLocation();
          },
          child: Icon(Icons.my_location),
        ),
      )
    ]);
  }
}
