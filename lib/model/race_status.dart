class TimerState {
  final bool isRunning;
  final DateTime startTime;
  final DateTime? stopTime;

  TimerState({required this.isRunning, required this.startTime, this.stopTime});

  Duration getElapsedTime() {
    if (!isRunning) {
      return stopTime?.difference(startTime) ?? Duration.zero;
    }
    return DateTime.now().difference(startTime);
  }
}
