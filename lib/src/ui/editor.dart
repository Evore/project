import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/content.dart';

class Editor extends StatefulWidget {
  Editor({this.ref});
  final DocumentReference ref;
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> with SingleTickerProviderStateMixin {
  TabController _controller;
  TextEditingController _editingController, _editingController2;

  String title = '';
  String content = '';
  Content newContent;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _editingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        //TODO make the title dynamic
        title: Text(
          'Editor',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
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
    );
  }

  Widget editorPage(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          child: TextField(
            maxLines: null,
            controller: _editingController,
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
          padding: EdgeInsets.all(12),
          child: TextField(
            maxLines: null,
            controller: _editingController2,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'The rest of the content goes here'),
            onChanged: (String text) {
              setState(() {
                this.content = text;
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
      //  child: Text(text),
    );
  }
}