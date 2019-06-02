library home;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/subjectdata.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'tabs.dart' as l1;
import '../models/record.dart';

class Item extends StatefulWidget {
  Item({this.subject});
  final SubjectData subject;
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool isPortrait;
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey[800], size: 1),
        textTheme: TextTheme(title: TextStyle(color: Colors.grey)),
        centerTitle: true,
        title: Text('Learn'),
        backgroundColor: Colors.white,
        elevation: 10,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    DocumentReference ref = widget.subject.reference;
    // get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: ref.collection("submodules").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
              child: new CircularProgressIndicator(),
            );
          default:
            return _buildItemPage(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildItemPage(
      BuildContext context, List<DocumentSnapshot> snapshots) {
    return snapshots.isEmpty
        ? Center(
            child: Text('Nothing here'),
          )
        : ListView(
            children: snapshots
                .map(
                  (data) => makeBody(context, data),
                )
                .toList(),
          );
  }

  Widget makeBody(BuildContext context, DocumentSnapshot data) {
    Record record = Record.fromSnapshot(data);
    return makeCard(record);
  }
  Widget makeCard(Record record) {
    return Container(
      margin: new EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            blurRadius: 3,
            spreadRadius: 0,
            offset: Offset(0.0, 1),
          )
        ],
      ),
      child: myListTile(record),
    );
  }

  Widget myListTile(Record record) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(3),
      )),
      child: Container(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 65),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              width: 205,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    record.name,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5),
                  // iconBar()
                ],
              ),
            ),
            Container(
              height: 50,
              width: 50,
              child: Image.asset('assets/computer.png'),
            )
          ]),
        ),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => l1.ContentTabs(
                calldata: record,
              ),
            ));
      },
    );
  }

}

