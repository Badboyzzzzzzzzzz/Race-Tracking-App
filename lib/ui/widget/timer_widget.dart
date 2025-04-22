import 'dart:async';
import 'package:flutter/material.dart';
import 'package:race_tracker/theme/theme.dart';
import 'custom_button.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  int _elapsedCs = 0;

  // Start Race
  void _start() {
    if (_timer?.isActive ?? false) return;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      setState(() => _elapsedCs++);
    });
  }

  // Finish Race
  void _finish() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final cs = (_elapsedCs % 100).toString().padLeft(2, '0');
    final totalSec = _elapsedCs ~/ 100;
    final s = (totalSec % 60).toString().padLeft(2, '0');
    final totalMin = totalSec ~/ 60;
    final m = (totalMin % 60).toString().padLeft(2, '0');
    final h = (totalMin ~/ 60).toString().padLeft(2, '0');
    return '$h:$m:$s.$cs';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatted,
          style: TextStyle(
            fontSize: AppTextStyles.heading.fontSize,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Start Button
            CustomButton(
              text: 'Start Race',
              color: TrackerTheme.primary,
              onPressed: _start,
            ),
            const SizedBox(width: 12),

            // Finish Button
            CustomButton(
              text: 'Finished',
              color: TrackerTheme.red, 
              onPressed: _finish,
            ),
          ],
        ),
      ],
    );
  }
}