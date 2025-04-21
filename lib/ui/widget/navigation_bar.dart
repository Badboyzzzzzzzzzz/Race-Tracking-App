import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: TrackerTheme.white,
      selectedItemColor: TrackerTheme.primary,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.watch_later_outlined),
          label: 'Timing',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Results'),
      ],
    );
  }
}
