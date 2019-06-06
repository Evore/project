import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart' as prefix0;
import 'package:project/src/models/forumdata.dart';

class Reply extends StatefulWidget {
  Reply({this.message});
  final ForumData message;

  ReplyState createState() => ReplyState();
}

class ReplyState extends State<Reply> {
  String message, sender;
  DocumentReference reference;
  TextEditingController controller = TextEditingController();

  prefix0.BoxShadow shadow =
      BoxShadow(color: Colors.grey[300], blurRadius: 1.0, spreadRadius: 0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[priorMessage(), replyEditor()],
      ),
    );
  }

  Widget priorMessage() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [shadow]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.message.sender,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                Text(
                  widget.message.message,
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget replyEditor() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [shadow]),
      child: Row(
        children: <Widget>[
          Container(
            width: 300,
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: 'Enter your message here',
                  border: InputBorder.none),
              maxLines: 4,
              minLines: 1,
              onChanged: (String value) {
                message = value;
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _addToDatabase(ForumData(message: message, sender: 'mm'));
            },
          )
        ],
      ),
    );
  }


  // Future<void> _updateData(ForumData reply) {
  //   return Firestore.instance.runTransaction(
  //     (Transaction transaction) async {
  //       DocumentReference reference = widget.existingData.reference;

  //       await reference.updateData({
  //         "name": content.name,
  //         "content": content.content,
  //         "position": content.position,
  //         "test": content.test,
  //       }).whenComplete(() {
  //         Navigator.pop(context);
  //       });
  //     },
  //   );


  Future<void> _addToDatabase(ForumData reply) {
    return Firestore.instance.runTransaction((Transaction transaction) async {
      Stream<QuerySnapshot> checkLocation =
          widget.message.reference.collection('forum').snapshots();
      CollectionReference reference =
          widget.message.reference.collection('forum');
      DocumentReference docReference = widget.message.reference;

      if (await checkLocation.isEmpty) {
        await docReference.setData({
          "message": reply.message,
          "sender" : reply.sender
        }).whenComplete(() {
          Navigator.pop(context);
        });
      } else {
        await reference.add({
          "message": reply.message,
          "sender" : reply.sender
        }).whenComplete(() {
          Navigator.pop(context);
        });
      }
    });
  }
}
