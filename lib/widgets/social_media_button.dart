import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  const SocialMediaButton(
      {Key key,
      @required this.naslovSoc,
      @required this.onPressed,
      this.bojaTipke,
      this.bojaNaslova})
      : super(key: key);

  final String naslovSoc;

  final dynamic onPressed;

  final Color bojaTipke;

  final Color bojaNaslova;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50,
        width: 230,
        child: FlatButton(
          color: bojaTipke,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.grey)),
          child: Text(
            naslovSoc,
            style: TextStyle(fontSize: 15.0, color: bojaNaslova),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
