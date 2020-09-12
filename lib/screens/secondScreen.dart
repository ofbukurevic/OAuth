import 'package:flutter/material.dart';
import '../functions/login_functions.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final LoginFunction _loginFunction = LoginFunction();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
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
                Text(
                  'Dobrodošao:',
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
    ));
  }
}
