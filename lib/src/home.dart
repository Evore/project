library home;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(elevation: 3, backgroundColor: Colors.blue.shade600,
      // title: Text('Project Name'),),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: SemesterWidget(),
    );
  }
}
