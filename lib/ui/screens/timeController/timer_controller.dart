import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/model/race_status.dart';
import 'package:race_tracker/ui/provider/timer_state_provider.dart';
import 'package:race_tracker/ui/widgets/custom_button.dart';
import 'package:race_tracker/ui/widgets/navigation_bar.dart';
import '../../../theme/theme.dart';

class TimerController extends StatefulWidget {
  const TimerController({super.key});

  @override
  State<TimerController> createState() => _TimerControllerState();
}

class _TimerControllerState extends State<TimerController> {
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

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerStateProvider>();
    final isRunning = timerProvider.currentState?.isRunning ?? false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 128),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: isRunning ? 'Pause' : 'Start Race',
                    color: TrackerTheme.primary,
                    onPressed: () {
                      if (isRunning) {
                        timerProvider.stopTimer();
                      } else {
                        timerProvider.startTimer();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: 'Reset',
                    color: TrackerTheme.grey,
                    onPressed: () {
                      if (isRunning) {
                        timerProvider.stopTimer();
                      }
                      // Reset the timer state
                      final initialState = TimerState(
                        isRunning: false,
                        startTime: DateTime.now(),
                        stopTime: null,
                      );
                      timerProvider.repository.updateTimerState(initialState);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navigationbar(currentIndex: 1),
    );
  }
}
