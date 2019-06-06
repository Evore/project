import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/src/models/testmodel.dart';
import '../models/record.dart';

class TestEditor extends StatefulWidget {
  TestEditor({this.existingData});
  final Tests existingData;
  _TestEditorState createState() => _TestEditorState();
}

class _TestEditorState extends State<TestEditor>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  TextEditingController _questionCtrl, _contentCtrl, answerCtrl;

  bool isDocumentNew = true;
  String question = '';
  List<String> choices;
  String choice;
  int answer;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _questionCtrl = TextEditingController();
    _contentCtrl = TextEditingController();
    answerCtrl = TextEditingController();
    prepEdits();
  }

  void prepEdits() {
    if (widget.existingData != null) {
      isDocumentNew = false;
      _questionCtrl.text = widget.existingData.question;
      choices = widget.existingData.choices;
    }
  }

  BoxDecoration decoration = BoxDecoration(
      color: Colors.grey[100],
      border: Border.all(color: Colors.grey[200], width: 1),
      borderRadius: BorderRadius.circular(2));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Text(
          isDocumentNew ? 'TestEditor' : widget.existingData.question,
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          FlatButton(
            shape: CircleBorder(),
            child: Text('Save'),
            onPressed: () {
              print("Is this a new document? : $isDocumentNew");
              Tests content = Tests(
                  question: _questionCtrl.text,
                  choices: choices,
                  answer: answer);
              isDocumentNew ?
              _addToDatabase(content)
              : _updateData(content);
            },
          )
        ],
        bottom: TabBar(
          controller: _controller,
          tabs: <Widget>[
            Tab(
              child: Text(
                'Edit',
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
            Tab(
              child: Text(
                'Preview',
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: <Widget>[testeditorTab(context), preview(context)],
      ),
      //TODO: fix this
      // floatingActionButton: editingActions(),
    );
  }

  Widget editingActions() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 40,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 2,
              child: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _contentCtrl.text +=
                    "\n## ![Flutter logo](https://cdn-images-1.medium.com/max/1600/1*6xT0ZOACZCdy_61tTJ3r1Q.png)";
              },
            ),
          ),
          Container(
            height: 40,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 2,
              child: Icon(
                Icons.image,
                color: Colors.green,
              ),
              onPressed: () {
                _contentCtrl.text +=
                    "\n## ![Flutter logo](https://cdn-images-1.medium.com/max/1600/1*6xT0ZOACZCdy_61tTJ3r1Q.png)";
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget testeditorTab(BuildContext context) {
    return ListView(
       padding: EdgeInsets.symmetric(horizontal: 10),
      children: [
        SizedBox(height: 20),
        Text(
          'Question',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
          decoration: decoration,
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: TextField(
            maxLines: null,
            autocorrect: true,
            textCapitalization: TextCapitalization.words,
            controller: _questionCtrl,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your question here'),
            onChanged: (String text) {
              setState(() {
                question = text;
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 150,
                margin: EdgeInsets.fromLTRB(0, 5, 20, 15),
                decoration: decoration,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  autocorrect: true,
                  textCapitalization: TextCapitalization.words,
                  controller: answerCtrl,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Order'),
                  onChanged: (String text) {
                    setState(() {
                      answer = text as int;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(
            minHeight: 50,
            // maxHeight: 500,
            maxWidth: 360,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: choices
                .map((data) => choicesWidget(data, choices.indexOf(data)))
                .toList(),
          ),
        ),
        addToChoices()
      ],
    );
  }

  Widget choicesWidget(String text, int index) {
    index++;
    return Container(
      decoration: decoration,
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          Container(width: 280, child: Text(index.toString() + '. ' + text)),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  choices.removeAt(index-1);
                });
              })
        ],
      ),
    );
  }

  Widget addToChoices() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 280,
          margin: EdgeInsets.fromLTRB(0, 8, 7, 8),
          decoration: decoration,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            maxLines: 3,
            minLines: 1,
            autocorrect: true,
            controller: _contentCtrl,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'New possible answer'),
            onChanged: (String text) {
              setState(() {
                choice = text;
              });
            },
          ),
        ),
        IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              if (choice!=null)
                setState(() {
                  choices.add(choice);
                  _contentCtrl.clear();
                });
            })
      ],
    );
  }

  Widget preview(BuildContext context) {
    return ListView(padding: EdgeInsets.all(10), children: [new Container()]);
  }

  Future<void> _addToDatabase(Tests tests) {
    return Firestore.instance.runTransaction((Transaction transaction) async {
      tests.reference.path;
      CollectionReference reference =
          widget.existingData.reference.collection('tests');

      await reference.add({
        "question": tests.question,
        "choices": tests.choices,
        "answer": tests.answer,
      });
    });
  }

  Future<void> _updateData(Tests tests) {
    return Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference = widget.existingData.reference;

      await reference.updateData({
        "question": tests.question,
        "choices": tests.choices,
        "answer": tests.answer,
      }).catchError((error){
        print(error);
      });
    });
  }
}