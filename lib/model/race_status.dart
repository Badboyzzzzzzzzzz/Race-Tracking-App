class TimerState {
  final bool isRunning;
  final DateTime startTime;
  final DateTime? stopTime;

  TimerState({required this.isRunning, required this.startTime, this.stopTime});

  @override
  bool operator ==(Object other) {
    return other is TimerState &&
        other.isRunning == isRunning &&
        other.startTime == startTime &&
        other.stopTime == stopTime;
  }

  @override
  int get hashCode {
    return isRunning.hashCode ^ startTime.hashCode ^ stopTime.hashCode;
  }

  Duration getElapsedTime() {
    if (!isRunning) {
      return stopTime?.difference(startTime) ?? Duration.zero;
    }
    return DateTime.now().difference(startTime);
  }
}
