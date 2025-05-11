import 'package:race_tracker/model/race_status.dart';

class TimerStateDto {
  static TimerState fromJson(Map<String, dynamic> json) {
    return TimerState(
      isRunning: json['isRunning'] as bool,
      startTime: DateTime.parse(json['startTime'] as String),
      stopTime:
          json['stopTime'] != null
              ? DateTime.parse(json['stopTime'] as String)
              : null,
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
