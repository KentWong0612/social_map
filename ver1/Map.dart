import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'Firebase/MapEventProvider.dart';
import 'addEventPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapTestScreen extends StatefulWidget {
  @override
  _MapTestScreenState createState() => _MapTestScreenState();
}

class _MapTestScreenState extends State<MapTestScreen> {
  GoogleMapController mapController;
  var firebaseUser;
  //Marker List + User Marker + camera marker
  final List<Marker> _allMarkers = [];
  Marker userLocation;
  Marker screenMarker;
  Marker event;
  //location tracker
  final Location _locationTracker = Location();
  StreamSubscription _locationSubscription;

  //camera setting: cant not access user location here
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(22.448503, 114.004891),
    zoom: 15.0,
  );

  //Return marker with Latlng for event(not completed)
  Marker createMarkerFromLatLng(String markerID, LatLng location) {
    return Marker(
      markerId: MarkerId(markerID),
      draggable: false,
      position: location,
      onTap: () {
        debugPrint('debug: ' + markerID + ' tapped');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //add marker into marker list

    if (userLocation != null) {
      _allMarkers.add(userLocation);
    }
    inserttestingmarker();
    _getCurrentLocation();
    _getScreenLocation();
    _loadDataFromSharedPreference();
  }

  //////////////////////////////////Section for testing marker//////////////////////////////////
  //preset marker for testing purpose
  final LatLng _hospital = const LatLng(22.458576, 113.995721);
  final LatLng _kentHome = const LatLng(22.470100, 113.998738);

  //insert testingMarker to marker list
  void inserttestingmarker() {
    _allMarkers.add(createMarkerFromLatLng('hospital', _hospital));
    _allMarkers.add(createMarkerFromLatLng('kent home', _kentHome));
  }

  //////////////////////////////////section end//////////////////////////////////

  //sharedpref for saving home position
  SharedPreferences prefs;
  Marker home;
  final String prefLat = 'prefLat';
  final String prefLong = 'prefLong';

  //load home position from device
  void _loadDataFromSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      var tempLat = (prefs.getDouble(prefLat) ?? 22.447901);
      var tempLong = (prefs.getDouble(prefLong) ?? 114.025432);
      home = createMarkerFromLatLng('home', LatLng(tempLat, tempLong));
    });
    debugPrint('debug: saved home location ' + home.position.toString());
    _allMarkers.add(home);
  }

  //save Current camera position as home position
  void _saveDataToSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
    final screen_location = await _getScreenLocation();
    await prefs.setDouble(prefLat, screen_location.latitude);
    await prefs.setDouble(prefLong, screen_location.longitude);
    debugPrint(
        'debug: saved new location to device' + screen_location.toString());
  }

  //move the camera to saved location
  void _moveToSavedLocation() async {
    await _loadDataFromSharedPreference();
    debugPrint('debug: ' + 'moved to ' + home.position.toString());
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: home.position, zoom: 15.0)));
  }

  //function to obtain camera position
  Future<LatLng> _getScreenLocation() async {
    return screenMarker.position;
  }

  //function to place ScreenMarker
  void _placeScreenMarker() async {
    var screenWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var screenHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;

    var middleX = screenWidth / 2;
    var middleY = screenHeight / 2;

    var screenCoordinate =
        ScreenCoordinate(x: middleX.round(), y: middleY.round());

    var middlePoint = await mapController.getLatLng(screenCoordinate);
    debugPrint('debug: place screenMarker at ' + middlePoint.toString());
    screenMarker = Marker(
      markerId: MarkerId('ScreenCenterMarker'),
      draggable: true,
      onDragEnd: ((newPosition) {
        print('dargged to ${newPosition}');
        print('original position is ${screenMarker.position}');
        screenMarker =
            createMarkerFromLatLng('ScreenCenterMarker', newPosition);
      }),
      position: middlePoint,
      onTap: () {
        debugPrint('debug: ScreenCenterMarker tapped');
      },
    );
    _allMarkers.add(screenMarker);
  }

  //set map controller
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _moveToCurrentLocation();
  }

  //function to update user location
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

  //function to obtain user location
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

  //function to move to user location
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
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    debugPrint('map dispose called');
    super.dispose();
  }

  EventTableFromDB eventTableDB;
  void _addEventToMarker() {
    print('data printing check ${eventTableDB.testinglist.length}');
    for (var element in eventTableDB.testinglist) {
      print(
          'event name = ${element['eventName']} , event position = ${element['lattitude']}, ${element['longitude']}');

      setState(() {
        event = createMarkerFromLatLng(
            element['eventName'],
            LatLng(double.tryParse(element['lattitude'].toString()),
                double.tryParse(element['longitude'].toString())));
      });
      _allMarkers.add(event);
    }
  }

  void _restartMarker() {
    _allMarkers.clear();
    _allMarkers.add(userLocation);
    _addEventToMarker();
  }

//TODO: test with fixed value first
  Future<void> _addEvent(BuildContext context) async {
    if (screenMarker != null) {
      //print('Push screen Marker Position to Navigator: ${screenMarker.position}');
      final navigator = Navigator.of(context);
      await navigator.push(MaterialPageRoute(
          builder: (context) => AddEventPage(screenMarker.position)));
    } else {
      print('place the screeen marker first');
    }
  }

  @override
  Widget build(BuildContext context) {
    firebaseUser = context.watch<User>();
    eventTableDB = context.watch<EventTableFromDB>();

    if (firebaseUser == null) {
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
              //_moveToHome();
              _moveToSavedLocation();
            },
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue),
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
            heroTag: 'move button visitor',
            onPressed: () {
              _moveToCurrentLocation();
              _addEventToMarker();
            },
            child: Icon(Icons.my_location),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: FloatingActionButton(
            heroTag: 'place button visitor',
            onPressed: () {
              _placeScreenMarker();
            },
            child: Icon(Icons.center_focus_strong),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            heroTag: 'save button visitor',
            onPressed: () {
              _saveDataToSharedPreference();
            },
            child: Icon(Icons.save),
          ),
        ),
        //testing function button section end
      ]);
    } else {
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
              _moveToSavedLocation();
            },
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue),
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
            heroTag: 'move button',
            onPressed: () {
              _moveToCurrentLocation();
              _addEventToMarker();
            },
            child: Icon(Icons.my_location),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: FloatingActionButton(
            heroTag: 'palce button',
            onPressed: () {
              _placeScreenMarker();
            },
            child: Icon(Icons.center_focus_strong),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: FloatingActionButton(
            heroTag: 'add button',
            onPressed: () {
              debugPrint('add Event');
              _addEvent(context);
            },
            child: Icon(Icons.add),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            heroTag: 'save button',
            onPressed: () {
              _saveDataToSharedPreference();
            },
            child: Icon(Icons.save),
          ),
        ),
        //testing function button section end
      ]);
    }
  }
}
