import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/src/ui/entrydialog.dart';
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
  CollectionReference modulesRef;
  String imageUrl = '';
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
        body: getParent(context),
        floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(
            Icons.add,
            size: 15,
          ),
          onPressed: () {
            Navigator.pop(context);
            addModule(context);
          },
        ),
      ),
    );
  }

  void addModule(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EntryDialog(
            module: true,
            ref: modulesRef,
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
    DocumentSnapshot snap = snapshot[0];
    return getChildNode(snap);
  }

  Widget getChildNode(DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    if (record.name == null) return Container();
    return buildChild(context, record);
  }

  Widget buildChild(BuildContext context, Record record) {
    CollectionReference ref = record.reference.collection('modules');
    modulesRef = ref;
    return StreamBuilder<QuerySnapshot>(
      stream: ref.orderBy('position').snapshots(),
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
    return ListView(
      padding: EdgeInsets.only(bottom: 20, top: 0),
      shrinkWrap: true,
      children: snapshot
          .map(
            (data) => _buildListItem(context, data),
          )
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    //the modules
    final subject = SubjectData.fromSnapShot(data);

    if (subject.name == null) return Container();
    return subjectInfo(context, subject);
  }

  Widget subjectInfo(BuildContext context, SubjectData data) {
    if (data.image.isNotEmpty) {
      imageUrl = data.image;
    }
    return Container(
      child: FlatButton(
        child: Column(children: [
          Card(
            shape: CircleBorder(),
            elevation: 6,
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(85, 40, 85, 20),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
          ),
          Text(data.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),)
        ]),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Item(
                    subject: data,
                  ),
            ),
          );
        },
      ),
    );
  }
}
