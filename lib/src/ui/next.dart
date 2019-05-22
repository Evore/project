library home;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/subjectdata.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'grid.dart' as l1;

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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[_buildBody(context), custAppBar()],
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
    // get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("course")
          .where("name", isEqualTo: widget.subject.name)
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
    DocumentSnapshot data;
    //Todo: fix this. Handle null data
    if(snapshots.isEmpty){}
    else data = snapshots[0];

    final record = Record.fromSnapshot(data);
    if (record.name == null) return Container();
    return makeBody(context, record);
  }

  Widget makeBody(BuildContext context, Record record) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        if (index > 0) return makeCard(index);
        return topContent(context, record.name);
      },
    );
  }

  Decoration decoration = BoxDecoration(
      gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.red.shade300],
          stops: [0.2, 1]));

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

  Widget makeCard(int index) {
    return Container(
      margin: new EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
                color: Color(0x00000000),
                blurRadius: 2,
                spreadRadius: 1,
                offset: Offset(0.0, 1))
          ]),
      child: myListTile(index),
    );
  }

  Widget myListTile(int index) {
    // index++;
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Color(0xff11cc99),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 70),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$index. TAGS AND ATTRIBUTES ',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Text(
                  'Supporting Text',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                SizedBox(height: 10),
                iconBar()
              ],
            ),
          ),
          Container(
              height: 60, width: 60, child: Image.asset('assets/computer.png'))
        ]),
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => l1.Item()));
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

class Record {
  final String name;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:";
}