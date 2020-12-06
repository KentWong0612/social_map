import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:date_range_form_field/date_range_form_field.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'CameraPhotoPage.dart';
import 'photoPickPage.dart';

//TODO: reintroduce provider -> uid push
class AddEventPage extends StatefulWidget {
  final LatLng locationIn;
  const AddEventPage(this.locationIn);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadFile(String filePath) async {
    File file = await File(filePath);
    String fileName = await basename(filePath);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('events/${eventNameController.text.trim()}/$fileName');

    UploadTask uploadTask = firebaseStorageRef.putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask.snapshot;
    await taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }

  final FirebaseFirestore storeRef = FirebaseFirestore.instance;
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventAddressController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();

  bool _nameValidate = false;
  bool _addressValidate = false;
  bool _descriptionValidate = false;

  DateTimeRange myDateRange;
  List eventNatureList;
  List eventFormList;
  Map<String, bool> eventNatureListpart = Map();
  Map<String, bool> eventFormListpart = Map();
  Map<String, String> startDate = Map();
  Map<String, String> endDate = Map();

  final formKeyNature = new GlobalKey<FormState>();
  final formKeyForm = new GlobalKey<FormState>();
  final formKeyDate = new GlobalKey<FormState>();

  void _saveToDate() {
    final FormState form = formKeyDate.currentState;
    form.save();
    startDate['startDate'] = Jiffy(myDateRange.start, 'yyyy-MM-dd').format('dd/MM/yyyy');
    endDate['endDate'] = Jiffy(myDateRange.end, 'yyyy-MM-dd').format('dd/MM/yyyy');
    print('startDate: $startDate');
    print('endDate: $endDate');
  }

  //check if not selected,, will save or not?
  void _saveForm() {
    var form = formKeyNature.currentState;
    var formForm = formKeyForm.currentState;
    if (form.validate()) {
      form.save(); // so it save the value as list
    }
    if (formForm.validate()) {
      formForm.save(); // so it save the value as list
    }
  }

  void _saveToNature() {
    eventNatureListpart.clear();
    if (eventNatureList.contains('photo spot')) {
      eventNatureListpart['photo spot'] = true;
    } else {
      eventNatureListpart['photo spot'] = false;
    }
    if (eventNatureList.contains('nightlife')) {
      eventNatureListpart['nightlife'] = true;
    } else {
      eventNatureListpart['nightlife'] = false;
    }
    if (eventNatureList.contains('sports')) {
      eventNatureListpart['sports'] = true;
    } else {
      eventNatureListpart['sports'] = false;
    }
    if (eventNatureList.contains('jetso')) {
      eventNatureListpart['jetso'] = true;
    } else {
      eventNatureListpart['jetso'] = false;
    }
    if (eventNatureList.contains('music')) {
      eventNatureListpart['music'] = true;
    } else {
      eventNatureListpart['music'] = false;
    }
    if (eventNatureList.contains('art')) {
      eventNatureListpart['art'] = true;
    } else {
      eventNatureListpart['art'] = false;
    }
    if (eventNatureList.contains('festival')) {
      eventNatureListpart['festival'] = true;
    } else {
      eventNatureListpart['festival'] = false;
    }
    if (eventNatureList.contains('food&drink')) {
      eventNatureListpart['food&drink'] = true;
    } else {
      eventNatureListpart['food&drink'] = false;
    }
    if (eventNatureList.contains('film&TV')) {
      eventNatureListpart['film&TV'] = true;
    } else {
      eventNatureListpart['film&TV'] = false;
    }
    if (eventNatureList.contains('kid')) {
      eventNatureListpart['kid'] = true;
    } else {
      eventNatureListpart['kid'] = false;
    }
    if (eventNatureList.contains('lohas')) {
      eventNatureListpart['lohas'] = true;
    } else {
      eventNatureListpart['lohas'] = false;
    }
    if (eventNatureList.contains('style')) {
      eventNatureListpart['style'] = true;
    } else {
      eventNatureListpart['style'] = false;
    }
  }

  void _saveToForm() {
    //debugPrint('_saveToForm');
    //print(eventFormListpart);
    eventFormListpart.clear();
    if (eventFormList.contains('show')) {
      eventFormListpart['show'] = true;
    } else {
      eventFormListpart['show'] = false;
    }
    if (eventFormList.contains('carnival')) {
      eventFormListpart['carnival'] = true;
    } else {
      eventFormListpart['carnival'] = false;
    }
    if (eventFormList.contains('exhibition')) {
      eventFormListpart['exhibition'] = true;
    } else {
      eventFormListpart['exhibition'] = false;
    }
    if (eventFormList.contains('sale')) {
      eventFormListpart['sale'] = true;
    } else {
      eventFormListpart['sale'] = false;
    }
    if (eventFormList.contains('trip')) {
      eventFormListpart['trip'] = true;
    } else {
      eventFormListpart['trip'] = false;
    }
    if (eventFormList.contains('race')) {
      eventFormListpart['race'] = true;
    } else {
      eventFormListpart['race'] = false;
    }
    if (eventFormList.contains('party')) {
      eventFormListpart['party'] = true;
    } else {
      eventFormListpart['party'] = false;
    }
    if (eventFormList.contains('experience')) {
      eventFormListpart['experience'] = true;
    } else {
      eventFormListpart['experience'] = false;
    }
    if (eventFormList.contains('workshop')) {
      eventFormListpart['workshop'] = true;
    } else {
      eventFormListpart['workshop'] = false;
    }
    if (eventFormList.contains('class')) {
      eventFormListpart['class'] = true;
    } else {
      eventFormListpart['class'] = false;
    }
    //print(eventFormListpart);
  }

  Future<void> _pushEvent() async {
    Map<String, String> part1 = {
      'eventName': eventNameController.text.trim(),
      'eventAddress': eventAddressController.text.trim(),
      'eventHost': firebaseUser.displayName,
      'eventDescription': eventDescriptionController.text.trim(),
    };
    Map<String, double> part2 = {
      'lattitude': widget.locationIn.latitude,
      'longitude': widget.locationIn.longitude,
    };
    Map<String, Map<String, bool>> part3 = {
      'eventNature': eventNatureListpart,
      'eventForm': eventFormListpart,
    };
    Map<String, String> userID = {
      'uid': firebaseUser.uid,
    };
    DocumentReference pushEventDBFS = storeRef.collection('event').doc();
    await pushEventDBFS.set(part1).whenComplete(() {
      //print('part1 of event please check');
    }).catchError((error) {
      print(error);
    });
    await pushEventDBFS.update(part2).whenComplete(() {
      //print('part2 of event pushed please check');
    }).catchError((error) {
      print(error);
    });
    await pushEventDBFS.update(part3).whenComplete(() {
      //print('part3 of event pushed please check');
    }).catchError((error) {
      print(error);
    });
    await pushEventDBFS.update(userID).whenComplete(() {
      //print('userID of event pushed please check');
    }).catchError((error) {
      print(error);
    });
    await pushEventDBFS.update(startDate).whenComplete(() {}).catchError((error) {
      print(error);
    });
    await pushEventDBFS.update(endDate).whenComplete(() {}).catchError((error) {
      print(error);
    });
    if (listOfPath.isEmpty != true) {
      for (var photoPath in listOfPath) {
        uploadFile(photoPath);
      }
    }

    print('event pushed by ${firebaseUser.uid}');
  }

  @override
  void initState() {
    super.initState();
    eventNatureList = [];
    eventFormList = [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventNameController.dispose();
    eventAddressController.dispose();
    eventDescriptionController.dispose();
  }

  User firebaseUser;
  List<String> listOfPath = [];
  String path_Returned = null;
  _navigateAndTakePhoto(BuildContext context) async {
    // Navigator.push returns a Future that will complete after we call
    // Navigator.pop on the Selection Screen!
    final result = await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => CameraPhotoScreen(listOfPath)),
    );
    setState(() {
      if (result != null) {
        path_Returned = result;
      }
    });
    // After the Selection Screen returns a result, show it in a Snackbar!
  }

  List<Widget> photoScroll() {
    List<Widget> photoList = [];
    if (listOfPath.isEmpty == true) {
      return [
        RichText(
          text: TextSpan(
            text: 'You can add at most 4 photos',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ];
    }
    for (var path in listOfPath) {
      Widget temp = Container(
        child: Stack(
          children: [
            Image.file(File(path)),
            Align(
              alignment: Alignment.topLeft,
              child: FloatingActionButton(
                heroTag: path,
                onPressed: () {
                  setState(() {
                    listOfPath.remove(path);
                  });
                },
                child: Icon(Icons.delete),
              ),
            ),
          ],
        ),
      );
      photoList.add(temp);
    }
    return photoList;
  }

  @override
  Flushbar flush;
  Widget build(BuildContext context) {
    firebaseUser = context.watch<User>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          TextField(
            controller: eventNameController,
            decoration: InputDecoration(
              labelText: 'event name',
              filled: _nameValidate,
              fillColor: Colors.red[100],
              errorText: _nameValidate ? 'Value Can\'t Be Empty' : null,
            ),
          ),
          TextField(
            controller: eventAddressController,
            decoration: InputDecoration(
              filled: _addressValidate,
              fillColor: Colors.red[100],
              labelText: 'event address ',
              errorText: _addressValidate ? 'Value Can\'t Be Empty' : null,
            ),
          ),
          Form(
            key: formKeyNature,
            child: MultiSelectFormField(
                autovalidate: true,
                chipBackGroundColor: Colors.red,
                chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                checkBoxActiveColor: Colors.red,
                checkBoxCheckColor: Colors.green,
                dialogShapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                title: Text(
                  "Event category by nature",
                  style: TextStyle(fontSize: 16),
                ),
                dataSource: [
                  {
                    "display": "photo spot",
                    "value": "photo spot",
                  },
                  {
                    "display": "nightlife",
                    "value": "nightlife",
                  },
                  {
                    "display": "sports",
                    "value": "sports",
                  },
                  {
                    "display": "jetso",
                    "value": "jetso",
                  },
                  {
                    "display": "music",
                    "value": "music",
                  },
                  {
                    "display": "art",
                    "value": "art",
                  },
                  {
                    "display": "festival",
                    "value": "festival",
                  },
                  {
                    "display": "food&drink",
                    "value": "food&drink",
                  },
                  {
                    "display": "film&TV",
                    "value": "film&TV",
                  },
                  {
                    "display": "kid",
                    "value": "kid",
                  },
                  {
                    "display": "lohas",
                    "value": "lohas",
                  },
                  {
                    "display": "style",
                    "value": "style",
                  },
                ],
                textField: 'display',
                valueField: 'value',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                required: true,
                hintWidget: Text('Please choose one or more'),
                onSaved: (value) {
                  setState(() {
                    eventNatureList = value;
                  });
                  //print('eventNatureList is');
                  //print(eventNatureList);
                }),
          ),
          Form(
            key: formKeyForm,
            child: MultiSelectFormField(
                autovalidate: true,
                chipBackGroundColor: Colors.red,
                chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                checkBoxActiveColor: Colors.red,
                checkBoxCheckColor: Colors.green,
                dialogShapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                title: Text(
                  "Event category by form",
                  style: TextStyle(fontSize: 16),
                ),
                dataSource: [
                  {
                    "display": "show",
                    "value": "show",
                  },
                  {
                    "display": "carnival",
                    "value": "carnival",
                  },
                  {
                    "display": "exhibition",
                    "value": "exhibition",
                  },
                  {
                    "display": "sale",
                    "value": "sale",
                  },
                  {
                    "display": "trip",
                    "value": "trip",
                  },
                  {
                    "display": "race",
                    "value": "race",
                  },
                  {
                    "display": "party",
                    "value": "party",
                  },
                  {
                    "display": "experience",
                    "value": "experience",
                  },
                  {
                    "display": "workshop",
                    "value": "workshop",
                  },
                  {
                    "display": "class",
                    "value": "class",
                  },
                ],
                textField: 'display',
                valueField: 'value',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                required: true,
                hintWidget: Text('Please choose one or more'),
                onSaved: (value) {
                  setState(() {
                    eventFormList = value;
                  });
                  //print('eventFormList is');
                  //print(eventFormList);
                }),
          ),
          Form(
            key: formKeyDate,
            child: DateRangeField(
                context: context,
                decoration: InputDecoration(
                  labelText: 'Date Range',
                  prefixIcon: Icon(Icons.date_range),
                  hintText: 'Please select a start and end date',
                  border: OutlineInputBorder(),
                ),
                initialValue: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
                validator: (value) {
                  if (value.start.isBefore(DateTime.now())) {
                    return 'Please enter a valid date';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    myDateRange = value;
                  });
                }),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 100),
            child: SingleChildScrollView(
              child: TextField(
                controller: eventDescriptionController,
                decoration: InputDecoration(
                  labelText: 'event Description',
                  filled: _descriptionValidate,
                  fillColor: Colors.red[100],
                  errorText: _descriptionValidate ? 'Value Can\'t Be Empty' : null,
                ),
                maxLines: null,
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              if ((eventNameController.text.isEmpty != true) && (eventAddressController.text.isEmpty != true) && (eventDescriptionController.text.isEmpty != true)) {
                debugPrint('button clicked');
                _saveToDate();
                _saveForm();
                _saveToNature();
                _saveToForm();
                _pushEvent();
                Navigator.pop(context);
              } else {
                setState(() {
                  eventNameController.text.isEmpty ? _nameValidate = true : _nameValidate = false;
                  eventAddressController.text.isEmpty ? _addressValidate = true : _addressValidate = false;
                  eventDescriptionController.text.isEmpty ? _descriptionValidate = true : _descriptionValidate = false;
                });
              }
            },
            child: Text('Create Event'),
          ),
          RaisedButton(
            onPressed: () async {
              if (listOfPath.length < 4) {
                _navigateAndTakePhoto(context);
              } else {
                flush = Flushbar<bool>(
                    flushbarPosition: FlushbarPosition.TOP,
                    title: 'Sorry',
                    message: 'At most 4 photos',
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ))
                  ..show(context);
              }
            },
            child: Text('Take a Photo for the event'),
          ),
          /*
          RaisedButton(
            onPressed: () async {
              setState(() {});
            },
            child: Text('refresh'),
          ),
          RaisedButton(
            onPressed: () async {
              setState(() {
                listOfPath.clear();
              });
            },
            child: Text('Clear'),
          ),
          RaisedButton(
            onPressed: () {
              uploadFile(listOfPath[0]);
            },
            child: Text('upload try try'),
          ),
          RaisedButton(
            onPressed: () async {
              print('list of path[0] is ${listOfPath}');
            },
            child: Text('print list of path'),
          ),
          */
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: photoScroll(),
            ),
          ),
        ]),
      ),
    );
  }
}
