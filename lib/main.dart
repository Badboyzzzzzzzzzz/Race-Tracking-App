import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/data/repository/firebase/participant_firebase.dart';
import 'package:race_tracker/data/repository/firebase/race_status_firebase.dart';
import 'package:race_tracker/data/repository/firebase/segment_result_firebase.dart';
import 'package:race_tracker/firebase_options.dart';
import 'package:race_tracker/ui/provider/participant_provider.dart';
import 'package:race_tracker/ui/provider/race_status_provider.dart';
import 'package:race_tracker/ui/provider/segment_result_provider.dart';
import 'package:race_tracker/ui/screens/time_tracker_screen/group_segment_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (context) => ParticipantProvider(
                participantRepository: ParticipantRepositoryFirebase(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  SegmentResultProvider(SegmentResultRepositoryFirebase()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => RaceStatusProvider(RaceStatusRepositoryFirebase()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Race Timer',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TimerScreen(),
    );
  }
}
