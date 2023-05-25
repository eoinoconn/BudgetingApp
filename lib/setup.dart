import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

Future<bool> checkSetupComplete() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('setupComplete') ?? false;
}

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Perform Setup'),
          onPressed: () {
            // Perform setup tasks
            completeSetup(context);

            // Navigate to the main app
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainApp()),
            );
          },
        ),
      ),
    );
  }

  void completeSetup(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setupComplete', true);
  }
}
