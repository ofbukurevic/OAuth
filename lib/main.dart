import 'package:task3/screens/secondScreen.dart';

import './screens/first_screen.dart';
// import './screens/secondScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './functions/login_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: LoginFunction().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: LoginFunction().user == null ? FirstScreen() : SecondScreen(),
      ),
    );
  }
}
