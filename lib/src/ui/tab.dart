library tabcontent;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';
import '../models/record.dart';

class ContentTabs extends StatefulWidget {
  ContentTabs({this.calldata});
  final Record calldata;
  _ContentTabsState createState() => _ContentTabsState();
}

class _ContentTabsState extends State<ContentTabs> {
  double fullWidth;

  @override
  Widget build(BuildContext context) {
    fullWidth = MediaQuery.of(context).size.width;

    return Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: fetchData());
  }

  Widget fetchData() {
    DocumentReference ref = widget.calldata.reference;
    return StreamBuilder<QuerySnapshot>(
      stream: ref.collection('content').orderBy('position').snapshots(),
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
    List<Course> items =
        snapshots.map((data) => Course.fromSnapshot(data)).toList();

    return items.isNotEmpty ? tabContainer(context, items) : emptySnaps();
  }

  Widget emptySnaps() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Nothing to here yet.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Feel free to browse other collections. In the meanwhile',
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget tabContainer(BuildContext context, List<Course> items) {
    int length = items.length;
    return DefaultTabController(
      length: length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          bottom: TabBar(
            tabs: List<Widget>.generate(
              length,
              (int index) {
                Course item = items[index];
                return Tab(
                    icon:
                        item.test ? Icon(Icons.assignment) : Icon(Icons.book));
              },
            ),
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: TabBarView(
          children: List<Widget>.generate(
            length,
            (int index) {
              return contents(items[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget contents(record) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2))),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Container(
                width: fullWidth,
                padding: EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    contentItem(record.name, '\n' + record.test.toString(),
                        true, 'emphasis'),
                    contentItem('middle'),
                    contentItem('end')
                  ],
                ),
              ))
        ]);
  }

  Widget contentItem(String text,
      [String text2 = '', bool colored = false, String colorType]) {
    if (colored && colorType == null) text += ' $colored';
    return Container(
        width: fullWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: colored
              ? colorType == 'emphasis' ? Colors.lime : Colors.lightGreen
              : null,
        ),
        padding: EdgeInsets.all(4),
        child: Text(text + text2));
  }
}
