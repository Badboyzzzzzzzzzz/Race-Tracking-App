import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:race_tracker/firebase_options.dart';
import 'package:race_tracker/ui/screens/time_tracker_screen/time_tracker_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Race Timer',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: Text(''),
    );
  }
}
