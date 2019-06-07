library tabcontent;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/src/models/lessonsdata.dart';
import 'package:project/src/ui/asktestdialog.dart';
import 'package:project/src/ui/forum.dart';
import 'package:project/src/ui/testsui.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../models/content.dart';
import 'tabsui.dart';

class ContentTabs extends StatefulWidget {
  ContentTabs({this.calldata});
  final Lesson calldata;
  _ContentTabsState createState() => _ContentTabsState();
}

class _ContentTabsState extends State<ContentTabs> {
  double fullWidth;

  CollectionReference ref;

  @override
  void initState() {
    super.initState();
    ref = widget.calldata.reference.collection('content');
  }

  @override
  Widget build(BuildContext context) {
    fullWidth = MediaQuery.of(context).size.width;

    return Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: fetchData());
  }

  Widget fetchData() {
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
            return snaps(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget snaps(BuildContext context, List<dynamic> snapshots) {
    List<Content> items =
        snapshots.map((data) => Content.fromSnapshot(data)).toList();

    return body(context, items);
  }

  Widget body(BuildContext context, List<Content> items) {
    int length = items.length;
    return DefaultTabController(
      length: length,
      child: Scaffold(
        appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Colors.blue,
              child: Column(children: [
                Expanded(
                  child: Container(),
                ),
                TabBar(
                  indicatorColor: Colors.white,
                  tabs: List<Widget>.generate(
                    length,
                    (int index) {
                      Content item = items[index];
                      return Tab(
                          icon: item.test
                              ? Icon(
                                  Icons.assignment,
                                  size: 20,
                                )
                              : Icon(Icons.book, size: 20));
                    },
                  ),
                ),
              ]),
            )),
        backgroundColor: Colors.grey[100],
        body: TabBarView(
          children: List<Widget>.generate(
            length,
            (int index) {
              Content content = items[index];
              return sliderFrame(content);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffff4444),
          mini: true,
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AskTestDialog(
                    ref: widget.calldata.reference,
                  ),
            );
          },
        ),
      ),
    );
  }

  double maxHeight() {
    double portHeight = MediaQuery.of(context).size.height;
    portHeight -= 80;
    return portHeight;
  }

  Widget sliderFrame(Content content) {
    return SlidingUpPanel(
      // padding: EdgeInsets.only(top: 40),
      minHeight: 40,
      maxHeight: maxHeight(),
      parallaxEnabled: true,
      backdropEnabled: true,
      backdropColor: Colors.grey,
      panel: Forum(ref: content.reference),
      body: content.test
          ? TestContents(reference: content.reference)
          : TabContents(content: content),
      collapsed: Container(
        decoration: BoxDecoration(
          color: Colors.grey[500],
        ),
        child: Center(
          child: Text(
            "Discussion",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
