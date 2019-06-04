library forum;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project/src/models/forumdata.dart';
import 'package:project/src/ui/reply.dart';
import '../models/record.dart';

class Forum extends StatefulWidget {
  Forum({this.ref});
  final DocumentReference ref;
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  bool isPortrait;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
          child: Stack(
        children: <Widget>[
          _buildBody(context),
        ],
      )),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.ref.collection("forum").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return _buildForumPage(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildForumPage(
      BuildContext context, List<DocumentSnapshot> snapshots) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: ListView(
        children: snapshots.map((data) => message(context, data)).toList(),
      ),
    );
  }

  Widget message(BuildContext context, DocumentSnapshot data) {
    ForumData item = ForumData.fromSnapshot(data);

    return Card(
      elevation: 2,
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.sender),
            Text(item.message),
            Reply(
              ref: item.reference,
            )
          ],
        ),
      ),
    );
  }
}
