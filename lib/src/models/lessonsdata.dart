import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String name, image;
  final int position;
  final DocumentReference reference;

  Lesson.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
      image = map['image'],
      position = map['position'];

  Lesson.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Lesson<$name:";
}

//duplicate of subjectdata. delete soon
