import 'package:flutter/material.dart';
import 'views/setup.dart';
import 'views/trip_summary.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const SetupView(), routes: {
      '/setup/': (context) => const LoginView(),
      '/trip_summary/': (context) => const TripSummary(),
    });
  }
}
