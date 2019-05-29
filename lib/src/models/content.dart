import 'package:cloud_firestore/cloud_firestore.dart';

class Content {
  final String name, content;
  final bool test;
  final DocumentReference reference;

  Content.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
      test = map['test'],
      content = map['course'];

  Content.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "$name:";
}
