import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/content.dart';
import '../models/record.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Editor extends StatefulWidget {
  Editor({this.data, this.isDocumentNew});
  final bool isDocumentNew;
  final Record data;
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> with SingleTickerProviderStateMixin {
  TabController _controller;
  TextEditingController _titleCtrl, _contentCtrl;

  String title = '';
  String content = '';
  Content newContent;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _titleCtrl = TextEditingController();
    _contentCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        //TODO make the title dynamic
        title: Text(
          'Editor',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Save'),
            onPressed: () {
              newContent = Content(
                name: _titleCtrl.text,
                content: _contentCtrl.text,
                test: false,
                position: 4
              );

              // widget.isDocumentNew ? _addToDatabase(newContent) : _updateData(+data)
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
        children: <Widget>[editorPage(context), preview(context)],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          _contentCtrl.text +=
              "\n ## ![Flutter logo](https://cdn-images-1.medium.com/max/1600/1*6xT0ZOACZCdy_61tTJ3r1Q.png)";
        },
      ),
    );
  }

  Widget editorPage(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
        border: Border.all(color: Colors.grey[300], width: 1),
        borderRadius: BorderRadius.circular(5));

    return ListView(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 25, 10, 10),
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
          margin: EdgeInsets.all(10),
          decoration: decoration,
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: TextField(
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
    );
  }

  Widget preview(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: new MarkdownBody(data: '$title \n$content'));
  }

  Future<void> _addToDatabase(Content content) {
    return Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = widget.data.reference.collection('content');

      await reference.add({
        "name": "${content.name}",
        "content": "${content.content}",
        "position": "${content.position}",
        "test": "${content.test}",
        "reference": "${content.reference}",
      });
    });
  }

  Future<void> _updateData(Content content) {
    return Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference = content.reference;

      await reference.updateData({
        "name": "${content.name}",
        "content": "${content.content}",
        "position": "${content.position}",
        "test": "${content.test}",
        "reference": "${content.reference}",
      });
    });
  }
}
