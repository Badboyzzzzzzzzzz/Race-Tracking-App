class Participant {

  final String id;
  final String bibNumber;
  final String name;
  Map<String, DateTime?> segmentTimes; // Stores start/end times for each segment
  String currentSegment;

  Participant({
    required this.id,
    required this.bibNumber,
    required this.name,
    Map<String, DateTime?>? segmentTimes,
    this.currentSegment = 'swim',
  }) : segmentTimes = segmentTimes ?? {
          'swim_start': null,
          'swim_end': null,
          'cycle_start': null,
          'cycle_end': null,
          'run_start': null,
          'run_end': null,
        };

  Duration? getSegmentDuration(String segment) {
    final start = segmentTimes['${segment}_start'];
    final end = segmentTimes['${segment}_end'];
    if (start != null && end != null) {
      return end.difference(start);
    }
    return null;
  }

  Duration? getTotalTime() {
    final raceStart = segmentTimes['swim_start'];
    final raceEnd = segmentTimes['run_end'];
    if (raceStart != null && raceEnd != null) {
      return raceEnd.difference(raceStart);
    }
    return null;
  }

  void startSegment(String segment) {
    segmentTimes['${segment}_start'] = DateTime.now();
    currentSegment = segment;
  }

  void endSegment(String segment) {
    segmentTimes['${segment}_end'] = DateTime.now();
  }
}

