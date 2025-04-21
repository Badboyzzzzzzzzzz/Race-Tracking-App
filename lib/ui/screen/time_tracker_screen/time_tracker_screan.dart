import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../widget/tab_bar.dart';
import '../../widget/navigation_bar.dart';

class TimeTrackerScreen extends StatefulWidget {
  const TimeTrackerScreen({super.key});

  @override
  State<TimeTrackerScreen> createState() => _TimeTrackerScreenState();
}

class _TimeTrackerScreenState extends State<TimeTrackerScreen> {
  final List<String> _tabs = ['Swim', 'Cycle', 'Run'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: TabBarCustom(tabs: _tabs),
          ),
        ),
        body: TabBarView(
          children: const [
            Center(child: Text('Swim')),
            Center(child: Text('Cycle')),
            Center(child: Text('Run')),
          ],
        ),
        bottomNavigationBar: const CustomNavigationBar(),
      ),
    );
  }
}
