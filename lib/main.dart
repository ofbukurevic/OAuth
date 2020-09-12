import 'package:OAuth/screens/first_screen.dart';
import 'package:OAuth/screens/secondScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: FirstScreen(),
    );
  }
}
