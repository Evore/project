import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';

import 'next.dart';
import '../models/subjectdata.dart';
import '../models/record.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog({this.subject});
  final SubjectData subject;
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
      color: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: dialogContent(context)),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: null,
      elevation: 6,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            leading: null,
            automaticallyImplyLeading: false,
            title: buildTitle(widget.subject.name)),
        body: ListView(
          shrinkWrap: true, // To make the card compact
          children: <Widget>[getParent(context)],
        ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(Icons.add, size: 15,),
          onPressed: (){},
        ),
      ),
    );
  }

  Text buildTitle(String text) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget getParent(BuildContext context) {
    // String path = "course/" + widget.subject.courseId + "lessons";
    String courseId = widget.subject.courseId;

    // get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("course")
          .where("courseId", isEqualTo: courseId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
              child: new CircularProgressIndicator(),
            );
          default:
            return buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildList(BuildContext context, List<dynamic> snapshot) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 0),
      child: ListView(
        shrinkWrap: true,
        children: snapshot
            .map(
              (data) => getChildNode(data),
            )
            .toList(),
      ),
    );
  }

  Widget getChildNode(DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    if (record.name == null) return Container();
    return buildChild(context, record);
  }

  Widget buildChild(BuildContext context, Record record) {
    DocumentReference ref = record.reference;
    // get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: ref.collection('modules').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
              child: new CircularProgressIndicator(),
            );
          default:
            return buildCList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildCList(BuildContext context, List<dynamic> snapshot) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 0),
      child: ListView(
        shrinkWrap: true,
        children: snapshot
            .map(
              (data) => _buildListItem(context, data),
            )
            .toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final subject = SubjectData.fromSnapShot(data);

    if (subject.name == null) return Container();
    return subjectInfo(context, subject);
  }

  Widget subjectInfo(BuildContext context, SubjectData data) {
    return FlatButton(
      child: Text(data.name),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Item(
                  subject: data,
                ),
          ),
        );
      },
    );
  }
}
