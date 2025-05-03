import 'package:race_tracker/model/race_result.dart';

class SegmentResultDto {
  static SegmentResult fromJson(String id, Map<String, dynamic> json) {
    return SegmentResult(
      id: id,
      bibNumber: json['bibNumber'] as String,
      segmentName: json['segmentName'] as String,
      duration: Duration(microseconds: json['duration'] as int),
      name: json['name'] as String,
    );
  }

  static Map<String, dynamic> toJson(SegmentResult segmentResult) {
    return {
      'bibNumber': segmentResult.bibNumber,
      'segmentName': segmentResult.segmentName,
      'duration': segmentResult.duration.inMicroseconds,
      'name': segmentResult.name,
    };
  }
}
