import 'package:flutter/material.dart';
import '../models/content.dart';

class TabContents extends StatelessWidget {
  TabContents({this.content});
  final Content content;


  @override
  Widget build(BuildContext context) {
    return contents(context, content);
  }

  Widget contents(BuildContext context, content) {
    double fullWidth = MediaQuery.of(context).size.width;
    print(fullWidth);
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      contentItem(context, content.name, '\n' + content.test.toString(),
                          true, 'emphasis'),
                      contentItem(context, 'middle'),
                      contentItem(context, 'end')
                    ],
                  ),
                ))
          ]),
    );
  }

  Widget contentItem(context, String text,
      [String text2 = '', bool colored = false, String colorType]) {
    if (colored && colorType == null) text += ' $colored';
    return Container(
        width: MediaQuery.of(context).size.width,
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
