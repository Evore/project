import 'package:flutter/material.dart';
import 'package:project/src/ui/editor.dart';
import '../models/content.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TabContents extends StatefulWidget {
  TabContents({this.content});
  final Content content;

  TabContentsState createState() => TabContentsState();
}

class TabContentsState extends State<TabContents> {
  Content content;
  @override
  Widget build(BuildContext context) {
    content = widget.content;
    return contents(context, content);
  }

  Widget contents(BuildContext context, content) {
    double fullWidth = MediaQuery.of(context).size.width;
    return Container(
      width: fullWidth,
      child: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2))),
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Editor(existingData: content)));
              },
              child: Container(
                // width: fullWidth,
                padding: EdgeInsets.all(0),
                child: contentItem(context, content),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contentItem(context, Content content) {
    String title = content.name.split('#').last;
    String conts = content.content.replaceAll('\\n', '\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Text(
          '$title',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
      // Divider(height: 1),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        color: Colors.grey[100],
        child: MarkdownBody(data: conts),
      ),
    ]);
  }
}
