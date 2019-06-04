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
  bool isClicked = false;
  BoxShadow shadow =
      BoxShadow(color: Colors.grey[300], blurRadius: 1.0, spreadRadius: 0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
        child: _buildBody(context),
      ),
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
        children: snapshots.map((data) => messageBox(context, data)).toList(),
      ),
    );
  }

  Widget messageBox(BuildContext context, DocumentSnapshot data) {
    ForumData item = ForumData.fromSnapshot(data);
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey[300],
            blurRadius: 1.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 0.5))
      ]),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              minHeight: 60,
              maxHeight: 1000
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                message(item),
                Row(
                  children: <Widget>[replybutton(item), seeMore(item)],
                ),
                Expanded( child: isClicked ? fetchreplies(item) : Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }




  Widget message(data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          data.sender,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
        ),
        Text(
          data.message),
      ],
    );
  }

  Widget replybutton(ForumData data) {
    return IconButton(
        icon: Icon(
          Icons.reply,
          size: 19,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Reply(message: data)));
        });
  }

  Widget seeMore(ForumData data) {
    return RotatedBox(
      quarterTurns: 3,
      child: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            isClicked = !isClicked;
          }),
    );
  }



  Widget fetchreplies(ForumData data) {
    DocumentReference ref = data.reference;
    return StreamBuilder<QuerySnapshot>(
      stream: ref.collection('forum').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
              child: new CircularProgressIndicator(),
            );
          default:
            return snaps(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget snaps(BuildContext context, List<dynamic> snapshots) {
    List<ForumData> items =
        snapshots.map((data) => ForumData.fromSnapshot(data)).toList();

    return items.isNotEmpty ? replies(context, snapshots) : Container();
  }

  Widget replies(BuildContext context, List<dynamic> snapshots) {
    return ListView(
        children: snapshots.map((data) => reply(context, data)).toList());
  }

  Widget reply(BuildContext context, DocumentSnapshot snapshot) {
    ForumData data = ForumData.fromSnapshot(snapshot);
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Colors.amber[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.sender,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                Text(
                  data.message,
                  style: TextStyle(fontSize: 15),
                ),
                Row(
                  children: <Widget>[replybutton(data), seeMore(data)],
                ),
                // isClicked ? Container() : Container,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
