library tabcontent;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/content.dart';
import '../models/record.dart';
import 'editor.dart';
import 'tabsui.dart';

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
    List<Content> items =
        snapshots.map((data) => Content.fromSnapshot(data)).toList();

    return items.isNotEmpty ? body(context, items) : emptySnaps();
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
                'Nothing to see here yet.',
                textAlign: TextAlign.center,
              ),
              // SizedBox(height: 5),
              Text(
                'Feel free to browse other collections in the meanwhile.',
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context, List<Content> items) {
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
                Content item = items[index];
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
              Content content = items[index];
              return TabContents(
                content: content,
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Editor(
                  data: widget.calldata,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}