import 'package:flutter/material.dart';

import '../../../../model/result.dart';
import '../../../../theme/theme.dart';

class ResultTableCell extends StatelessWidget {
  final Result result;

  const ResultTableCell({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
          _resultCell(result.rank.toString().padLeft(2, '0'), flex: 1),
          _resultCell(result.bib.padLeft(4, '0'), flex: 1),
          _resultCell(result.name, flex: 2),
          _resultCell(Result.formatDuration(result.swimTime), flex: 2),
          _resultCell(Result.formatDuration(result.cycleTime), flex: 2),
          _resultCell(Result.formatDuration(result.runTime), flex: 2),
          _resultCell(Result.formatDuration(result.overallTime), flex: 2),
        ],
      ),
    );
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
}