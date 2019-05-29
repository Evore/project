import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'src/home.dart';
import 'src/ui/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Todo: Use a splashscreen
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isSignedIn;

  checkIfSignedIn() {
    _auth.currentUser().then((user) {
      if (user != null) {
        isSignedIn = true;
      } else
        isSignedIn = false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkIfSignedIn();
  }

  void _move() {
    print(isSignedIn);
    checkIfSignedIn();
    // _auth.signOut();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => isSignedIn ? Home() : LoginPage()));
  }

  Widget button(BuildContext context, void function()) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
      elevation: 3,
      highlightElevation: 6,
      color: Colors.blue[500],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      onPressed: () {
        function();
      },
      child: Text('Login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: button(context, _move),
        ),
      ),
    );
  }
}
