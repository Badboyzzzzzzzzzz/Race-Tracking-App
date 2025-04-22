import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme/theme.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: TrackerTheme.white,
      selectedItemColor: TrackerTheme.primary,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedHome11),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedTime03),
          label: 'Timing',
        ),
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedGoogleDoc),
          label: 'Results',
        ),
      ],
    );
  }
}