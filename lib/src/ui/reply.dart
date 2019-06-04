import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project/src/models/forumdata.dart';

class Reply extends StatefulWidget {
  Reply({this.ref});
  final DocumentReference ref;

  ReplyState createState() => ReplyState();
}

class ReplyState extends State<Reply> {
  String message, sender;
  DocumentReference reference;
  TextEditingController controller = TextEditingController();
  bool replying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.all(30),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            priorMessage(),
            replyEditor()],
        ),
      ),
    );
  }

  Widget priorMessage() {
    return Column(
      children: <Widget>[Text('a'), Text('b')],
    );
  }

  Widget replyEditor() {
    return Container(
      width: 400,
      constraints: BoxConstraints(),
      padding: EdgeInsets.all(20),
      child: TextField(
        onChanged: (String value) {
          message = value;
        },
      ),
    );
  }

  Widget replyButton() {
    return Align(
      child: FlatButton(
        child: Icon(Icons.reply),
        onPressed: () {
          setState(() {
            replying = true;
          });
        },
      ),
    );
  }
}
