import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/src/models/testmodel.dart';
import 'package:project/src/ui/testeditor.dart';

class TestContents extends StatelessWidget {
  // Take a test
  TestContents({this.reference});
  final DocumentReference reference;

  @override
  Widget build(BuildContext context) {
    // DocumentReference ref = calldata.reference;
    return StreamBuilder<QuerySnapshot>(
      stream: reference.collection('tests').snapshots(),
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
    List<Tests> items =
        snapshots.map((data) => Tests.fromSnapshot(data)).toList();

    return contents(context, items);
  }

  Widget contents(BuildContext context, List<Tests> items) {
    double fullWidth = MediaQuery.of(context).size.width;
    return Container(
      width: fullWidth,
      child: ListView(children: items.map((data) => newSection(data)).toList()),
    );
  }

  Widget newSection(data) {
    return TestSection(test: data);
  }
}

class TestSection extends StatefulWidget {
  // Take a test
  TestSection({this.test});
  final Tests test;

  SectionState createState() => SectionState();
}

class SectionState extends State<TestSection> {
  int radioValue = 0;
  int answer;
  bool isSelected;

  void _handleRadioValueChange(int value) {
    setState(() {
      radioValue = value;
      if (value == answer) {
        isSelected = true;
      } else
        isSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    answer = widget.test.answer;
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2))),
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TestEditor(
                        existingData: widget.test,
                      )));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: <Widget>[
              Container(
                width: 400,
                padding: EdgeInsets.all(5),
                child: Text(
                  widget.test.question,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                ),
              ),
              Container(
                child: buildoptions(widget.test.choices),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildoptions(List list) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: list.map((data) => make2(data, list.indexOf(data))).toList());
  }

  Widget make2(String text, int index) {
    index++;
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          value: index,
          groupValue: radioValue,
          onChanged: _handleRadioValueChange,
        ),
        Text(text),
        SizedBox(width: 5),
        rightOrWrong(index == answer)
      ],
    );
  }

  Widget rightOrWrong(bool isright) {
    final right = Icon(Icons.check, size: 14, color: Colors.green);
    final wrong = Icon(Icons.close, size: 14, color: Colors.red);

    return isSelected == null ? Container() : isright ? right : wrong;
  }
}
