import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../widget/custom_button.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TrackerTheme.background,
      appBar: AppBar(
        backgroundColor: TrackerTheme.background,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Timer',
              style: AppTextStyles.heading.copyWith(
                color: TrackerTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: kToolbarHeight,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: CustomButton(
                    text: 'Swim',
                    color: TrackerTheme.primary,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: AppSpacings.l),
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: CustomButton(
                    text: 'Cycle',
                    color: TrackerTheme.primary,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: AppSpacings.l),
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: CustomButton(
                    text: 'Run',
                    color: TrackerTheme.primary,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
