import 'package:race_tracker/model/race_result.dart';

abstract class SegmentResultRepository {
  Future<List<SegmentResult>> getSegmentResults();
  Future<void> addSegmentResult(
    String bibNumber,
    String name,
    String segmentName,
    Duration duration,
    DateTime finishedTime,
  );
  Future<void> deleteSegmentResult(String bibNumber, String segmentName);
}
