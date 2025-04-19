import 'package:flutter/material.dart';
import 'package:race_tracker/theme/theme.dart';

class TabBarCustom extends StatelessWidget {
  final List<String> tabs;

  const TabBarCustom({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(AppSpacings.radius)),
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacings.m),
        decoration: BoxDecoration(
          color: TrackerTheme.white,
          borderRadius: BorderRadius.circular(AppSpacings.radius),
        ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: TrackerTheme.primary,
            borderRadius: BorderRadius.circular(AppSpacings.radius),
          ),
          labelColor: TrackerTheme.white,
          unselectedLabelColor: TrackerTheme.primary,
          tabs: tabs.map((title) => TabBarItem(title: title)).toList(),
        ),
      ),
    );
  }
}

class TabBarItem extends StatelessWidget {
  final String title;
  const TabBarItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(title, overflow: TextOverflow.ellipsis)],
      ),
    );
  }
}
