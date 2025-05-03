import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/time_tracker_screen/segment/cycle_segment.dart';
import 'package:race_tracker/ui/screens/time_tracker_screen/segment/run_segment.dart';
import 'package:race_tracker/ui/screens/time_tracker_screen/segment/swim_segment.dart';
import 'package:race_tracker/ui/widgets/custom_button.dart';
import 'package:race_tracker/ui/widgets/navigation_bar.dart';
import '../../../theme/theme.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TrackerTheme.background,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: TrackerTheme.background,
      //   elevation: 0,
      //   title: Padding(
      //     padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Text(
      //           'Race Timer Screen',
      //           style: TextStyle(
      //             fontSize: 24,
      //             fontWeight: FontWeight.bold,
      //             color: TrackerTheme.primary,
      //           ),
      //         ),
      //         Image.asset('assets/images/logo.png', width: 100, height: 100),
      //       ],
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Race Timer Screen',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: TrackerTheme.primary,
                    ),
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacings.l),
              const SizedBox(height: AppSpacings.l),
              const SizedBox(height: AppSpacings.l),
              const SizedBox(height: AppSpacings.l),
              const SizedBox(height: AppSpacings.l),

              SizedBox(
                width: double.infinity,
                height: 80,
                child: CustomButton(
                  text: 'Swim',
                  color: TrackerTheme.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SwimSegment()),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacings.l),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: CustomButton(
                  text: 'Cycle',
                  color: TrackerTheme.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CycleSegment()),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacings.l),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: CustomButton(
                  text: 'Run',
                  color: TrackerTheme.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RunSegment()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Navigationbar(currentIndex: 1),
    );
  }
}
