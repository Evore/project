import 'package:flutter/material.dart';
import '../models/content.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TabContents extends StatelessWidget {
  // Take a test object
  TabContents({this.content});
  final Content content;

  @override
  Widget build(BuildContext context) {
    return contents(context, content);
  }

  Widget contents(BuildContext context, content) {
    double fullWidth = MediaQuery.of(context).size.width;
    return Container(
      width: fullWidth,
      child: ListView(children: [
        Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2))),
            margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Container(
                // width: fullWidth,
                padding: EdgeInsets.all(4),
                child: contentItem(context, content))),
      ]),
    );
  }

  Widget contentItem(context, Content content) {
    dynamic title = content.name.split('#').last;
    var conts = content.content.replaceAll('\\n', '\n');
    return Column(children: [
      Container(
        padding: EdgeInsets.all(10),
        child: Text(
          '$title',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 23),
        ),
      ),
      Divider(height: 1),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(4),
        child: MarkdownBody(data: conts),
      ),
    ]);
  }
}
