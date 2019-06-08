import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/main.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          color: Colors.blue,
          child: Text(
            'Logout?',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            FirebaseAuth auth = FirebaseAuth.instance;
            auth.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/', (Route<dynamic> route) => false);
          },
        ),
      ),
    );
  }
}
