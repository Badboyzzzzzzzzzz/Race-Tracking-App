// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/theme/theme.dart';
import 'package:race_tracker/ui/provider/async_values.dart';
import 'package:race_tracker/ui/provider/participant_provider.dart';
import 'package:race_tracker/ui/provider/race_status_provider.dart';
import 'package:race_tracker/ui/provider/segment_result_provider.dart';
// import 'package:race_tracker/ui/screens/time_tracker_screen/time_tracker_screen.dart';
import 'package:race_tracker/ui/screens/time_tracker_screen/widget/search_bar.dart';
import 'package:race_tracker/ui/widgets/custom_button.dart';

class SwimSegment extends StatefulWidget {
  const SwimSegment({super.key});

  @override
  State<SwimSegment> createState() => _SwimSegmentScreenState();
}

class _SwimSegmentScreenState extends State<SwimSegment> {
  List<String> preselectedBibs = [];
  List<String> confirmedBibs = [];
  Map<String, DateTime> finishTimes = {};
  Map<String, Duration> elapsedTimes = {};

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _timeDisplay = '00:00:00.00';

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Load existing swim segment results and status
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final segmentProvider = context.read<SegmentResultProvider>();
      final raceStatusProvider = context.read<RaceStatusProvider>();

      // Load segment results
      await segmentProvider.fetchSegmentResults('swim');

      // Load race status
      await raceStatusProvider.loadSegmentStatus('swim');
      final status = raceStatusProvider.currentStatus;

      if (status != null) {
        setState(() {
          if (status.startTime != null) {
            // Calculate elapsed time since start
            final now = DateTime.now();
            final elapsed = now.difference(status.startTime!);
            // Reset and start stopwatch, then let it run for the elapsed duration
            _stopwatch.reset();
            _stopwatch.start();
            while (_stopwatch.elapsed < elapsed) {
              // Wait until we reach the correct elapsed time
            }
          }

          if (status.isCompleted) {
            _stopwatch.stop();
          }
        });
      }
    });
  }

  Color getBibColor(String bib) {
    if (confirmedBibs.contains(bib)) {
      return TrackerTheme.primary;
    } else if (preselectedBibs.contains(bib)) {
      return TrackerTheme.primary; // Blue when selected
    } else {
      return Colors.grey[400]!; // Light grey when not selected
    }
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

  void _handleBibTap(String bib) async {
    final segmentProvider = context.read<SegmentResultProvider>();

    setState(() {
      if (confirmedBibs.contains(bib)) {
        // If already confirmed, do nothing on tap
        return;
      }
      if (preselectedBibs.contains(bib)) {
        // Second tap → confirm and save result
        preselectedBibs.remove(bib);
        confirmedBibs.add(bib);
        finishTimes[bib] = DateTime.now();
        elapsedTimes[bib] = _stopwatch.elapsed;
        // Save the result to Firebase
        segmentProvider.addResult(bib, 'swim', _stopwatch.elapsed);
      } else {
        // First tap → preselect
        preselectedBibs.add(bib);
      }
    });
  }

  void _handleBibLongPress(String bib) async {
    if (confirmedBibs.contains(bib)) {
      final segmentProvider = context.read<SegmentResultProvider>();

      // Show confirmation dialog
      final shouldUntrack = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              backgroundColor: TrackerTheme.white,
              title: const Text('Untrack Participant'),
              content: Text('Are you sure you want to untrack BIB $bib?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: TrackerTheme.red,
                  ),
                  child: const Text('Untrack'),
                ),
              ],
            ),
      );

      if (shouldUntrack == true) {
        setState(() {
          confirmedBibs.remove(bib);
          finishTimes.remove(bib);
          elapsedTimes.remove(bib);
        });

        // Delete the result from Firebase
        await segmentProvider.deleteResult(bib, 'swim');
      }
    }
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
    final participantProvider = context.watch<ParticipantProvider>();
    final getParticipants = participantProvider.participants;
    final raceStatusProvider = context.watch<RaceStatusProvider>();
    final segmentProvider = context.watch<SegmentResultProvider>();
    final results = segmentProvider.segmentResults;

    // Restore confirmed bibs from segment results
    if (results.state == AsyncValueState.success && confirmedBibs.isEmpty) {
      for (var result in results.data!) {
        confirmedBibs.add(result.bibNumber);
      }
    }

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
                    'Swim',
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
              SearchBibBar(),
              const SizedBox(height: 16),

              // BIB numbers
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.8,
                  children:
                      getParticipants.data!.map((bib) {
                        return BibButton(
                          bib: bib.bibNumber,
                          color: getBibColor(bib.bibNumber),
                          onTap: () => _handleBibTap(bib.bibNumber),
                          onLongPress: () => _handleBibLongPress(bib.bibNumber),
                          finishTime: getParticipantTime(bib.bibNumber),
                        );
                      }).toList(),
                ),
              ),

              // Bottom buttons
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Start Race',
                color: TrackerTheme.primary,
                onPressed: () async {
                  if (!_stopwatch.isRunning) {
                    await raceStatusProvider.startSegment('swim');
                    setState(() {
                      _stopwatch.start();
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                text: 'Finished',
                color: TrackerTheme.grey,
                onPressed: () async {
                  await raceStatusProvider.completeSegment('swim');
                  setState(() {
                    _stopwatch.stop();
                    _updateDisplay();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BibButton extends StatelessWidget {
  final String bib;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String finishTime;

  const BibButton({
    super.key,
    required this.bib,
    required this.color,
    required this.onTap,
    required this.onLongPress,
    this.finishTime = '',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      onLongPress: onLongPress,
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
