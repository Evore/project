import 'package:flutter/material.dart';
import '../models/content.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TabContents extends StatelessWidget {
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
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Container(
                    // width: fullWidth,
                    padding: EdgeInsets.all(4),
                    child: contentItem(context, content)))
          ]),
    );
  }

  Widget contentItem(context, Content content) {
    print(content.content);
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(4),
        child: MarkdownBody(data: ' # ${content.name} \n${content.content}'));
  }
}
