
import 'package:cloud_firestore/cloud_firestore.dart';

class ForumData {
  final String sender, message;
  final DocumentReference reference;

  ForumData.fromMap(Map<String, dynamic> map, {this.reference})
      : sender = map['sender'],
        message = map['message'];

  ForumData.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "ForumData<$sender:";
}
