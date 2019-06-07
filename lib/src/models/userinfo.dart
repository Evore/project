import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name, email;
  // course_name;
  int abs_level;

  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        email = map['email'],
        // course_name = map['course_name'],
        abs_level = map['name'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "User<$name:";
}

class UserDetails {
  static User user;
}
