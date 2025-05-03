import 'package:flutter/material.dart';
import 'package:race_tracker/theme/theme.dart';

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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: TrackerTheme.white,
            ),
          ),
          if (finishTime.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              finishTime,
              style: TextStyle(fontSize: 12, color: TrackerTheme.white),
            ),
          ],
        ],
      ),
    );
  }
}
