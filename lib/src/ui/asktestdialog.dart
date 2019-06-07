import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/src/models/lessonsdata.dart';
import 'package:project/src/ui/editor.dart';
import 'package:toast/toast.dart';

class AskTestDialog extends StatefulWidget {
  AskTestDialog({this.ref});
  final DocumentReference ref;
  _AskTestDialogState createState() => _AskTestDialogState();
}

class _AskTestDialogState extends State<AskTestDialog> {
  TextEditingController _nameCtrl, _contentCtrl, _posCtrl;

  CollectionReference reference;

  String name = '';
  String content = '';
  int position = 0;
  bool test = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _posCtrl = TextEditingController();
    _contentCtrl = TextEditingController();
    reference = widget.ref.collection('content');
  }

  @override
  Widget build(BuildContext context) {
    double hPadding = 20;
    double vPadding = 100;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      hPadding = 20;
      vPadding = 20;
    } else {
      hPadding = 20;
      vPadding = 110;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      color: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(3),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: null,
            automaticallyImplyLeading: false,
            title: Text(
              'Add new content',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: <Widget>[saveAction()],
          ),
          body: ListView(
            shrinkWrap: true, // To make the card compact
            children: <Widget>[
              entries(),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  child: Text('Skip', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Editor()));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget saveAction() {
    return IconButton(
      iconSize: 20,
      color: Colors.white,
      padding: const EdgeInsets.all(0),
      icon: Icon(Icons.save),
      onPressed: () {
        if (name.isNotEmpty) {
          _addToDatabase();
        } else {
          Toast.show('Kindly enter a lesson name', context);
        }
      },
    );
  }

  BoxDecoration decoration = BoxDecoration(
      color: Colors.grey[100],
      border: Border.all(color: Colors.grey[200], width: 1),
      borderRadius: BorderRadius.circular(2));

  Widget entries() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            'Only fill out these fields if you want to include a quiz. Otherwise, skip this page entirely.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 20),
          Text(
            'Title',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 3, 0, 15),
            decoration: decoration,
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: TextField(
              maxLines: null,
              autocorrect: true,
              textCapitalization: TextCapitalization.words,
              controller: _nameCtrl,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter the lesson title'),
              onChanged: (String text) {
                setState(() {
                  name = text;
                });
              },
            ),
          ),
          Text(
            'Position',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Container(
            width: 100,
            margin: EdgeInsets.fromLTRB(0, 3, 20, 15),
            decoration: decoration,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              keyboardType: TextInputType.number,
              maxLines: 1,
              autocorrect: true,
              textCapitalization: TextCapitalization.words,
              controller: _posCtrl,
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: '0'),
              onChanged: (String text) {
                setState(() {
                  position = int.parse(_posCtrl.text);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToDatabase() {
    return Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.add({
        "name": name,
        "position": position,
        "content": content
      }).whenComplete(() {
        Toast.show('Node added successfully', context);
        Navigator.pop(context);
      });
    });
  }
}
