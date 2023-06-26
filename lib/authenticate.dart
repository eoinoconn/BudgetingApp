import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'https://www.googleapis.com/auth/drive',
  'https://www.googleapis.com/auth/spreadsheets'
];

Future<GoogleSignInAccount?> authenticate(BuildContext context) async {
  return _googleSignIn.signIn();
}

final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId:
      '217285692249-i5fe9iq28vcjui3k08ulomkf2essmjlq.apps.googleusercontent.com',
  scopes: scopes,
);
