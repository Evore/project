library login;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../home.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  String email, password;
  bool isloading = false;

  Future<bool> sendVerification(FirebaseUser user) async {
    //might not need to use this method, but for posterity...
    bool result;
    print('checking email verifiation');
    try {
      if (!user.isEmailVerified) {
        user.sendEmailVerification();
        print('sending verification');
        result = false;
      } else {
        print('user is verified.');
        result = true;
      }
    } on SocketException catch (_) {
      print('NOT CONNECTED!!!!');
    }
    return result;
  }

  void getUserData(){
    Future<QuerySnapshot>  aa = Firestore.instance.collection('users').where('email', isEqualTo: email).getDocuments();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget logo(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 80, bottom: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Image.asset('assets/diamond.png', color: Colors.white10,
          //     colorBlendMode: BlendMode.saturation,
          //     height: 70),
          SizedBox(height: 16.0),
          Container(
            child: Text(
              'LOGIN',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 23,
                  color: Colors.grey[900]),
            ),
          ),
        ],
      ),
    );
  }

  Widget mailInput(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 18),
      child: Row(children: [
        Container(
            padding: EdgeInsets.only(right: 8),
            child: Icon(
              Icons.person,
              color: Colors.grey[700],
            )),
        Flexible(
          child: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                labelText: 'Student mail'),
          ),
        ),
      ]),
    );
  }

  Widget passwordInput(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
            padding: EdgeInsets.only(right: 8),
            child: Icon(
              Icons.lock,
              color: Colors.grey[700],
            )),
        Flexible(
          child: TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              labelText: 'Password',
            ),
            obscureText: true,
          ),
        ),
      ]),
    );
  }

  Widget buttonBar(BuildContext context) {
    return Column(
      children: <Widget>[
        isloading
            ? CircularProgressIndicator()
            : RaisedButton(
                color: Colors.grey[900],
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 70),
                    child: Text('Next',
                        style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
                onPressed: () {
                  try {
                    setState(() {
                      isloading = true;
                    });
                    _auth
                        .signInWithEmailAndPassword(
                            email: _usernameController.text,
                            password: _passwordController.text)
                        .then((user) {
                      if (user != null) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      } else {
                        setState(() {
                          isloading = false;
                        });
                      }
                    }).catchError((e) {
                      print(e);
                    });
                  } catch (error) {
                    setState(() {
                      isloading = false;
                    });
                    print("THE ERROR IS: " + error.toString());
                  }
                }),
        SizedBox(height: 10),
        FlatButton(child: Text('Forgot password?'), onPressed: () {})
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            logo(context),
            mailInput(context),
            passwordInput(context),
            buttonBar(context)
          ],
        ),
      ),
    );
  }
}

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
      ),
    );
  }
}
