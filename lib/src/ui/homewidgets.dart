import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/semesterdata.dart';
import '../models/subjectdata.dart';
import 'next.dart';
import 'customdialog.dart';

class SemesterWidget extends StatefulWidget {
  @override
  _SemesterWidgetState createState() => _SemesterWidgetState();
}

class _SemesterWidgetState extends State<SemesterWidget> {
  @override
  Widget build(BuildContext context) {
    return getRemoteData(context);
  }

  Widget getRemoteData(BuildContext context) {
    // get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("courses/BIT/level")
          .where("abs-level", isLessThan: 3)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
              child: new CircularProgressIndicator(),
            );
          default:
            return buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildList(BuildContext context, List<dynamic> snapshot) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade500, Colors.red.shade300],
          stops: [0.4, 1],
        ),
      ),
      child: Stack(
        children: <Widget>[
          ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: 20),
            children: snapshot
                .map(
                  (data) => _buildListItem(context, data),
                ).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context, String text) {
    BoxShadow shadow =
        BoxShadow(color: Colors.grey[200], blurRadius: 3.0, spreadRadius: 0.0);

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [shadow],
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[900],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, dynamic data) {
    final record = SemesterData.fromSnapshot(data);
    if (record.name == null) return Container();

    return Container(
      padding: EdgeInsets.fromLTRB(4, 4, 4, 15),
      child: Card(
        margin: EdgeInsets.all(0),
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(4),
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(context, record.name),
            SubjectWidget(
              reference: record.reference,
            )
          ],
        ),
      ),
    );
  }
}

class SubjectWidget extends StatefulWidget {
  final DocumentReference reference;
  SubjectWidget({@required this.reference});
  _SubjectWidgetState createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  double portraitHeight, landscapeHeight;
  bool isPortrait = false;

  @override
  Widget build(BuildContext context) {
    return getRemoteData(context);
  }

//TODO: make a color theme
  Widget getRemoteData(BuildContext context) {
    DocumentReference ref = widget.reference;
    // get actual snapshot from Cloud Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: ref.collection("courses").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
              child: new CircularProgressIndicator(),
            );
          default:
            return buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildList(BuildContext context, List<dynamic> snapshot) {
    portraitHeight = MediaQuery.of(context).size.width * 0.61;
    landscapeHeight = MediaQuery.of(context).size.width * 0.40;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      isPortrait = false;
    } else
      isPortrait = true;

    return Container(
      //Todo: try a dropdown list
      height: isPortrait ? portraitHeight : landscapeHeight,
      padding: EdgeInsets.symmetric(horizontal: 0.5, vertical: 8),
      child: GridView.count(
        childAspectRatio: isPortrait ? 1.35 / 1 : 1.4 / 1,
        mainAxisSpacing: 0,
        crossAxisCount: 1,
        scrollDirection: Axis.horizontal,
        children: snapshot
            .map(
              (data) => _buildListItem(context, data),
            ).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final subject = SubjectData.fromSnapShot(data);

    if (subject.name == null) return Container();
    return subjectInfo(context, subject);
  }

  Widget subjectInfo(BuildContext context, SubjectData data) {
    return MaterialButton(
      padding: EdgeInsets.all(isPortrait ? 2 : 4),
      onPressed: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Item(
        //               subject: data,
        //             ),));
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
                subject: data,
              ),
        );
      },
      child: Column(
        //TODO: use a stack layout and curve the top corners
        children: <Widget>[
          AspectRatio(
            //keeps the container in proportional width and height
            aspectRatio: 1 / 1,
            child: Card(
                shape: CircleBorder(),
                elevation: 6,
                color: Colors.white,
                margin: EdgeInsets.all(14),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: data.imageName,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                )),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            child: Column(
              children: [
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
