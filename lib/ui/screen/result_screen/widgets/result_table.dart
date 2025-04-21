import 'package:flutter/material.dart';
import '../../../../model/result.dart';
import 'result_cell.dart';
import 'result_header.dart';

class ResultTable extends StatelessWidget {
  final List<Result> results;

  const ResultTable({super.key, this.results = const []});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 800,
        child: Column(
          children: [
            const ResultTableHeader(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return ResultTableCell(result: results[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
