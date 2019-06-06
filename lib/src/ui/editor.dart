import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/src/models/lessonsdata.dart';
import '../models/content.dart';
import '../models/record.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Editor extends StatefulWidget {
  Editor({this.data, this.existingData});
  final Lesson data;
  final Content existingData;
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> with SingleTickerProviderStateMixin {
  TabController _controller;
  TextEditingController _titleCtrl, _contentCtrl, _posCtrl;

  bool isDocumentNew = true;
  String title = '';
  String content = '';
  int position = 0;
  bool test;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _titleCtrl = TextEditingController();
    _contentCtrl = TextEditingController();
    _posCtrl = TextEditingController();
    prepEdits();
  }

  void prepEdits() {
    if (widget.existingData != null) {
      isDocumentNew = false;
      _posCtrl.text = widget.existingData.position.toString();
      _titleCtrl.text = widget.existingData.name;
      _contentCtrl.text = widget.existingData.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Text(
          isDocumentNew ? 'Editor' : widget.existingData.name.isNotEmpty ? widget.existingData.name : 'Editor',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[saveAction(), SizedBox(width: 10), deleteAction()],
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
        children: <Widget>[editorTab(context), preview(context)],
      ),
    );
  }

  Widget saveAction() {
    return IconButton(
      icon: Icon(Icons.save),
      onPressed: () {
        print("Is this a new document? : $isDocumentNew");

        Content newContent = Content(
            name: title, content: content, test: test, position: position);
        isDocumentNew ? _addToDatabase(newContent) : _updateData(newContent);
      },
    );
  }

  Widget deleteAction() {
    return IconButton(
      icon: Icon(Icons.delete_outline),
      onPressed: () {
        print("Is this a new document? : $isDocumentNew");


        if (!isDocumentNew) _deleteData(widget.existingData.reference);
      },
    );
  }

  Widget editorTab(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[200], width: 1),
        borderRadius: BorderRadius.circular(2));

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: [
          SizedBox(height: 20),
          Text(
            'Title',
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
              controller: _titleCtrl,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter your title here'),
              onChanged: (String text) {
                setState(() {
                  title = text;
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
                  width: 100,
                  margin: EdgeInsets.fromLTRB(0, 5, 20, 15),
                  decoration: decoration,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    controller: _posCtrl,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Order'),
                    onChanged: (String text) {
                      setState(() {
                        position = int.parse(_posCtrl.text);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Content',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
            decoration: decoration,
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: TextField(
              minLines: 2,
              maxLines: 17,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _contentCtrl,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'The rest of the content goes here'),
              onChanged: (String text) {
                setState(() {
                  content = text;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget preview(BuildContext context) {
    return ListView(padding: EdgeInsets.all(10), children: [
      new MarkdownBody(data: '# $title \n$content'),
    ]);
  }

  Future<void> _addToDatabase(Content content) {
    return Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          widget.data.reference.collection('content');

      await reference.add({
        "name": content.name,
        "content": content.content,
        "position": content.position,
        "test": content.test,
      }).whenComplete(() {
        Navigator.pop(context);
      });
    });
  }

  Future<void> _updateData(Content content) {
    return Firestore.instance.runTransaction(
      (Transaction transaction) async {
        DocumentReference reference = widget.existingData.reference;

        await reference.updateData({
          "name": content.name,
          "content": content.content,
          "position": content.position,
          "test": content.test,
        }).whenComplete(() {
          Navigator.pop(context);
        });
      },
    );
  }

  Future<void> _deleteData(DocumentReference reference) {
    return Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.delete(reference)
      .whenComplete(() {
        Navigator.pop(context);
      });
    });
  }
}
