library home;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'tab.dart' as t1;

import '../models/record.dart';

class Item extends StatefulWidget {
  Item({this.path});
  final String path;
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool isPortrait;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[positionedBody(), custAppBar()],
      ),
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
                  color: Color(0x22000000),
                  blurRadius: 1.5,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 1))
            ],
          ),
          child: stackedAppBar(),
        ));
  }

  Widget stackedAppBar() {
    return Stack(
      alignment: Alignment(0, 0),
      children: <Widget>[
        Text(
          'Web Technologies and Design',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.grey[900]),
        ),
        leading()
      ],
    );
  }

  Widget leading() => Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        child: IconButton(
          icon: Icon(Icons.navigate_before),
          color: Colors.grey[800],
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );

  Widget _buildBody(BuildContext context) {
    // get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("course")
          // .where("name", isEqualTo: "Web Design and Technologies")
          .snapshots(),
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
    DocumentSnapshot data = snapshots[0];
    final record = Record.fromSnapshot(data);
    if (record.name == null) return Container();
    return body(context, record);
  }

  Widget body(BuildContext context, Record record) {
    return makeBody(context);
  }

  Decoration decoration = BoxDecoration(
      gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.red.shade300],
          stops: [0.2, 1]));

  Widget positionedBody() {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height, //allows scroll
      child: makeBody(context),
    );
  }

  Widget makeBody(BuildContext context) {
    bool isPortrait =
        (MediaQuery.of(context).orientation == Orientation.portrait);
    return Container(
      padding: EdgeInsets.fromLTRB(14, 35, 14, 45),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isPortrait ? 2 : 3,
            childAspectRatio: isPortrait ? 1 / 1 : 1 / 0.9,
            crossAxisSpacing: 6,
            mainAxisSpacing: 10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return myListItem(index);
        },
      ),
    );
  }

  Widget myListItem(int index) {
    return RaisedButton(
      padding: EdgeInsets.all(0),
      color: Color(0xfff2f0f0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Text('$index. Working with Text',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                fontWeight: FontWeight.w400))),
          iconBar(),
        ],
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => t1.ContentTabs()));
      },
    );
  }

  Widget iconBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
      decoration: BoxDecoration(
          color: Color(0xff11cc88),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(3))),
      child: Row(
        children: <Widget>[
          Icon(Icons.slideshow, color: Colors.white, size: 15),
          SizedBox(width: 10),
          Text('0/8', style: TextStyle(fontSize: 12, color: Colors.white))
        ],
      ),
    );
  }
}
