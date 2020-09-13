import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:task3/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginFunction {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String name;
  String email;
  String imageUrl;
  Korisnik korisnik;

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  Future<Korisnik> facebookLogin() async {
    FacebookLogin facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    print(graphResponse.body);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.credential(token);
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User user = userCredential.user;
        final Korisnik finalUser =
            createUser(user, user.displayName, user.photoURL, "Facebook");
        korisnik = finalUser;
        await addUserToFirebase(finalUser, "Facebook");
        return finalUser;

        break;

      case FacebookLoginStatus.cancelledByUser:
        print('canceled by user');
        return null;
        break;
      case FacebookLoginStatus.error:
        print('error');
        return null;
        break;
      default:
        return null;
    }
  }

  Korisnik createUser(
      User user, String username, String photUrl, String platforma) {
    return user != null
        ? Korisnik(
            uid: user.uid,
            username: username,
            profileImageUrl: photUrl,
            platforma: platforma)
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
            createUser(user, user.displayName, user.photoURL, "Twitter");
        await addUserToFirebase(finalUser, "Twitter");
        korisnik = finalUser;
        return finalUser;
        break;
      case TwitterLoginStatus.error:
        print("An Error Ocurred");
        break;
    }
  }

  Future<Korisnik> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
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

    if (user != null) {
      // Checking if email and name is null
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);
      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      print('signInWithGoogle succeeded: $user');
      final Korisnik finalUser =
          createUser(user, user.displayName, user.photoURL, 'Google');
      await addUserToFirebase(finalUser, 'Google');
      return finalUser;
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final Korisnik finalUser =
        createUser(user, user.displayName, user.photoURL, 'Google');
    print(finalUser);
    await addUserToFirebase(finalUser, 'Google');
    return finalUser;
  }

  Future<void> signOut() async {
    DocumentSnapshot docRef = await _firebaseFirestore
        .collection("AllUsers")
        .doc(_auth.currentUser.uid)
        .get();
    final s = docRef.data();

    switch (s["platforma"]) {
      case "Facebook":
        await FacebookLogin().logOut();
        _auth.signOut();
        break;
      case "Twitter":
        await TwitterLogin(
                consumerKey: "wvhUL3i41kSEXMMoRGS7USi9s",
                consumerSecret:
                    "EY9OQO3rWgsR5cm7RTXdX5b2l5hq3U3NWOySzdXiHcjHCtvo3H")
            .logOut();
        _auth.signOut();
        break;
      case "Goole":
        await GoogleSignIn().signOut();
        _auth.signOut();
    }
  }

  Future<void> addUserToFirebase(Korisnik user, String platforma) async {
    await _firebaseFirestore.collection("AllUsers").doc(user.uid).set({
      "uid": user.uid,
      "username": user.username,
      "photoUrl": user.profileImageUrl,
      "platforma": platforma
    });
  }
}
