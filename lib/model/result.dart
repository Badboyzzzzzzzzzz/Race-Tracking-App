class Result {
  final int rank;
  final String bib;
  final String name;
  final Duration swimTime;
  final Duration cycleTime;
  final Duration runTime;
  final Duration overallTime;

  const Result({
    required this.rank,
    required this.bib,
    required this.name,
    required this.swimTime,
    required this.cycleTime,
    required this.runTime,
    required this.overallTime,
  });

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${hours}h${minutes}m${seconds}s';
  }
}
