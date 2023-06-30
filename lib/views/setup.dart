import 'package:budgeting_app/views/trip_summary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'https://www.googleapis.com/auth/drive.file',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  clientId:
      //'217285692249-p20u6t798fnb08qi13t854kakdt3arjv.apps.googleusercontent.com', // Android
      '217285692249-i5fe9iq28vcjui3k08ulomkf2essmjlq.apps.googleusercontent.com', // Web
  scopes: scopes,
);

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
      // However, in the web...
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });
    });
  }

  // This is the on-click handler for the Sign In button that is rendered by Flutter.
  //
  // On the web, the on-click handler of the Sign In button is owned by the JS
  // SDK, so this method can be considered mobile only.
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  // Prompts the user to authorize `scopes`.
  //
  // This action is **required** in platforms that don't perform Authentication
  // and Authorization at the same time (like the web).
  //
  // On the web, this must be called from an user interaction (button click).
  Future<void> _handleAuthorizeScopes() async {
    final bool isAuthorized = await _googleSignIn.requestScopes(scopes);
    setState(() {
      _isAuthorized = isAuthorized;
    });
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    // Sign in user if not already signed in
    if (_currentUser == null) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Setup'),
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You are not signed in.'),
              ElevatedButton(
                onPressed: _handleSignIn,
                child: const Text('Sign In'),
              ),
            ],
          )));
    } else if (!_isAuthorized) {
      // If user is signed in but not authorized, prompt for authorization
      return Scaffold(
          appBar: AppBar(
            title: const Text('Setup'),
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You are not authorized.'),
              ElevatedButton(
                onPressed: _handleAuthorizeScopes,
                child: const Text('Authorize'),
              ),
            ],
          )));
    } else {
      // User is signed in and authorized, navigate to TripSummary
      return const TripSummary();
    }
  }
}

class SetupView extends StatelessWidget {
  const SetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if user is signed in and has correct scopes.
    // If so, navigate to TripSummary
    return FutureBuilder(
        future: _googleSignIn.isSignedIn(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data ?? false) {
                // Logged in, go to TripSummary
                return const TripSummary();
              } else {
                // Not logged in, go to SetupPage
                return const LoginView();
              }
            default:
              return const Scaffold(
                body: Column(
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              );
          }
        });
  }
}
