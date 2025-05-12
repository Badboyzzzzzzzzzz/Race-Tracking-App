import 'package:flutter/material.dart';
import '../../../../model/race_result.dart';
import 'result_cell.dart';
import 'result_header.dart';
import 'package:collection/collection.dart';

class ResultTable extends StatelessWidget {
  final List<SegmentResult> results;

  const ResultTable({super.key, this.results = const []});

  @override
  Widget build(BuildContext context) {
  final groupedResults = groupBy(results, (SegmentResult r) => r.bibNumber);
  final sortParticipantRank = groupedResults.entries.toList()..sort((a, b) {
      final durationA = a.value.fold(Duration.zero, (sum, r) => sum + r.elapsedTime);
      final durationB = b.value.fold(Duration.zero, (sum, r) => sum + r.elapsedTime);
      return durationA.compareTo(durationB);
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 800,
        child: Column(
          children: [
            const ResultTableHeader(),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                itemCount: sortParticipantRank.length,
                itemBuilder: (context, index) {
                  List<SegmentResult> participantSegments =
                      sortParticipantRank[index].value;
                  return ResultTableCell(
                    result: participantSegments.first,
                    allSegments: participantSegments,
                    rank: index + 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
