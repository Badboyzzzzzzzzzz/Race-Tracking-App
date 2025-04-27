import 'package:flutter/material.dart';
import 'package:race_tracker/ui/widgets/navigation_bar.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: Navigationbar(currentIndex: 2),
    );
  }
}