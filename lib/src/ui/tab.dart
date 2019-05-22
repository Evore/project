library tabcontent;

import 'package:flutter/material.dart';

class ContentTabs extends StatefulWidget {
  _ContentTabsState createState() => _ContentTabsState();
}

class _ContentTabsState extends State<ContentTabs> {
  double fullWidth;

  @override
  Widget build(BuildContext context) {
    fullWidth = MediaQuery.of(context).size.width;

    return tabContainer();
  }

  Widget tabContainer() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: TabBarView(
          children: <Widget>[contents(), contents(), contents()],
        ),
      ),
    );
  }

  Widget contents() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
            margin: EdgeInsets.symmetric(horizontal:8, vertical: 10),
            child: Container(
              width: fullWidth,
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  contentItem('Title', '', true, 'emphasis'),
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
