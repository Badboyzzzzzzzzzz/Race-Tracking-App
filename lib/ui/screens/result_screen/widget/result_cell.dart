// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../model/race_result.dart';
import '../../../../theme/theme.dart';

class ResultTableCell extends StatelessWidget {
  final SegmentResult result;
  final List<SegmentResult> allSegments;
  final int rank;
  const ResultTableCell({
    super.key,
    required this.result,
    required this.allSegments,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: TrackerTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _resultCell(rank.toString(), flex: 1),
          _resultCell(result.bibNumber.padLeft(4, '0'), flex: 1),
          _resultCell(result.name, flex: 2),
          _resultCell(_getSwimTime(), flex: 2),
          _resultCell(_getCycleTime(), flex: 2),
          _resultCell(_getRunTime(), flex: 2),
          _resultCell(_getOverallTime(), flex: 2),
        ],
      ),
    );
  }

  SegmentResult? _getSegmentByName(String segmentName) {
    return allSegments.firstWhere(
      (segment) => segment.segmentName == segmentName,
      orElse: () => result,
    );
  }

  String _getSwimTime() {
    final swimSegment = _getSegmentByName('swim');
    if (swimSegment != null && swimSegment.segmentName == 'swim') {
      return SegmentResult.formatDuration(swimSegment.elapsedTime);
    }
    return "--:--";
  }

  String _getCycleTime() {
    final cycleSegment = _getSegmentByName('cycle');
    if (cycleSegment != null && cycleSegment.segmentName == 'cycle') {
      return SegmentResult.formatDuration(cycleSegment.elapsedTime);
    }
    return "--:--";
  }

  String _getRunTime() {
    final runSegment = _getSegmentByName('run');
    if (runSegment != null && runSegment.segmentName == 'run') {
      return SegmentResult.formatDuration(runSegment.elapsedTime);
    }
    return "--:--";
  }

  String _getOverallTime() {
    Duration totalDuration = Duration.zero;
    for (final segment in allSegments) {
      totalDuration += segment.elapsedTime;
    }
    return SegmentResult.formatDuration(totalDuration);
  }
}

Widget _resultCell(String text, {int flex = 1}) {
  return Expanded(
    flex: flex,
    child: Text(
      text,
      style: TextStyle(
        color: TrackerTheme.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
