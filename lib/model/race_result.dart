class SegmentResult {
  final String id;
  final String bibNumber;
  final String name;
  final String segmentName;
  final Duration duration;
  SegmentResult({
    required this.id,
    required this.bibNumber,
    required this.name,
    required this.segmentName,
    required this.duration,
  });

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = twoDigits(duration.inMilliseconds.remainder(1000));
    return '${hours}h${minutes}m${seconds}s${milliseconds}ms';
  }
}
