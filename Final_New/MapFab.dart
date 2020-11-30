import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'EventDetailPage.dart';
import 'Firebase/MapEventProvider.dart';
import 'addEventPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'MapEvent.dart';

class MapTestScreen extends StatefulWidget {
  @override
  _MapTestScreenState createState() => _MapTestScreenState();
}

class _MapTestScreenState extends State<MapTestScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  GoogleMapController mapController;
  String _mapStyle;
  var firebaseUser;
  //Marker List + User Marker + camera marker
  final List<MapEvent> eventSavedFromDB = [];
  final Map<String, MapEvent> map_eventName = {};
  final List<Marker> _allMarkers = [];
  Marker userLocation;
  Marker screenMarker;
  Marker event;
  MapEvent temp;
  //location tracker
  final Location _locationTracker = Location();
  StreamSubscription _locationSubscription;

  Animation<double> _animation;
  AnimationController _animationController;

  Flushbar flush;

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

  Marker createMarkerForEvent(String markerID, LatLng location) {
    print('icon test: ${eventTableDB.eventMap[markerID].eventNatureTrue[0]}');
    return Marker(
      markerId: MarkerId(markerID),
      draggable: false,
      position: location,
      icon: icon_list[eventTableDB.eventMap[markerID].eventNatureTrue[0]],
      //icon: icon_list['photo spot'],
      onTap: () {
        debugPrint('debug: ' + markerID + ' tapped');
        flush = Flushbar<bool>(
          flushbarPosition: FlushbarPosition.TOP,
          title: markerID,
          message: eventTableDB.eventMap[markerID].eventDescription,
          icon: Icon(
            Icons.info_outline,
            color: Colors.blue,
          ),
          mainButton: FlatButton(
            onPressed: () async {
              await flush.dismiss(true); // result = true
              //TODO: jump to other page
              final navigator = Navigator.of(context);
              await navigator.push(MaterialPageRoute(
                  builder: (context) => DetailScreenPage(markerID)));
            },
            child: Text(
              "More detail",
              style: TextStyle(color: Colors.amber),
            ),
          ),
        ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
          ..show(context);
      },
    );
  }

  BitmapDescriptor currentLocation_Icon,
      home_Icon,
      photo_spot_Icon,
      nightlife_Icon,
      sports_Icon,
      jetso_Icon,
      music_Icon,
      art_Icon,
      festival_Icon,
      food_Icon,
      film_Icon,
      kid_Icon,
      lohas_Icon,
      style_Icon,
      testing_Icon;

  Map<String, BitmapDescriptor> icon_list = Map();
  void _initialIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.1),
            'assets/currentLocation.png')
        .then((d) {
      currentLocation_Icon = d;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.1), 'assets/home.png')
        .then((d) {
      home_Icon = d;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/photo_spot.png')
        .then((d) {
      photo_spot_Icon = d;
      icon_list['photo spot'] = photo_spot_Icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/nighlife.png')
        .then((d) {
      nightlife_Icon = d;
      icon_list['nightlife'] = nightlife_Icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/sports.png')
        .then((d) {
      sports_Icon = d;
      icon_list['sports'] = sports_Icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/sports.png')
        .then((d) {
      jetso_Icon = d;
      icon_list['jetso'] = jetso_Icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/music.png')
        .then((d) {
      music_Icon = d;
      icon_list['music'] = music_Icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/art.png')
        .then((d) {
      art_Icon = d;
      icon_list['art'] = art_Icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/festival.png')
        .then((d) {
      festival_Icon = d;
      icon_list['festival'] = festival_Icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/food.png')
        .then((d) {
      food_Icon = d;
      icon_list['food&drink'] = food_Icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/film.png')
        .then((d) {
      film_Icon = d;
      icon_list['film&TV'] = film_Icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/lohas.png')
        .then((d) {
      kid_Icon = d;
      icon_list['kid'] = kid_Icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/lohas.png')
        .then((d) {
      lohas_Icon = d;
      icon_list['lohas'] = lohas_Icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.5), 'assets/style.png')
        .then((d) {
      style_Icon = d;
      icon_list['style'] = style_Icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 1.5),
            'assets/TestingMapPin.png')
        .then((d) {
      testing_Icon = d;
      icon_list['testing'] = testing_Icon;
    });
  }

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
    //add marker into marker list
    if (userLocation != null) {
      _allMarkers.add(userLocation);
    }
    _initialIcon();
    _getCurrentLocation();
    _getScreenLocation();
    _loadDataFromSharedPreference();
    _moveToCurrentLocation();

    //delayed loaded of event
    const tensecond = const Duration(seconds: 10);
    new Timer(tensecond, () => _addEventToMarkerAndList());

    //refresh per 15min
    const min_15 = const Duration(seconds: 15 * 60);
    new Timer.periodic(min_15, (Timer t) {
      _addEventToMarkerAndList();
    });
  }

  @override
  bool get wantKeepAlive => true;
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
      //home = createMarkerFromLatLng('home', LatLng(tempLat, tempLong));
      home = Marker(
        markerId: MarkerId('home'),
        draggable: false,
        position: LatLng(tempLat, tempLong),
        icon: home_Icon,
        onTap: () {
          debugPrint('debug: home tapped');
        },
      );
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
    await _loadDataFromSharedPreference();
    debugPrint(
        'debug: saved new location to device' + screen_location.toString());
  }

  //move the camera to saved location
  void _moveToSavedLocation() async {
    await _loadDataFromSharedPreference();
    debugPrint('debug: moved to ' + home.position.toString());
    await mapController.animateCamera(CameraUpdate.newCameraPosition(
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
        print('dargged to $newPosition');
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
    if (mounted)
      setState(() {
        mapController = controller;
        controller.setMapStyle(_mapStyle);
      });
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
        icon: currentLocation_Icon,
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
  void _addEventToMarkerAndList() async {
    print('data printing check ${eventTableDB.testinglist.length}');
    for (var element in eventTableDB.testinglist) {
      //print( 'event name = ${element['eventName']} , event position = ${element['lattitude']}, ${element['longitude']}');
      temp = MapEvent(
          LatLng(double.tryParse(element['lattitude'].toString()),
              double.tryParse(element['longitude'].toString())),
          element['eventName'],
          element['eventHost'],
          element['eventAddress'],
          element['eventDescription'],
          element['startDate'],
          element['EndDate'],
          element['eventNature'],
          element['eventForm']);
      await eventSavedFromDB.add(temp);
      setState(() {
        event = createMarkerForEvent(
            element['eventName'],
            LatLng(double.tryParse(element['lattitude'].toString()),
                double.tryParse(element['longitude'].toString())));
      });
      await _allMarkers.add(event);
    }
  }

  void _restartMarker() {
    eventSavedFromDB.clear();
    _allMarkers.clear();
    _allMarkers.add(userLocation);
    _allMarkers.add(home);
    print('restart triggered');
    _addEventToMarkerAndList();
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
      return Consumer<EventTableFromDB>(
        builder: (context, eventTableDB, child) => Stack(children: [
          Scaffold(
            body: GoogleMap(
              onMapCreated: _onMapCreated,
              compassEnabled: true,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              initialCameraPosition: initialLocation,
              markers: Set.from(_allMarkers),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,

            //Init Floating Action Bubble
            floatingActionButton: FloatingActionBubble(
              // Menu items
              items: <Bubble>[
                //Floating action menu item
                Bubble(
                  title: "Refresh",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.refresh,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    _restartMarker();
                    _animationController.reverse();
                  },
                ),
                Bubble(
                  title: "Place Map Pin",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.pin_drop,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    _placeScreenMarker();
                    _animationController.reverse();
                  },
                ),
                Bubble(
                  title: "Save Map Pin as Home",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.save,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    _saveDataToSharedPreference();
                    _animationController.reverse();
                  },
                ),
              ],

              // animation controller
              animation: _animation,

              // On pressed change animation state
              onPress: () => _animationController.isCompleted
                  ? _animationController.reverse()
                  : _animationController.forward(),

              // Floating Action button Icon color
              iconColor: Colors.blue,

              // Flaoting Action button Icon
              iconData: Icons.ac_unit,
              backGroundColor: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              heroTag: 'Home button',
              onPressed: () {
                _moveToSavedLocation();
              },
              child: Icon(Icons.home),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              heroTag: 'move button visitor',
              onPressed: () {
                _moveToCurrentLocation();
              },
              child: Icon(Icons.my_location),
            ),
          ),
        ]),
      );
    } else {
      return Consumer<EventTableFromDB>(
        builder: (context, eventTableDB, child) => Stack(children: [
          Scaffold(
              body: GoogleMap(
                onMapCreated: _onMapCreated,
                compassEnabled: true,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                rotateGesturesEnabled: true,
                initialCameraPosition: initialLocation,
                markers: Set.from(_allMarkers),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endDocked,

              //Init Floating Action Bubble
              floatingActionButton: FloatingActionBubble(
                // Menu items
                items: <Bubble>[
                  //Floating action menu item
                  Bubble(
                    title: "Refresh",
                    iconColor: Colors.white,
                    bubbleColor: Colors.blue,
                    icon: Icons.refresh,
                    titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                    onPress: () {
                      _restartMarker();
                      _animationController.reverse();
                    },
                  ),
                  Bubble(
                    title: "Place Map Pin",
                    iconColor: Colors.white,
                    bubbleColor: Colors.blue,
                    icon: Icons.pin_drop,
                    titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                    onPress: () {
                      _placeScreenMarker();
                      _animationController.reverse();
                    },
                  ),
                  Bubble(
                    title: "Add Event At Map Pin",
                    iconColor: Colors.white,
                    bubbleColor: Colors.blue,
                    icon: Icons.add,
                    titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                    onPress: () {
                      debugPrint('add Event');
                      _addEvent(context);
                      _animationController.reverse();
                    },
                  ),
                  Bubble(
                    title: "Save Map Pin as Home",
                    iconColor: Colors.white,
                    bubbleColor: Colors.blue,
                    icon: Icons.save,
                    titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                    onPress: () {
                      _saveDataToSharedPreference();
                      _animationController.reverse();
                    },
                  ),
                ],

                // animation controller
                animation: _animation,

                // On pressed change animation state
                onPress: () => _animationController.isCompleted
                    ? _animationController.reverse()
                    : _animationController.forward(),

                // Floating Action button Icon color
                iconColor: Colors.blue,

                // Flaoting Action button Icon
                iconData: Icons.ac_unit,
                backGroundColor: Colors.white,
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              heroTag: 'Home button',
              onPressed: () {
                _moveToSavedLocation();
              },
              child: Icon(Icons.home),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              heroTag: 'move button visitor',
              onPressed: () {
                _moveToCurrentLocation();
              },
              child: Icon(Icons.my_location),
            ),
          ),
        ]),
      );
    }
  }
}
