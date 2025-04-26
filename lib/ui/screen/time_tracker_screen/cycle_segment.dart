import 'dart:async';
import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class CycleSegment extends StatefulWidget {
  const CycleSegment({super.key});

  @override
  State<CycleSegment> createState() => _CycleSegmentState();
}

class _CycleSegmentState extends State<CycleSegment> {
  Set<String> preselectedBibs = {};
  Set<String> confirmedBibs = {};
  Map<String, DateTime> finishTimes = {};
  Map<String, Duration> elapsedTimes = {};

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _timeDisplay = '00:00:00.00';

  final List<String> _bibNumbers = [
    '0001',
    '0002',
    '0003',
    '0004',
    '0005',
    '0006',
    '0007',
    '0008',
    '0009',
    '0010',
  ];

  Color getBibColor(String bib) {
    if (confirmedBibs.contains(bib)) {
      return Colors.green;
    } else if (preselectedBibs.contains(bib)) {
      return TrackerTheme.primary; // Blue when selected
    } else {
      return Colors.grey[400]!; // Light grey when not selected
    }
  }

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
      if (_stopwatch.isRunning) {
        setState(() {
          _updateDisplay();
        });
      }
    });
  }

  void _updateDisplay() {
    final duration = _stopwatch.elapsed;
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = ((duration.inMilliseconds % 1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    _timeDisplay = '$hours:$minutes:$seconds.$milliseconds';
  }

  void _handleBibTap(String bib) {
    setState(() {
      if (confirmedBibs.contains(bib)) {
        return;
      }
      if (preselectedBibs.contains(bib)) {
        preselectedBibs.remove(bib);
        confirmedBibs.add(bib);
        finishTimes[bib] = DateTime.now();
        elapsedTimes[bib] = _stopwatch.elapsed;
      } else {
        preselectedBibs.add(bib);
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitsMs(int n) => (n ~/ 10).toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = twoDigitsMs(duration.inMilliseconds.remainder(1000));

    return '$hours:$minutes:$seconds.$milliseconds';
  }

  String getParticipantTime(String bib) {
    if (elapsedTimes.containsKey(bib)) {
      return _formatDuration(elapsedTimes[bib]!);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TrackerTheme.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Cycle',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: TrackerTheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Timer
              Text(
                _timeDisplay,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Search bar
              //SearchBibBar(),
              const SizedBox(height: 16),

              // BIB numbers
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.8,
                  children:
                      _bibNumbers.map((bib) {
                        return BibButton(
                          bib: bib,
                          color: getBibColor(bib),
                          onTap: () => _handleBibTap(bib),
                          finishTime: getParticipantTime(bib),
                        );
                      }).toList(),
                ),
              ),

              // Bottom buttons
              Row(
                children: [
                  // Expanded(
                  //   child: CustomButton(
                  //     text: 'Start Race',
                  //     color: TrackerTheme.primary,
                  //     onPressed: () {
                  //       if (!_stopwatch.isRunning) {
                  //         _stopwatch.start();
                  //       }
                  //     },
                  //   ),
                  // ),
                  const SizedBox(width: 10),
                  // Expanded(
                  //   child: CustomButton(
                  //     text: 'Finished',
                  //     color: Colors.grey,
                  //     onPressed: () {
                  //       _stopwatch.stop();
                  //       _updateDisplay();
                  //       setState(() {});
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BibButton extends StatelessWidget {
  final String bib;
  final Color color;
  final VoidCallback onTap;
  final String finishTime;

  const BibButton({
    super.key,
    required this.bib,
    required this.color,
    required this.onTap,
    this.finishTime = '',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.zero,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            bib,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (finishTime.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              finishTime,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
