import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:task3/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginFunction {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  void facebookLogin() async {
    FacebookLogin facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    print(graphResponse.body);
    if (result.status == FacebookLoginStatus.loggedIn) {
      final credential = FacebookAuthProvider.credential(token);
      _auth.signInWithCredential(credential);
    }
  }

  Korisnik createUser(User user, String username, String photUrl) {
    return user != null
        ? Korisnik(uid: user.uid, username: username, profileImageUrl: photUrl)
        : null;
  }

  Future<Korisnik> twitterLogin() async {
    final TwitterLogin twitterLogin = new TwitterLogin(
        consumerKey: "wvhUL3i41kSEXMMoRGS7USi9s",
        consumerSecret: "EY9OQO3rWgsR5cm7RTXdX5b2l5hq3U3NWOySzdXiHcjHCtvo3H");

    final TwitterLoginResult result = await twitterLogin.authorize();
    final TwitterSession session = result.session;

    switch (result.status) {
      case TwitterLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case TwitterLoginStatus.loggedIn:
        final AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: session.token, secret: session.secret);
        final userCreds = await _auth.signInWithCredential(credential);
        final User user = userCreds.user;
        final Korisnik finalUser =
            createUser(user, user.displayName, user.photoURL);
        await addUserToFirebase(finalUser);
        return finalUser;
        break;
      case TwitterLoginStatus.error:
        print("An Error Ocurred");
        break;
    }
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }

  Future<void> addUserToFirebase(Korisnik user) async {
    await _firebaseFirestore.collection("AllUsers").doc(user.uid).set({
      "uid": user.uid,
      "username": user.username,
      "photoUrl": user.profileImageUrl
    });
  }
}
