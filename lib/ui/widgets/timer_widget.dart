// 
import 'package:flutter/material.dart';

class RaceTimer extends StatelessWidget {
  final String timeDisplay;

  const RaceTimer({super.key, required this.timeDisplay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        timeDisplay,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
