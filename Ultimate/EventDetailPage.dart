import 'dart:ui';
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

  @override
  Widget build(BuildContext context) {
    eventTableDB = context.watch<EventTableFromDBFS>();
    targetEvent = eventTableDB.eventMapFS[eventName];

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(targetEvent.eventName),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Image.asset('assets/thumbnail.jpg'),
              CarouselSlider(
                options: CarouselOptions(height: 400.0),
                items: [1, 2, 3, 4, 5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                        ),
                        child: Image.asset('assets/thumbnail.jpg'),
                      );
                    },
                  );
                }).toList(),
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
            ],
          ),
        ));
  }
}
