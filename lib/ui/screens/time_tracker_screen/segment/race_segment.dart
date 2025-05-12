import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/model/participant.dart';
import 'package:race_tracker/model/race_result.dart';
import 'package:race_tracker/theme/theme.dart';
import 'package:race_tracker/ui/provider/async_values.dart';
import 'package:race_tracker/ui/provider/participant_provider.dart';
import 'package:race_tracker/ui/provider/segment_result_provider.dart';
import 'package:race_tracker/ui/provider/timer_state_provider.dart';
import 'package:race_tracker/ui/screens/time_tracker_screen/widget/bib_button.dart';
import 'package:race_tracker/ui/screens/time_tracker_screen/widget/search_bar.dart';

class RaceSegment extends StatefulWidget {
  final String segmentType;
  const RaceSegment({super.key, required this.segmentType});
  @override
  State<RaceSegment> createState() => _RaceSegmentState();
}

class _RaceSegmentState extends State<RaceSegment> {
  Timer? _timer;
  String timeDisplay = '00:00:00.00';
  List<String> preselectedBibs = [];
  List<String> confirmedBibs = [];
  Map<String, DateTime> finishTimes = {};
  Map<String, Duration> elapsedTimes = {};
  String _searchQuery = '';

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

  Color getBibColor(String bib) {
    if (confirmedBibs.contains(bib)) {
      return TrackerTheme.primary;
    } else if (preselectedBibs.contains(bib)) {
      return TrackerTheme.primary;
    } else {
      return Colors.grey[400]!;
    }
  }

  void _handleBibTap(String bib, String name) async {
    final segmentProvider = context.read<SegmentResultProvider>();
    final timerProvider = context.read<TimerStateProvider>();

    setState(() {
      if (confirmedBibs.contains(bib)) {
        return;
      }
      if (preselectedBibs.contains(bib)) {
        preselectedBibs.remove(bib);
        confirmedBibs.add(bib);
        finishTimes[bib] = DateTime.now();
        elapsedTimes[bib] = timerProvider.getElapsedTime();
        segmentProvider.addResult(
          bib,
          name,
          widget.segmentType,
          elapsedTimes[bib]!,
          finishTimes[bib]!,
        );
      } else {
        preselectedBibs.add(bib);
      }
    });
  }

  void _handleBibLongPress(String bib) async {
    if (confirmedBibs.contains(bib)) {
      final segmentProvider = context.read<SegmentResultProvider>();
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
        await segmentProvider.deleteResult(bib, widget.segmentType);
      }
    }
  }

  String getParticipantTime(String bib) {
    if (elapsedTimes.containsKey(bib)) {
      return SegmentResult.formatDuration(elapsedTimes[bib]!);
    }
    return '';
  }

  List<Participant> _getFilteredParticipants(
    List<Participant> allParticipants,
  ) {
    List<Participant> filtered =
        _searchQuery.isEmpty
            ? allParticipants
            : allParticipants.where((participant) {
              final bibMatch = participant.bibNumber.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
              return bibMatch;
            }).toList();

    // filtered.sort((a, b) {
    //   final aIsPreselected = preselectedBibs.contains(a.bibNumber);
    //   final bIsPreselected = preselectedBibs.contains(b.bibNumber);

    //   if (aIsPreselected && !bIsPreselected) return -1;
    //   if (!aIsPreselected && bIsPreselected) return 1;
    //   if (aIsPreselected && bIsPreselected) return 0;
    //   return 0;
    // });

    return filtered;
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final participantProvider = context.watch<ParticipantProvider>();
    final getParticipants = participantProvider.participants;
    final timerProvider = context.watch<TimerStateProvider>();

    Widget content;
    switch (getParticipants.state) {
      case AsyncValueState.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(child: Text('Error: ${getParticipants.error}'));
        break;
      case AsyncValueState.success:
        content = GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.8,
          children:
              _getFilteredParticipants(getParticipants.data!).map((
                participant,
              ) {
                return BibButton(
                  bib: participant.bibNumber,
                  color: getBibColor(participant.bibNumber),
                  onTap:
                      () => _handleBibTap(
                        participant.bibNumber,
                        participant.name,
                      ),
                  onLongPress: () => _handleBibLongPress(participant.bibNumber),
                  finishTime: getParticipantTime(participant.bibNumber),
                );
              }).toList(),
        );
        break;
      case AsyncValueState.empty:
        content = const Center(child: Text('No participants found.'));
        break;
    }

    return Scaffold(
      backgroundColor: TrackerTheme.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                    widget.segmentType,
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
              StreamBuilder(
                stream: timerProvider.repository.getTimerState(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final state = snapshot.data!;
                    final duration = state.getElapsedTime();
                    final hours = duration.inHours.toString().padLeft(2, '0');
                    final minutes = (duration.inMinutes % 60)
                        .toString()
                        .padLeft(2, '0');
                    final seconds = (duration.inSeconds % 60)
                        .toString()
                        .padLeft(2, '0');
                    final milliseconds = ((duration.inMilliseconds % 1000) ~/
                            10)
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
              const SizedBox(height: 16),
              SearchBibBar(onChanged: _updateSearchQuery),
              const SizedBox(height: 16),
              Expanded(child: content),
            ],
          ),
        ),
      ),
    );
  }
}