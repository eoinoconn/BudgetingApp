import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'views/setup.dart';
import 'package:http/http.dart' as http;

Future<AuthClient> establishClient() async {
  GoogleSignInAccount user = googleSignIn.currentUser!;

  var userAuth = await user.authentication;
  var token = userAuth.accessToken;
  if (token == null) {
    throw Exception('Access token is null');
  }
  var expiry = DateTime.now().add(const Duration(days: 10)).toUtc();
  var accessToken = AccessToken('Bearer', token, expiry);

  var access = AccessCredentials(accessToken, null, scopes);

  return authenticatedClient(http.Client(), access);
}
