import '../widgets/social_media_button.dart';
import '../functions/login_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final LoginFunction _loginFunction = LoginFunction();

  @override
  Widget build(BuildContext context) {
    return Container(
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
              'Dobrodošli!',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              height: 40.0,
            ),
            SocialMediaButton(
              naslovSoc: 'Facebook',
              onPressed: _loginFunction.facebookLogin,
              bojaTipke: Colors.blue[700],
              bojaNaslova: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            SocialMediaButton(
              naslovSoc: 'Google',
              onPressed: () {
                signInWithGoogle().whenComplete(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return FirstScreen();
                      },
                    ),
                  );
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            SocialMediaButton(
              naslovSoc: 'Twitter',
              onPressed: () async {
                await _loginFunction.twitterLogin();
              },
              bojaTipke: Colors.blue[300],
              bojaNaslova: Colors.white,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Prijavom prihvatate uslove korištenja',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final User currentUser = _auth.currentUser;
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}
