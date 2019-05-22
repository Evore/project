
import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectData {
  final _columnId = 'id';
  final _columnName = 'name';
  final _columnCourseId = 'course_id';
  
  String name, courseId, imageName;
  DocumentReference reference;

  SubjectData();

  SubjectData.fromMap(Map<String, dynamic> map, {this.reference})
      : courseId = map['courseId'],
        name = map['name'],
        imageName = map['imageName'],
        assert(map['courseId'] != null),
        assert(map['name'] != null),
        assert(map['imageName'] != null);

  SubjectData.fromSnapShot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  SubjectData.fromDbMap(Map<String, dynamic> query)
      : courseId = query['courseId'],
        name = query['name'],
        imageName = query['imageName'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _columnName: name,
      _columnCourseId: courseId
    };
  }

  List<SubjectData> fromList (List<Map<String, dynamic>> query){
    List<SubjectData> data;
    for (Map map in query) {
      data.add(SubjectData.fromDbMap(map));
    }
    return data;
  }
}



