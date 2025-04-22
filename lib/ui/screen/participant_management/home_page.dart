import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              'Race Timer',
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
      body: const Center(child: Text('Participant Management Coming Soon')),
    );
  }
}
