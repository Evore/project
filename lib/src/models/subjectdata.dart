import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectData {
  String name, courseId, imageName;
  DocumentReference reference;

  SubjectData();

  SubjectData.fromMap(Map<String, dynamic> map, {this.reference})
      : courseId = map['courseId'],
        name = map['name'],
        imageName = map['imageName'];

  SubjectData.fromSnapShot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  
  @override
  String toString() => "SubjectData<$name:";
}
