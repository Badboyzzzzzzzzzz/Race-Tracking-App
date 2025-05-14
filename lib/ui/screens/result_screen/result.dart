import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/ui/provider/async_values.dart';
import 'package:race_tracker/ui/provider/segment_result_provider.dart';
import 'package:race_tracker/ui/screens/result_screen/widget/result_table.dart';
import 'package:race_tracker/ui/widgets/navigation_bar.dart';
import '../../../theme/theme.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final segmentResult = context.watch<SegmentResultProvider>().segmentResults;

    Future<void> handleRefresh() async {
      await context.read<SegmentResultProvider>().fetchSegmentResults();
    }

    Widget result;
    switch (segmentResult.state) {
      case AsyncValueState.loading:
        result = const Center(child: Text('Loading...'));
        break;
      case AsyncValueState.error:
        result = const Center(child: Text('No connection. Try later'));
        break;
      case AsyncValueState.empty:
        result = const Center(
          child: Text('Do not have the result Cuz the race have not start yet'),
        );
        break;
      case AsyncValueState.success:
        result = Padding(
          padding: const EdgeInsets.all(16.0),
          child: ResultTable(results: segmentResult.data!),
        );
    }

    return Scaffold(
      backgroundColor: TrackerTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      ),
      body: LiquidPullToRefresh(
        onRefresh: handleRefresh,
        color: TrackerTheme.background,
        height: 200,
        backgroundColor: TrackerTheme.primary,
        animSpeedFactor: 2,
        showChildOpacityTransition: false,
        child: result,
      ),
      bottomNavigationBar: Navigationbar(currentIndex: 3),
    );
  }
}
