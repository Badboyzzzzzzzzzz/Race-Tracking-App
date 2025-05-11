import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:race_tracker/ui/screens/participant_management/home_page.dart';
import 'package:race_tracker/ui/screens/result_screen/result.dart';
import 'package:race_tracker/ui/screens/timeController/timer_controller.dart';
import 'package:race_tracker/ui/screens/time_tracker_screen/group_segment_screen.dart';

import '../../theme/theme.dart';

// ignore_for_file: file_names, deprecated_member_use

class Navigationbar extends StatelessWidget {
  const Navigationbar({super.key, this.currentIndex = 0});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TrackerTheme.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: NavigationBar(
        height: 70,
        elevation: 0,

        selectedIndex: currentIndex,
        backgroundColor: Colors.white,
        indicatorColor: TrackerTheme.primary.withOpacity(
          0.1,
        ), // Change indicator color from purple to light blue
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(
              HugeIcons.strokeRoundedHome11,
              color: currentIndex == 0 ? Colors.blue : Colors.grey,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(HugeIcons.strokeRoundedTime03),
            label: 'Time Controller',
          ),
          NavigationDestination(
            icon: Icon(
              HugeIcons.strokeRoundedGameController01,
              color: currentIndex == 1 ? Colors.blue : Colors.grey,
            ),
            label: 'Race Control',
          ),
          NavigationDestination(
            icon: Icon(
              HugeIcons.strokeRoundedGoogleDoc,
              color: currentIndex == 2 ? Colors.blue : Colors.grey,
            ),
            label: 'Results',
          ),
        ],
        onDestinationSelected: (int index) {
          if (index == currentIndex) return;

          switch (index) {
            case 0:
              if (currentIndex != 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParticipantManagementScreen(),
                  ),
                );
              }
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TimerController(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimerScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResultScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}
