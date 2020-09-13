import 'package:flutter/material.dart';
import 'package:task3/screens/first_screen.dart';
import 'package:task3/screens/secondScreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final userStream = Provider.of<User>(context);

    return Scaffold(
      body: userStream != null ? SecondScreen() : FirstScreen(),
    );
  }
}
