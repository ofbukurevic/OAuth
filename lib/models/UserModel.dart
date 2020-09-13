import 'package:flutter/foundation.dart';

class Korisnik {
  final String uid;
  final String username;
  final String profileImageUrl;
  String platforma;

  Korisnik(
      {@required this.uid,
      this.username,
      this.profileImageUrl,
      this.platforma});

  Korisnik user;
}
