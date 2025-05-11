class SegmentResult {
  final String id;
  final String bibNumber;
  final String name;
  final String segmentName;
  final Duration elapsedTime;
  final DateTime finishDateTime;
  SegmentResult({
    required this.id,
    required this.bibNumber,
    required this.name,
    required this.segmentName,
    required this.elapsedTime,
    required this.finishDateTime,
  });

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = twoDigits((duration.inMilliseconds % 1000) ~/ 10);
    return '$hours:$minutes:$seconds.$milliseconds';
  }

  @override
  bool operator ==(Object other) {
    return other is SegmentResult &&
        other.id == id &&
        other.name == name &&
        other.bibNumber == bibNumber &&
        other.segmentName == segmentName &&
        other.elapsedTime == elapsedTime &&
        other.finishDateTime == finishDateTime;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      bibNumber.hashCode ^
      segmentName.hashCode ^
      elapsedTime.hashCode ^
      finishDateTime.hashCode;
}

