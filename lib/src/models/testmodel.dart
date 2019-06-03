import 'package:cloud_firestore/cloud_firestore.dart';

class Tests {
  Tests({this.question, this.choices, this.reference, this.answer});
  String question;
  int answer;
  List choices;
  DocumentReference reference;

  Tests.fromMap(Map<String, dynamic> map, {this.reference})
      : question = map['question'],
        answer = map['answer'],
        choices = List.from(map['choices']);

  Tests.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "$question";
}
