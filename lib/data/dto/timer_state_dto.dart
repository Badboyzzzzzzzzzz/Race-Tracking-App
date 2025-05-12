import 'package:race_tracker/model/race_status.dart';

class TimerStateDto {
  static TimerState fromJson(Map<String, dynamic> json) {
    // Use server timestamp if available, otherwise fall back to client time
    final startTimeStr = json['startTime'] as String;
    final stopTimeStr = json['stopTime'] as String?;

    DateTime startTime;
    DateTime? stopTime;

    try {
      startTime = DateTime.parse(startTimeStr);
    } catch (e) {
      startTime = DateTime.now();
    }

    if (stopTimeStr != null) {
      try {
        stopTime = DateTime.parse(stopTimeStr);
      } catch (e) {
        print('Error parsing stopTime: $e');
        stopTime = null;
      }
    }

    return TimerState(
      isRunning: json['isRunning'] as bool,
      startTime: startTime,
      stopTime: stopTime,
    );
  }

  static Map<String, dynamic> toJson(TimerState state) {
    return {
      'isRunning': state.isRunning,
      'startTime': state.startTime.toIso8601String(),
      'stopTime': state.stopTime?.toIso8601String(),
    };
  }
}
