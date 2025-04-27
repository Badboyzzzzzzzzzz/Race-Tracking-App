import 'package:race_tracker/model/segment_result.dart';

abstract class SegmentResultRepository {
  Future<List<SegmentResult>> getSegmentResults(String segmentName);
  Future<List<SegmentResult>> getParticipantResults(String bibNumber);
  Future<void> addSegmentResult(
    String bibNumber,
    String segmentName,
    Duration duration,
  );
  Future<void> deleteSegmentResult(String bibNumber, String segmentName);
  Future<SegmentResult?> getSpecificResult(
    String bibNumber,
    String segmentName,
  );
}
