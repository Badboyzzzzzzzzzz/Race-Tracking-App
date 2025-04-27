class SegmentResult {
  final String id;
  final String bibNumber;
  final String segmentName;
  final Duration duration;
  final List<String> confirmedBibs;
  
  

  SegmentResult({
    required this.id,
    required this.bibNumber,
    required this.segmentName,
    required this.duration,
    required this.confirmedBibs,
  });
}
