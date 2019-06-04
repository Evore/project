import 'package:cloud_firestore/cloud_firestore.dart';

class ForumData {
  ForumData({this.sender, this.message});
  final String sender, message;
  DocumentReference reference;

  ForumData.fromMap(Map<String, dynamic> map, {this.reference})
      : sender = map['sender'],
        message = map['message'];

  ForumData.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "ForumData<$sender:";
}
