import 'package:flutter/material.dart';
import 'package:race_tracker/theme/theme.dart';

class AddParticipantsButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AddParticipantsButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: TrackerTheme.primary,
        elevation: 0,
        minimumSize: const Size(68, 42),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // add left margin here
          Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.add,
              size: 16,
              color: TrackerTheme.primary,
            ),
          ),

          const SizedBox(width: 4),

          // Label Add
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Text(
              label,
              style: TextStyle(
                color: TrackerTheme.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}