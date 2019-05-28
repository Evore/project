library home;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/subjectdata.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'tab.dart' as l1;
import '../models/record.dart';

class Item extends StatefulWidget {
  Item({this.subject});
  final SubjectData subject;
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool isPortrait;
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blueGrey[800],
          size: 1
        ),
        textTheme: TextTheme(
          title: TextStyle(color: Colors.grey)
        ),
        centerTitle: true,
        title: Text('Learn'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      body: _buildBody(context),
    );
  }

  Widget custAppBar() {
    return Positioned(
        top: 35.0,
        right: 0.0,
        left: 0.0,
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 1,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 1))
            ],
          ),
          child: custAppBarIcons(),
        ));
  }

  Widget custAppBarIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.navigate_before),
          color: Colors.grey[800],
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Text(
          'Learn',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.grey[900]),
        ),
        IconButton(
          icon: Icon(Icons.search),
          color: Colors.grey[800],
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    DocumentReference ref = widget.subject.reference;
    print("REFERENCE " + ref.documentID);
    // get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: ref.collection("submodules").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return _buildItemPage(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildItemPage(
      BuildContext context, List<DocumentSnapshot> snapshots) {

    return snapshots.isEmpty ?
        Center(child: Text('Nothing here')) 
        : ListView(
          children: snapshots.map((data) => makeBody(context, data)).toList(),
        );
  }

  Widget makeBody(BuildContext context, DocumentSnapshot data) {
    Record record = Record.fromSnapshot(data);
    return makeCard(record.name);
  }

  Widget topContent(BuildContext context, String name) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(top: 50),
      height: width / 1.5,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          width: width * 0.375,
          child: CachedNetworkImage(
            imageUrl: widget.subject.imageName,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
          padding: EdgeInsets.only(left: 20, right: 5),
        ),
        Container(
          width: width * 0.625,
          padding: EdgeInsets.only(left: 10, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$name',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  )),
            ],
          ),
        ),
      ]),
    );
  }

  Widget makeCard(String name) {
    return Container(
      margin: new EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          color: Color(0xFF64A5F6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[300],
              blurRadius: 3,
              spreadRadius: 2,
              offset: Offset(0.0, 2))
        ],
      ),
      child: myListTile(name),
    );
  }

  Widget myListTile(name) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
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
                    '$name',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  // iconBar()
                ],
              ),
            ),
            Container(
                height: 50,
                width: 50,
                child: Image.asset('assets/computer.png'))
          ]),
        ),
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => l1.ContentTabs()));
      },
    );
  }

  Widget iconBar() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.slideshow,
          color: Colors.white,
          size: 15,
        ),
        SizedBox(width: 10),
        Text('0/8', style: TextStyle(fontSize: 12, color: Colors.white))
      ],
    );
  }
}
