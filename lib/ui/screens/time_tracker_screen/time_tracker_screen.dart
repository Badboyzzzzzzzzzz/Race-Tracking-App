// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:race_tracker/ui/widgets/custom_button.dart';
import 'package:race_tracker/ui/widgets/timer_widget.dart';

class TimeTrackingScreen extends StatefulWidget {
  const TimeTrackingScreen({super.key});

  @override
  State<TimeTrackingScreen> createState() => _TimeTrackingScreenState();
}

class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
  String _selectedSegment = '';
  Set<String> preselectedBibs = {};
  Set<String> confirmedBibs = {};
  Map<String, DateTime> finishTimes = {};
  Map<String, Duration> elapsedTimes = {};

  final TextEditingController _searchController = TextEditingController();
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
      return Colors.orange; // In progress - green
    } else {
      return Colors.grey; // Not started - orange
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
    _searchController.dispose();
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
        // Already confirmed
        return;
      }
      if (preselectedBibs.contains(bib)) {
        // Second tap → confirm
        preselectedBibs.remove(bib);
        confirmedBibs.add(bib);
        print('Confirmed: $bib');
        // Capture finish time and elapsed duration
        finishTimes[bib] = DateTime.now();
        elapsedTimes[bib] = _stopwatch.elapsed;
        print('Confirmed: $bib - Time: ${_formatDuration(elapsedTimes[bib]!)}');
      } else {
        // First tap → preselect
        preselectedBibs.add(bib);
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = threeDigits(duration.inMilliseconds.remainder(1000));

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Timer',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),

              // Segment selector
              Row(
                children: [
                  SegmentButton(
                    label: 'swim',
                    isSelected: _selectedSegment == 'swim',
                    onTap: () => setState(() => _selectedSegment = 'swim'),
                  ),
                  SegmentButton(
                    label: 'cycle',
                    isSelected: _selectedSegment == 'cycle',
                    onTap: () => setState(() => _selectedSegment = 'cycle'),
                  ),
                  SegmentButton(
                    label: 'run',
                    isSelected: _selectedSegment == 'run',
                    onTap: () => setState(() => _selectedSegment = 'run'),
                  ),
                ],
              ),

              // Timer display
              RaceTimer(timeDisplay: _timeDisplay),

              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search BIB Number',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),

              // BIB number grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.5,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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

              // Start and Finish buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Start Race',
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          if (!_stopwatch.isRunning) {
                            _stopwatch.start();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: 'Finished',
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          _stopwatch.stop();
                          _stopwatch.reset();
                          _updateDisplay();
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class SegmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SegmentButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
            foregroundColor: isSelected ? Colors.white : Colors.black,
          ),
          onPressed: onTap,
          child: Text(label[0].toUpperCase() + label.substring(1)),
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
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
          elevation: 2,
        ),
        child: Text(
          bib,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
