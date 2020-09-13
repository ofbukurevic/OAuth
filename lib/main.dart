import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import './functions/login_functions.dart';
import 'screens/Wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: LoginFunction().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        // home: LoginFunction().user ==null ? FirstScreen() : SecondScreen(),
        home: Wrapper(),
      ),
    );
  }
}
