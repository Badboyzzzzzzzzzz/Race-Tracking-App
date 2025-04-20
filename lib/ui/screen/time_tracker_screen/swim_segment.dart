import 'package:flutter/material.dart' hide SearchBar;
import 'package:custom_timer/custom_timer.dart';
import 'widgets/search_bar.dart';

import '../../../theme/theme.dart';

class SwimSegment extends StatefulWidget {
  const SwimSegment({super.key});

  @override
  State<SwimSegment> createState() => _SwimSegmentState();
}

class _SwimSegmentState extends State<SwimSegment>
    with SingleTickerProviderStateMixin {
  late CustomTimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomTimerController(
      vsync: this,
      begin: const Duration(hours: 0),
      end: const Duration(hours: 24),
      initialState: CustomTimerState.reset,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacings.xxl),
        CustomTimer(
          controller: _controller,
          builder: (state, time) {
            return Text(
              "${time.hours}:${time.minutes}:${time.seconds}:${time.milliseconds}",
              style: AppTextStyles.heading,
            );
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _controller.start(),
              style: ElevatedButton.styleFrom(
                backgroundColor: TrackerTheme.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Start',
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => _controller.pause(),
              style: ElevatedButton.styleFrom(
                backgroundColor: TrackerTheme.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Pause',
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => _controller.reset(),
              style: ElevatedButton.styleFrom(
                backgroundColor: TrackerTheme.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Reset',
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacings.xxl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchBar(),
        ),
      ],
    );
  }
}
