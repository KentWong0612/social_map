import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'Event.dart';
import 'package:shared_preferences/shared_preferences.dart';

//target 1: implement setHome function

class MapTestScreen extends StatefulWidget {
  @override
  _MapTestScreenState createState() => _MapTestScreenState();
}

class _MapTestScreenState extends State<MapTestScreen> {
  GoogleMapController mapController;

  //Marker List
  final List<Marker> _allMarkers = [];

  //User Marker
  Marker userLocation;

  //Test Marker and sharedpref
  SharedPreferences prefs;
  Marker _testerMarker;
  final String prefLat = "prefLat";
  final String prefLong = "prefLong";

  //preset marker
  final LatLng _hospital = const LatLng(22.458576, 113.995721);
  final LatLng _home = const LatLng(22.470100, 113.998738);

  //location tracker
  final Location _locationTracker = Location();
  StreamSubscription _locationSubscription;

  //camera setting: cant not access user location here
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(22.448503, 114.004891),
    zoom: 15.0,
  );

  //Return marker with Latlng for event(not completed)
  Marker createMarkerFromLatLng(LatLng location) {
    return Marker(
      markerId: MarkerId('test'),
      draggable: false,
      position: location,
    );
  }

  //pre-set marker added to marker list
  @override
  void initState() {
    super.initState();
    //add marker into marker list
    _allMarkers.add(Marker(
      markerId: MarkerId('hospital'),
      draggable: false,
      position: _hospital,
      onTap: () {
        print('hospital tapped');
      },
    ));
    _allMarkers.add(createMarkerFromLatLng(_home));
    if (userLocation != null) {
      _allMarkers.add(userLocation);
    }

    _getCurrentLocation();
    _loadDataFromSharedPreference();
  }

  //testing section for sharedPreference
  _loadDataFromSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      double tempLat = (prefs.getDouble(prefLat) ?? 22.447901);
      double tempLong = (prefs.getDouble(prefLong) ?? 114.025432);
      _testerMarker = createMarkerFromLatLng(LatLng(tempLat, tempLong));
    });
  }

  _saveDataFromSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setDouble(prefLat, 22.468406);
    prefs.setDouble(prefLong, 114.000176);
  }

  //move the camera to target
  void _moveToTarget() {
    _loadDataFromSharedPreference();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _testerMarker.position, zoom: 15.0)));
  }
  //section end

  //set map controller
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _moveToCurrentLocation();
  }

  //move the camera to home
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
        _updateMarker(newLocalData);
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('PERMISSION_DENIED');
      }
    }
  }

  void _moveToCurrentLocation() {
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
            //_moveToTarget();
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
            _moveToCurrentLocation();
          },
          child: Icon(Icons.my_location),
        ),
      ),
      //testing function button section
      Align(
        alignment: Alignment.topLeft,
        child: FloatingActionButton(
          onPressed: () {
            _moveToTarget();
          },
          child: Icon(Icons.restaurant),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: FloatingActionButton(
          onPressed: () {
            _saveDataFromSharedPreference();
          },
          child: Icon(Icons.save),
        ),
      ),
      //testing function button section end
    ]);
  }
}
