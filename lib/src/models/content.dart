import 'package:cloud_firestore/cloud_firestore.dart';

class Content {
  Content({this.name, this.content, this.test, this.position, this.reference});
  String name, content;
  bool test;
  int position;
  DocumentReference reference;

  Content.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        test = map['test'],
        position = map['position'],
        content = map['course'];

  Content.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "$name";
}
