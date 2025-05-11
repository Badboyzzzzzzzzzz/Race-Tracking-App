import 'package:firebase_database/firebase_database.dart';
import 'package:race_tracker/data/dto/timer_state_dto.dart';
import 'package:race_tracker/data/repository/timer_state_repository.dart';
import 'package:race_tracker/model/race_status.dart';

class FirebaseTimerStateRepository implements TimerStateRepository {
  final DatabaseReference _database;
  static const String _path = 'timer_state';

  FirebaseTimerStateRepository() : _database = FirebaseDatabase.instance.ref() {
    _initializeTimerState();
  }

  Future<void> _initializeTimerState() async {
    try {
      final snapshot = await _database.child(_path).once();
      if (snapshot.snapshot.value == null) {
        final initialState = TimerState(
          isRunning: false,
          startTime: DateTime.now(),
          stopTime: null,
        );
        await _database.child(_path).set(TimerStateDto.toJson(initialState));
      }
    } catch (e) {
      print('Error initializing timer state: $e');
      final initialState = TimerState(
        isRunning: false,
        startTime: DateTime.now(),
        stopTime: null,
      );
      await _database.child(_path).set(TimerStateDto.toJson(initialState));
    }
  }

  @override
  Stream<TimerState> getTimerState() {
    return _database.child(_path).onValue.map((event) {
      try {
        if (event.snapshot.value == null) {
          return TimerState(
            isRunning: false,
            startTime: DateTime.now(),
            stopTime: null,
          );
        }
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return TimerStateDto.fromJson(data);
      } catch (e) {
        print('Error parsing timer state: $e');
        return TimerState(
          isRunning: false,
          startTime: DateTime.now(),
          stopTime: null,
        );
      }
    });
  }

  @override
  Future<void> updateTimerState(TimerState state) async {
    try {
      await _database.child(_path).set(TimerStateDto.toJson(state));
    } catch (e) {
      print('Error updating timer state: $e');
      rethrow;
    }
  }
}
