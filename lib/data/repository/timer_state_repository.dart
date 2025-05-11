import 'package:race_tracker/model/race_status.dart';

abstract class TimerStateRepository {
  Stream<TimerState> getTimerState();
  Future<void> updateTimerState(TimerState state);
}

