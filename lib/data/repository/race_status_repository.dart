import 'package:race_tracker/model/race_status.dart';

abstract class RaceStatusRepository {
  Future<RaceStatus?> getSegmentStatus(String segmentName);
  Future<void> startSegment(String segmentName);
  Future<void> completeSegment(String segmentName);
  Future<bool> isSegmentCompleted(String segmentName);
}
