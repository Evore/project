library forum;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project/src/models/forumdata.dart';
import 'package:project/src/ui/replyeditor.dart';
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
      constraints: BoxConstraints(minHeight: 60),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey[300],
            blurRadius: 1.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 0.5))
      ]),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          message(item),
          Row(
            children: <Widget>[replybutton(item), seeMore(item)],
          ),
          isClicked ? ForumReply(data:item) : Container(),
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
        Text(data.message),
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
      quarterTurns: isClicked ? 1 : 3,
      child: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            setState(() {
              isClicked = !isClicked;
            });
          }),
    );
  }
}

class ForumReply extends StatefulWidget {
  ForumReply({this.data});
  final ForumData data;
  _ForumReplyState createState() => _ForumReplyState();
}

class _ForumReplyState extends State<ForumReply> {
  bool isPortrait;
  bool isClicked = false;
  BoxShadow shadow =
      BoxShadow(color: Colors.grey[300], blurRadius: 1.0, spreadRadius: 0.0);

  @override
  Widget build(BuildContext context) {
    return fetchreplies(widget.data);
  }

  @override
  fetchreplies(ForumData data) {
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
        shrinkWrap: true,
        children: snapshots.map((data) => reply(context, data)).toList());
  }

  Widget reply(BuildContext context, DocumentSnapshot snapshot) {
    ForumData data = ForumData.fromSnapshot(snapshot);
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Colors.amber[50],
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
                  children: <Widget>[
                    replybutton(data), seeMore(data)
                    ],
                ),
                isClicked ? FurtherReply(
                  data: data,
                ) : Container(),
              ],
            ),
          ),
        ],
      ),
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
      quarterTurns: isClicked ? 1 : 3,
      child: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            setState(() {
              isClicked = !isClicked;
            });
          }),
    );
  }
}



class FurtherReply extends StatefulWidget {
  FurtherReply({this.data});
  final ForumData data;
  _FurtherReplyState createState() => _FurtherReplyState();
}

class _FurtherReplyState extends State<FurtherReply> {
  bool isPortrait;
  bool isClicked = false;
  BoxShadow shadow =
      BoxShadow(color: Colors.grey[300], blurRadius: 1.0, spreadRadius: 0.0);

  @override
  Widget build(BuildContext context) {
    return fetchreplies(widget.data);
  }
  
  fetchreplies(ForumData data) {
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
        shrinkWrap: true,
        children: snapshots.map((data) => reply(context, data)).toList());
  }

  Widget reply(BuildContext context, DocumentSnapshot snapshot) {
    ForumData data = ForumData.fromSnapshot(snapshot);
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Colors.amber[200],
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
                  children: <Widget>[
                    replybutton(data), seeMore(data)
                    ],
                ),
                isClicked ? Container() : Container(),
              ],
            ),
          ),
        ],
      ),
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
      quarterTurns: isClicked ? 1 : 3,
      child: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            setState(() {
              isClicked = !isClicked;
            });
          }),
    );
  }
}
