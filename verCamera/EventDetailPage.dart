import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Firebase/MapEventProviderFS.dart';
import 'MapEvent.dart';

class DetailScreenPage extends StatelessWidget {
  DetailScreenPage(this.eventName);
  String eventName;
  EventTableFromDBFS eventTableDB;
  MapEvent targetEvent;
  ListResult eventID_Dir_Ref;

  void printsth() {
    print('download: eventID_Dir_Ref $eventID_Dir_Ref');
  }

  List<Image> downloaded_Photo = [];

  Future<void> downloadURL(String eventName) async {
    downloaded_Photo.clear();
    print('download: begin');

    eventID_Dir_Ref = await FirebaseStorage.instance.ref('events/$eventName').listAll();

    if (eventID_Dir_Ref.items.isEmpty != true) {
      print('download: photo found!');
      for (Reference photo_ref in eventID_Dir_Ref.items) {
        print('download Found file: $photo_ref');
        String downloadURL = await FirebaseStorage.instance.ref(photo_ref.fullPath).getDownloadURL();
        downloaded_Photo.add(Image.network(downloadURL));
      }
    } else {
      //downloaded_Photo = example_list;
      downloaded_Photo.add(Image.asset('assets/No_photo.png'));
    }
    //problem here

    //String hardcodeURL = await FirebaseStorage.instance.ref('events/Hospital/2020-12-02 05:51:38.942661.png').getDownloadURL();
    //print("download: hardcode is $hardcodeURL");
  }

  List<Widget> _buildLabel(List<String> list_in) {
    List<Widget> toBeReturned = [];
    for (var element in list_in) {
      toBeReturned.add(Padding(
        padding: const EdgeInsets.only(right: 3.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.grey[200],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: RichText(
              text: TextSpan(
                text: '$element',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ),
        ),
      ));
    }
    return toBeReturned;
  }

  List<Image> example_list = [
    Image.asset('assets/thumbnail.jpg'),
    Image.asset('assets/thumbnail (1).jpg'),
    Image.asset('assets/thumbnail (2).jpg'),
    Image.asset('assets/thumbnail (3).jpg'),
    Image.asset('assets/thumbnail (4).jpg'),
    Image.asset('assets/thumbnail (5).jpg'),
  ];

  Future<void> deleteEvent() async {
    var firestore = FirebaseFirestore.instance;
    var target_collection = await firestore.collection('event').where('eventName', isEqualTo: targetEvent.eventName).get();
    var file_path = target_collection.docChanges[0].doc.reference.path;
    print('tell me what it is $file_path');

    await firestore.doc(file_path).delete();
    print('tell me delete complete');
  }

  User firebaseUser;
  @override
  Widget build(BuildContext context) {
    firebaseUser = context.watch<User>();
    eventTableDB = context.watch<EventTableFromDBFS>();
    targetEvent = eventTableDB.eventMapFS[eventName];
    downloadURL(eventName);
    if (firebaseUser.uid == 'd83goWBSD4dT8n7KdUNWLPEfdJp1') {
      print('Download: you are admin');
      return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(targetEvent.eventName),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: downloadURL(targetEvent.eventName),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // 请求已结束
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        // 请求失败，显示错误
                        return Image.asset('assets/bad_connection.png');
                      } else {
                        // 请求成功，显示数据
                        return Stack(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 400.0,
                                enlargeCenterPage: true,
                              ),
                              items: [1, 2, 3, 4, 5].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: downloaded_Photo[i % downloaded_Photo.length],
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: 50,
                                child: Image.asset('assets/left_arrow.png'),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 50,
                                child: Image.asset('assets/right_arrow.png'),
                              ),
                            ),
                          ],
                        );
                      }
                    } else {
                      // 请求未结束，显示loading
                      return CircularProgressIndicator();
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.blue[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                        child: Text(
                          targetEvent.eventName,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
                        child: RichText(
                          text: TextSpan(
                            text: 'Hosted by: ${targetEvent.eventHost}',
                            style: TextStyle(fontSize: 20, color: Colors.black54, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.blue[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Address:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: RichText(
                          text: TextSpan(
                            text: '- Location: ${targetEvent.eventAddress}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Date:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: RichText(
                          text: TextSpan(
                            text: '- Starting Date: ${targetEvent.startDate}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 5,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: '- Ending Date: ${targetEvent.endDate}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          "What it's about?",
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
                        child: RichText(
                          text: TextSpan(
                            text: targetEvent.eventDescription,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.blue[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Category by nature:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                          child: Row(
                            children: _buildLabel(targetEvent.eventNatureTrue),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Category by form:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
                        child: Row(
                          children: _buildLabel(targetEvent.eventFormTrue),
                        ),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    deleteEvent();
                    Navigator.pop(context);
                  },
                  child: Text('delete event'),
                ),
              ],
            ),
          ));
    }
    if (firebaseUser.uid == targetEvent.uid) {
      print('Download: you are host');
      return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(targetEvent.eventName),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: downloadURL(targetEvent.eventName),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // 请求已结束
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        // 请求失败，显示错误
                        return Image.asset('assets/bad_connection.png');
                      } else {
                        // 请求成功，显示数据
                        return Stack(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 400.0,
                                enlargeCenterPage: true,
                              ),
                              items: [1, 2, 3, 4, 5].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: downloaded_Photo[i % downloaded_Photo.length],
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: 50,
                                child: Image.asset('assets/left_arrow.png'),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 50,
                                child: Image.asset('assets/right_arrow.png'),
                              ),
                            ),
                          ],
                        );
                      }
                    } else {
                      // 请求未结束，显示loading
                      return CircularProgressIndicator();
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.blue[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                        child: Text(
                          targetEvent.eventName,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
                        child: RichText(
                          text: TextSpan(
                            text: 'Hosted by: ${targetEvent.eventHost}',
                            style: TextStyle(fontSize: 20, color: Colors.black54, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.blue[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Address:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: RichText(
                          text: TextSpan(
                            text: '- Location: ${targetEvent.eventAddress}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Date:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: RichText(
                          text: TextSpan(
                            text: '- Starting Date: ${targetEvent.startDate}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 5,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: '- Ending Date: ${targetEvent.endDate}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          "What it's about?",
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
                        child: RichText(
                          text: TextSpan(
                            text: targetEvent.eventDescription,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.blue[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Category by nature:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                          child: Row(
                            children: _buildLabel(targetEvent.eventNatureTrue),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Category by form:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
                        child: Row(
                          children: _buildLabel(targetEvent.eventFormTrue),
                        ),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    deleteEvent();
                    Navigator.pop(context);
                  },
                  child: Text('delete event'),
                ),
              ],
            ),
          ));
    } else {
      print('Download: you are not host ${firebaseUser.uid} VS ${targetEvent.uid}');
      return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(targetEvent.eventName),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: downloadURL(targetEvent.eventName),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // 请求已结束
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        // 请求失败，显示错误
                        return Image.asset('assets/bad_connection.png');
                      } else {
                        // 请求成功，显示数据
                        return Stack(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 400.0,
                                enlargeCenterPage: true,
                              ),
                              items: [1, 2, 3, 4, 5].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: downloaded_Photo[i % downloaded_Photo.length],
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: 50,
                                child: Image.asset('assets/left_arrow.png'),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 50,
                                child: Image.asset('assets/right_arrow.png'),
                              ),
                            ),
                          ],
                        );
                      }
                    } else {
                      // 请求未结束，显示loading
                      return CircularProgressIndicator();
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.blue[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                        child: Text(
                          targetEvent.eventName,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
                        child: RichText(
                          text: TextSpan(
                            text: 'Hosted by: ${targetEvent.eventHost}',
                            style: TextStyle(fontSize: 20, color: Colors.black54, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.blue[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Address:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: RichText(
                          text: TextSpan(
                            text: '- Location: ${targetEvent.eventAddress}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Date:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: RichText(
                          text: TextSpan(
                            text: '- Starting Date: ${targetEvent.startDate}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 5,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: '- Ending Date: ${targetEvent.endDate}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          "What it's about?",
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
                        child: RichText(
                          text: TextSpan(
                            text: targetEvent.eventDescription,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    color: Colors.blue[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Category by nature:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                          child: Row(
                            children: _buildLabel(targetEvent.eventNatureTrue),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          top: 10,
                        ),
                        child: Text(
                          'Category by form:',
                          style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
                        child: Row(
                          children: _buildLabel(targetEvent.eventFormTrue),
                        ),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    printsth();
                  },
                  child: Text('refresh'),
                ),
              ],
            ),
          ));
    }
  }
}
