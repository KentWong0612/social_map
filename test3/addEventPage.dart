import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class AddEventPage extends StatefulWidget {
  final LatLng locationIn;
  const AddEventPage(this.locationIn);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final DatabaseReference firebaseDB = FirebaseDatabase.instance.reference();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventAddressController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();

  List eventNatureList;
  List eventFormList;
  Map<String, bool> eventNatureListpart = Map();
  Map<String, bool> eventFormListpart = Map();
  final formKeyNature = new GlobalKey<FormState>();
  final formKeyForm = new GlobalKey<FormState>();

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
    //debugPrint('_saveToNature');
    //print(eventNatureListpart);
    eventNatureListpart.clear();
    if (eventNatureList.contains('photo spot')) {
      eventNatureListpart['photo spot'] = true;
    } else {
      eventNatureListpart['photo spot'] = false;
    }
    if (eventNatureList.contains('nightlife')) {
      eventNatureListpart['nighlife'] = true;
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
    //print(eventNatureListpart);
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

  void _pushEvent() {
    Map<String, String> part1 = {
      'eventName': eventNameController.text.trim(),
      'eventAddress': eventAddressController.text.trim(),
      'eventHost': 'Ku',
      'eventDescription': eventDescriptionController.text.trim(),
    };
    //TODO: pass location in
    Map<String, double> part2 = {
      'lattitude': widget.locationIn.latitude,
      'longitude': widget.locationIn.longitude,
    };
    Map<String, Map<String, bool>> part3 = {
      'eventNature': eventNatureListpart,
      'eventForm': eventFormListpart,
    };
    DatabaseReference pushEventDB = firebaseDB.child('event').push();
    debugPrint('checking before pushing');
    print(part1);
    print(part2);
    print(part3);
    pushEventDB.set(part1).whenComplete(() {
      print('part1 of event please check');
    }).catchError((error) {
      print(error);
    });
    pushEventDB.update(part2).whenComplete(() {
      print('part2 of event pushed please check');
    }).catchError((error) {
      print(error);
    });
    pushEventDB.update(part3).whenComplete(() {
      print('part3 of event pushed please check');
    }).catchError((error) {
      print(error);
    });
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

  @override
  Widget build(BuildContext context) {
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
            ),
          ),
          TextField(
            controller: eventAddressController,
            decoration: InputDecoration(
              labelText: 'event address ',
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
                dialogShapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
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
                  print('eventNatureList is');
                  print(eventNatureList);
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
                dialogShapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
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
                  print('eventFormList is');
                  print(eventFormList);
                }),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 100),
            child: SingleChildScrollView(
              child: TextField(
                controller: eventDescriptionController,
                decoration: InputDecoration(
                  labelText: 'event Description',
                ),
                maxLines: null,
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              debugPrint('button clicked');
              _saveForm();
              _saveToNature();
              _saveToForm();
              _pushEvent();
              Navigator.pop(context);
            },
            child: Text('Create Event'),
          ),
        ]),
      ),
    );
  }
}
