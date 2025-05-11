import 'package:race_tracker/model/race_result.dart';

class SegmentResultDto {
  static SegmentResult fromJson(String id, Map<String, dynamic> json) {
    return SegmentResult(
      id: id,
      bibNumber: json['bibNumber'] as String,
      segmentName: json['segmentName'] as String,
      elapsedTime: Duration(microseconds: json['elapsedTime'] as int),
      name: json['name'] as String,
      finishDateTime: DateTime.parse(json['finishDateTime'] as String),
    );
  }

  static Map<String, dynamic> toJson(SegmentResult segmentResult) {
    return {
      'bibNumber': segmentResult.bibNumber,
      'segmentName': segmentResult.segmentName,
      'elapsedTime': segmentResult.elapsedTime.inMicroseconds,
      'name': segmentResult.name,
      'finishDateTime': segmentResult.finishDateTime.toIso8601String(),
    };
  }
}
