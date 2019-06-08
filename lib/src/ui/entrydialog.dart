import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

//For entry of new lessons

class EntryDialog extends StatefulWidget {
  EntryDialog({this.ref});
  final CollectionReference ref;
  _EntryDialogState createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  TextEditingController _nameCtrl, _imageCtrl, _posCtrl;

  String name = '';
  String image = '';
  int position = 0;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _posCtrl = TextEditingController();
    _imageCtrl = TextEditingController();
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
      vPadding = 100;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      color: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(3),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: null,
            automaticallyImplyLeading: false,
            title: Text(
              'Add a new Lesson',
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
            children: <Widget>[entries()],
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
          SizedBox(height: 20),
          Text(
            'Title',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
            decoration: decoration,
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: TextField(
              maxLines: null,
              autocorrect: true,
              textCapitalization: TextCapitalization.words,
              controller: _nameCtrl,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter the lesson title here'),
              onChanged: (String text) {
                setState(() {
                  name = text;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(0, 5, 20, 15),
                  decoration: decoration,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    controller: _posCtrl,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Order'),
                    onChanged: (String text) {
                      setState(() {
                        position = int.parse(_posCtrl.text);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Image',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
            decoration: decoration,
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: TextField(
              minLines: 1,
              maxLines: 17,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _imageCtrl,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Image to  be displayed'),
              onChanged: (String text) {
                setState(() {
                  image = text;
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
      CollectionReference reference = widget.ref;

      await reference.add({
        "name": name,
        "position": position,
        "image": image
      }).whenComplete(() {
        Toast.show('Node added successfully', context);
        Navigator.pop(context);
      });
    });
  }
}
