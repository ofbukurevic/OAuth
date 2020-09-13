import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../functions/login_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task3/models/UserModel.dart';
import 'package:task3/functions/login_functions.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final LoginFunction _loginFunction = LoginFunction();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
 
    return FutureBuilder<DocumentSnapshot>(
      future: _firebaseFirestore
          .collection("AllUsers")
          .doc(_auth.currentUser.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          print(_auth.currentUser.uid);
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/image.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.topRight),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data.get("photoUrl")),
                        ),
                      ),
                      Text(
                        snapshot.data.get("username"),
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 30,
                  right: 30,
                  child: IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                      size: 40,
                    ),
                    onPressed: _loginFunction.signOut,
                  ))
            ],
          );
        }
      },
    );
  }
}
