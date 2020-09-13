import './screens/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
// import 'package:provider/provider.dart';

=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
>>>>>>> 32a5d5431a1d6352498417630ccd249620e4e1eb
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
<<<<<<< HEAD
    return StreamProvider.value(
=======
    return StreamProvider<User>.value(
>>>>>>> 32a5d5431a1d6352498417630ccd249620e4e1eb
      value: LoginFunction().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
<<<<<<< HEAD
        home: LoginFunction().user == null ? FirstScreen() : SecondScreen(),
=======
        // home: LoginFunction().user ==null ? FirstScreen() : SecondScreen(),
        home: Wrapper(),
>>>>>>> 32a5d5431a1d6352498417630ccd249620e4e1eb
      ),
    );
  }
}
