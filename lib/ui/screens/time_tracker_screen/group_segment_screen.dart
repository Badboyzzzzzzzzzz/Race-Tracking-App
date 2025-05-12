import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/ui/provider/timer_state_provider.dart';
import 'package:race_tracker/ui/screens/time_tracker_screen/segment/race_segment.dart';
import 'package:race_tracker/ui/widgets/custom_button.dart';
import 'package:race_tracker/ui/widgets/navigation_bar.dart';
import '../../../theme/theme.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  String timeDisplay = '00:00:00.00';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _updateDisplay();
        });
      }
    });
  }

  void _updateDisplay() {
    final timerProvider = context.read<TimerStateProvider>();
    final duration = timerProvider.getElapsedTime();
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = ((duration.inMilliseconds % 1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    setState(() {
      timeDisplay = '$hours:$minutes:$seconds.$milliseconds';
    });
  }

  Duration getCurrentElapsedTime() {
    return context.read<TimerStateProvider>().getElapsedTime();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerStateProvider>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TrackerTheme.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Race Timer Screen',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: TrackerTheme.primary,
              ),
            ),
            Image.asset('assets/images/logo.png', width: 80, height: 80),
          ],
        ),
      ),
      backgroundColor: TrackerTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: timerProvider.repository.getTimerState(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final state = snapshot.data!;
                  final duration = state.getElapsedTime();
                  final hours = duration.inHours.toString().padLeft(2, '0');
                  final minutes = (duration.inMinutes % 60).toString().padLeft(
                    2,
                    '0',
                  );
                  final seconds = (duration.inSeconds % 60).toString().padLeft(
                    2,
                    '0',
                  );
                  final milliseconds = ((duration.inMilliseconds % 1000) ~/ 10)
                      .toString()
                      .padLeft(2, '0');
                  return Text(
                    '$hours:$minutes:$seconds.$milliseconds',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return const Text(
                  '00:00:00.00',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 80,
              child: CustomButton(
                text: 'Swim',
                color: TrackerTheme.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RaceSegment(segmentType: 'swim'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 80,
              child: CustomButton(
                text: 'Cycle',
                color: TrackerTheme.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RaceSegment(segmentType: 'cycle'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 80,
              child: CustomButton(
                text: 'Run',
                color: TrackerTheme.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RaceSegment(segmentType: 'run'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navigationbar(currentIndex: 2),
    );
  }
}
