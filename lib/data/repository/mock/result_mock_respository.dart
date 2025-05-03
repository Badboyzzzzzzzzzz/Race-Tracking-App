// import 'dart:async';
// import 'package:race_tracker/data/dummy/result.dart';
// import 'package:race_tracker/data/repository/segment_result_repository.dart';
// import 'package:race_tracker/model/race_result.dart';

// class MockSegmentResultRepository implements SegmentResultRepository {
//   final List<SegmentResult> _segmentResults = segmentResults;
//   @override
//   Future<List<SegmentResult>> getSegmentResults(String segmentName) async {
//     return _segmentResults
//         .where((result) => result.segmentName == segmentName)
//         .toList();
//   }

//   @override
//   Future<List<SegmentResult>> getParticipantResults(String bibNumber) async {
//     return _segmentResults
//         .where((result) => result.bibNumber == bibNumber)
//         .toList();
//   }

//   @override
//   Future<void> addSegmentResult(
//     String bibNumber,
//     String name,
//     String segmentName,
//     Duration duration,
//   ) async {
//     _segmentResults.add(
//       SegmentResult(
//         id: bibNumber,
//         bibNumber: bibNumber,
//         name: name,
//         segmentName: segmentName,
//         duration: duration,
//       ),
//     );
//   }

//   @override
//   Future<void> deleteSegmentResult(String bibNumber, String segmentName) async {
//     _segmentResults.removeWhere(
//       (result) => result.bibNumber == bibNumber && result.segmentName == segmentName,
//     );
//   }
//   @override
//   Future<SegmentResult?> getSpecificResult(
//     String bibNumber,
//     String segmentName,
//   ) async {
//     return _segmentResults.firstWhere(
//       (result) =>
//           result.bibNumber == bibNumber && result.segmentName == segmentName,
//     );
//   }
// }
