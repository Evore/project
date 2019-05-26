
import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String title;
  final DocumentReference reference;

  Course.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map['title'];

  Course.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Course<$title:";
}
