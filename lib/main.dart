import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/data/repository/firebase/segment_result_firebase_repository.dart';
import 'package:race_tracker/data/repository/firebase/timer_state_firebase_repository.dart';
import 'package:race_tracker/data/repository/firebase/participant_firebase_repository.dart';
import 'package:race_tracker/firebase_options.dart';
import 'package:race_tracker/ui/provider/participant_provider.dart';
import 'package:race_tracker/ui/provider/segment_result_provider.dart';
import 'package:race_tracker/ui/provider/timer_state_provider.dart';
import 'package:race_tracker/ui/screens/participant_management/participant_management.dart';

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
              (context) => SegmentResultProvider(
                repository: SegmentResultRepositoryFirebase(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => TimerStateProvider(
                repository: FirebaseTimerStateRepository(),
              ),
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
      home: const ParticipantManagementScreen(),
    );
  }
}
