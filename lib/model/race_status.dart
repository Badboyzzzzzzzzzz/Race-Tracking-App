class RaceStatus {
  final String segmentName;
  final bool isCompleted;
  final DateTime? startTime;
  final DateTime? endTime;

  RaceStatus({
    required this.segmentName,
    required this.isCompleted,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'segmentName': segmentName,
      'isCompleted': isCompleted,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }

  factory RaceStatus.fromJson(Map<String, dynamic> json) {
    return RaceStatus(
      segmentName: json['segmentName'] as String,
      isCompleted: json['isCompleted'] as bool,
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }
}
