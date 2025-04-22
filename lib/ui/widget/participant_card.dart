import 'package:flutter/material.dart';
import 'package:race_tracker/theme/theme.dart';

class ParticipantCard extends StatelessWidget {
  final String id;
  final String name;
  final VoidCallback onDelete;

  const ParticipantCard({
    super.key,
    required this.id,
    required this.name,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding around content
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: TrackerTheme.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: TrackerTheme.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // ID
          SizedBox(
            width: 48,
            child: Text(
              id,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          // Name (centered)
          Expanded(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          // Delete icon
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: TrackerTheme.red,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
