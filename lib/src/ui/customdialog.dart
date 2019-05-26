import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'next.dart';
import '../data/subjectdata.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog({this.subject});
  final SubjectData subject;
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      color: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          buildTitle(),
          getParent(context),
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: FlatButton(
          //     onPressed: () {
          //       Navigator.of(context).pop(); // To close the dialog
          //     },
          //     child: Text("buttonText"),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    //TODO check overflow
    String trunc(String text) {
      if (text.length > 32) {
        text = text.substring(0, 30) + '...';
      }
      return text;
    }

    return Container(
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
          color: Colors.blue[400],
          boxShadow: [
            BoxShadow(
                color: Color(0x33000000),
                blurRadius: 0.0,
                spreadRadius: 0.0,
                offset: Offset(0, 1)),
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
      child: Row(
        children: <Widget>[
          Text(
            trunc(widget.subject.name),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ));
  }

  Widget getParent(BuildContext context) {
    // String path = "course/" + widget.subject.courseId + "lessons";
    String course_id = widget.subject.courseId;

    // get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("course")
          .where("courseId", isEqualTo: course_id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildList(BuildContext context, List<dynamic> snapshot) {
    bool isPortrait;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      isPortrait = false;
    } else
      isPortrait = true;

    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 0),
      child: ListView(
        shrinkWrap: true,
        children:
            snapshot.map((data) => getChildNode(data)).toList(),
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
      stream: ref.collection('lessons').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return buildCList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildCList(BuildContext context, List<dynamic> snapshot) {
    bool isPortrait;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      isPortrait = false;
    } else
      isPortrait = true;

    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 0),
      child: ListView(  
        shrinkWrap: true,
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList(),
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
                      subject: widget.subject,
                    )));
      },
    );
  }
}
