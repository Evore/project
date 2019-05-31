
import 'package:cloud_firestore/cloud_firestore.dart';

class SemesterData {
  String name;
  int level, semester, id;
  DocumentReference reference;

  SemesterData.fromMap(Map<String, dynamic> map, {this.reference})
      : level = map['level'],
        name = map['name'],
        semester = map['semester'],
        assert(map['level'] != null),
        assert(map['name'] != null),
        assert(map['semester'] != null);

  SemesterData.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

      
  @override
  String toString() => "SemesterData<$name:";
}