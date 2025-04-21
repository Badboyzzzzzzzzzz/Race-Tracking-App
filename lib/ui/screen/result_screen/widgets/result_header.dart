import 'package:flutter/material.dart';

import '../../../../theme/theme.dart';

class ResultTableHeader extends StatelessWidget {
  const ResultTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: TrackerTheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _headerCell('Rank', flex: 1),
          _headerCell('BIB', flex: 1),
          _headerCell('Name', flex: 2),
          _headerCell('Swim', flex: 2),
          _headerCell('Cycle', flex: 2),
          _headerCell('Run', flex: 2),
          _headerCell('Overall', flex: 2),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
