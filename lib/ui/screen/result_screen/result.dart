import 'package:flutter/material.dart';
import 'package:flutter_podium/flutter_podium.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../../model/result.dart';
import '../../../theme/theme.dart';
import 'widgets/result_table.dart';
import '../../widget/tab_bar.dart';
import 'widgets/top_rank.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Result> sampleResults = [
      Result(
        rank: 1,
        bib: "0022",
        name: "Sunly",
        swimTime: const Duration(hours: 0, minutes: 30, seconds: 25),
        cycleTime: const Duration(hours: 0, minutes: 30, seconds: 0),
        runTime: const Duration(hours: 0, minutes: 30, seconds: 0),
        overallTime: const Duration(hours: 1, minutes: 30, seconds: 25),
      ),
      Result(
        rank: 2,
        bib: "0025",
        name: "Vathana",
        swimTime: const Duration(hours: 0, minutes: 31, seconds: 10),
        cycleTime: const Duration(hours: 0, minutes: 30, seconds: 0),
        runTime: const Duration(hours: 0, minutes: 30, seconds: 0),
        overallTime: const Duration(hours: 1, minutes: 31, seconds: 10),
      ),
    ];

    Future<void> handleRefresh() async {
      await Future.delayed(const Duration(seconds: 2));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: TrackerTheme.background,
        appBar: AppBar(
          backgroundColor: TrackerTheme.background,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Result',
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
            preferredSize: const Size.fromHeight(50),
            child: TabBarCustom(tabs: const ['Standing', 'Top Rank']),
          ),
        ),
        body: TabBarView(
          children: [
            // Standing Tab
            LiquidPullToRefresh(
              onRefresh: handleRefresh,
              color: TrackerTheme.background,
              height: 200,
              backgroundColor: TrackerTheme.primary,
              animSpeedFactor: 2,
              showChildOpacityTransition: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ResultTable(results: sampleResults),
              ),
            ),

            // Top Rank Tab (Placeholder)
            const TopRank(),
          ],
        ),
      ),
    );
  }
}
