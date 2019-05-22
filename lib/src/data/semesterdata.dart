
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

  SemesterData.fromDbMap(Map<String, dynamic> query)
      : id = query['id'],
        level = query['level'],
        name = query['name'],
        semester = query['semester'],
        reference = query['reference'];

  List<SemesterData> fromList (List<Map<String, dynamic>> query){
    List<SemesterData> data;
    for (Map map in query) {
      data.add(SemesterData.fromDbMap(map));
    }
    return data;
  }
}