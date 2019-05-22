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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 470,
      ),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            buildTitle(),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 365),
              child: buildBody(context),
            ),
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
      ),
    );
  }

  Widget buildTitle() {
    //TODO check overflow
    String trunc(String text) {
      if (text.length > 29) {
        text = text.substring(0, 27) + '...';
      }
      return text;
    }

    return Container(
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.blue[400],
        boxShadow: [
          BoxShadow(color: Color(0x33000000), blurRadius: 0.0, spreadRadius: 0.0, offset: Offset(0, 1)),
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
      )
    );
  }

  Widget buildBody(BuildContext context) {
    DocumentReference ref = widget.subject.reference;
    // get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("courses/BIT/level/semester-one/courses")
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
            context, MaterialPageRoute(builder: (context) => Item(
              subject: widget.subject,
            )));
      },
    );
  }
}
