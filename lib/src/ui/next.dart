library home;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/subjectdata.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/lessonsdata.dart';

import 'entrydialog.dart';
import 'tabs.dart' as l1;

class Item extends StatefulWidget {
  Item({this.subject});
  final SubjectData subject;
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool isPortrait;
  bool open = false;
  bool editingState = false;
  String name = '';

  CollectionReference ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref = widget.subject.reference.collection("submodules");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[700], size: 1),
        textTheme: TextTheme(title: TextStyle(color: Colors.grey[700])),
        centerTitle: true,
        title: Text(
          'Learn',
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[addNew()],
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
            iconSize: 20,
            icon: Icon(
              Icons.arrow_back,
            ),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.grey[100],
      body: _buildBody(context),
    );
  }

  Widget addNew() {
    return IconButton(
      tooltip: 'Add New',
      icon: Icon(
        Icons.add,
        size: 21,
      ),
      onPressed: () {
        print(ref.path);
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => EntryDialog(ref: ref));
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    // get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: ref.orderBy('position').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
              child: new CircularProgressIndicator(),
            );
          default:
            return pageFrame(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget pageFrame(BuildContext context, List<DocumentSnapshot> snapshots) {
    return snapshots.isEmpty
        ? Container()
        : ListView(
            padding: EdgeInsets.symmetric(vertical: 10),
            shrinkWrap: true,
            children: snapshots
                .map(
                  (data) => makeBody(context, data),
                )
                .toList(),
          );
  }

  Widget makeBody(BuildContext context, DocumentSnapshot data) {
    Lesson lesson = Lesson.fromSnapshot(data);
    return makeCard(lesson);
  }

  Widget makeCard(Lesson lesson) {
    return Container(
      margin: new EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            blurRadius: 3,
            spreadRadius: 0,
            offset: Offset(0.0, 1),
          )
        ],
      ),
      child: myListTile(lesson),
    );
  }

  Widget myListTile(Lesson lesson) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(4),
      )),
      child: Container(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 65),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              width: 205,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    lesson.name,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5),
                  // iconBar()
                ],
              ),
            ),
            Container(
              height: 55,
              width: 55,
              child: ClipOval(
                child: lesson.image.isNotEmpty
                    ? CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: lesson.image,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.image),
                      )
                    : Image.asset(
                        'assets/computer.png',
                        fit: BoxFit.fill,
                      ),
              ),
            )
          ]),
        ),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => l1.ContentTabs(
                    calldata: lesson,
                  ),
            ));
      },
    );
  }
}
