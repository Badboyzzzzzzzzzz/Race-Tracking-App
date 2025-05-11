import 'dart:async';
import 'package:flutter/material.dart';
import 'package:race_tracker/data/repository/timer_state_repository.dart';
import 'package:race_tracker/model/race_status.dart';

class TimerStateProvider extends ChangeNotifier {
  final TimerStateRepository repository;
  TimerState? _currentState;
  StreamSubscription<TimerState>? _subscription;

  TimerStateProvider(this.repository) {
    _subscription = repository.getTimerState().listen((state) {
      _currentState = state;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  TimerState? get currentState => _currentState;

  Duration getElapsedTime() {
    return _currentState?.getElapsedTime() ?? Duration.zero;
  }

  Future<void> startTimer() async {
    if (_currentState?.isRunning ?? false) return;

    final newState = TimerState(isRunning: true, startTime: DateTime.now());
    await repository.updateTimerState(newState);
  }

  Future<void> stopTimer() async {
    if (!(_currentState?.isRunning ?? false)) return;

    final newState = TimerState(
      isRunning: false,
      startTime: _currentState!.startTime,
      stopTime: DateTime.now(),
    );
    await repository.updateTimerState(newState);
  }
}
