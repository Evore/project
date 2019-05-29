import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String name, content;
  final bool test;
  final DocumentReference reference;

  Course.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
      test = map['test'],
      content = map['course']
      ;

  Course.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Course<$name:";
}
