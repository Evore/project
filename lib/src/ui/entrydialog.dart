import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

//For entry of new modules or lessons

class EntryDialog extends StatefulWidget {
  EntryDialog({this.ref, this.module});
  final CollectionReference ref;
  final bool module;
  _EntryDialogState createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  TextEditingController _nameCtrl, _imageCtrl, _posCtrl;

  bool isLoading = false;
  String name = '';
  String image = '';
  int position = 0;
  bool module = false;
  String docType = 'lesson';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _posCtrl = TextEditingController();
    _imageCtrl = TextEditingController();
    if (widget.module == true) {
      module = true;
      docType = 'module';
    }
  }

  @override
  Widget build(BuildContext context) {
    double hPadding = 15;
    double vPadding = 70;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      hPadding = 20;
      vPadding = 20;
    }

    return Container(padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      child: dialogContent(context)
    );
  }

  dialogContent(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          title: Text(
            'Add a new $docType',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: <Widget>[saveAction()],
        ),
        body: entries(),
        ),
    );
  }

  Widget saveAction() {
    return isLoading
        ? CircularProgressIndicator(
          backgroundColor: Colors.white,
        )
        : IconButton(
            iconSize: 20,
            color: Colors.white,
            padding: const EdgeInsets.all(0),
            icon: Icon(Icons.save),
            onPressed: () {
              if (name.isNotEmpty) {
                setState(() {
                  isLoading = true;
                });
                _addLessonToDatabase();
              } else {
                Toast.show('Kindly enter a $docType name', context);
              }
            },
          );
  }

  BoxDecoration decoration = BoxDecoration(
      color: Colors.grey[100],
      border: Border.all(color: Colors.grey[200], width: 1),
      borderRadius: BorderRadius.circular(2));

  Widget entries(){
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      children: [
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
                  border: InputBorder.none,
                  hintText: 'Enter the $docType title here'),
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
            // width: 100,
            margin: EdgeInsets.fromLTRB(0, 3, 0, 15),
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
          Text(
            'Image',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
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
        ]);
  }

  Future<void> _addLessonToDatabase() {
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
