library home;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/src/ui/logout.dart';
import 'package:project/src/ui/utils/custompopupwidget.dart';
import 'ui/homewidgets.dart';

double pHeight, lHeight;
bool isPortrait;

void main() async {
  //With this change, timestamps stored in Cloud Firestore will be read back as com.google.firebase.Timestamp objects
  //instead of as system java.util.Date objects. ou will also need to update code expecting a java.util.Date to instead expect a Timestamp.
  //Please audit all existing usages of java.util.Date when you enable the new behavior.
  //In a future release, the behavior will be changed to the new behavior, so if you do not follow these steps, YOUR APP MAY BREAK.
  final Firestore firestore = Firestore.instance;
  FirebaseDatabase database;
  database = FirebaseDatabase.instance;
  database.setPersistenceEnabled(true);
  await firestore.settings(timestampsInSnapshotsEnabled: true);

  runApp(Home());
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CustomPopupMenu _selectedChoice;

  List<CustomPopupMenu> choices = <CustomPopupMenu>[
    CustomPopupMenu(title: 'Logout', icon: Icons.person),
  ];

  void _select(CustomPopupMenu choice) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LogoutPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade500, Colors.red.shade300],
          stops: [0.1, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('Project Name'),
          actions: <Widget>[
            PopupMenuButton<CustomPopupMenu>(
              icon: Icon(Icons.menu),
              elevation: 4,
              // initialValue: choices[0],
              tooltip: 'Menu',
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((CustomPopupMenu choice) {
                  return PopupMenuItem<CustomPopupMenu>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: SemesterWidget(),
    );
  }
}
