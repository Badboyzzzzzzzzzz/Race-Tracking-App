import 'package:flutter/material.dart';
import 'package:race_tracker/ui/widget/custom_button.dart';
import 'package:race_tracker/theme/theme.dart';

class TimeTrackerScreen extends StatelessWidget {
  const TimeTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TrackerTheme.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button to start the race
            CustomButton(
              text: "Start Race",
              color: TrackerTheme.primary,
              onPressed: () {
                print("Race Started");
              },
            ),
            const SizedBox(width: 20),

            // Button to Finish the race
            CustomButton(
              text: "Finished",
              color: TrackerTheme.red,
              onPressed: () {
                print("Race Finished");
              },
            ),
          ],
        ),
      ),
    );
  }
}
