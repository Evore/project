import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectData {
  String name, courseId, image;
  DocumentReference reference;

  SubjectData();

  SubjectData.fromMap(Map<String, dynamic> map, {this.reference})
      : courseId = map['courseId'],
        name = map['name'],
        image = map['image'];

  SubjectData.fromSnapShot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  
  @override
  String toString() => "SubjectData<$name:";
}
