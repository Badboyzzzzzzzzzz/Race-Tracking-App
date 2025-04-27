import 'package:flutter/material.dart';

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
