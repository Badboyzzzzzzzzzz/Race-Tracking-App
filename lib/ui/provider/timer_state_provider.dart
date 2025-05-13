import 'dart:async';
import 'package:flutter/material.dart';
import 'package:race_tracker/data/repository/timer_state_repository.dart';
import 'package:race_tracker/model/race_status.dart';

class TimerStateProvider extends ChangeNotifier {
  final TimerStateRepository repository;
  TimerState? _currentState;
  StreamSubscription<TimerState>? _subscription;
  Duration _elapsedTime = Duration.zero;

  TimerStateProvider({required this.repository}) {
    _subscription = repository.getTimerState().listen((state) {
      _currentState = state;
      if (!state.isRunning && state.stopTime != null) {
        _elapsedTime = state.stopTime!.difference(state.startTime);
      }
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
    if (_currentState == null) return Duration.zero;

    if (_currentState!.isRunning) {
      return DateTime.now().difference(_currentState!.startTime);
    } else {
      return _elapsedTime;
    }
  }

  Future<void> startTimer() async {
    if (_currentState?.isRunning ?? false) return;

    final now = DateTime.now();
    final newState = TimerState(
      isRunning: true,
      startTime: now.subtract(_elapsedTime),
      stopTime: null,
    );
    await repository.updateTimerState(newState);
  }

  Future<void> stopTimer() async {
    if (!(_currentState?.isRunning ?? false)) return;

    final now = DateTime.now();
    _elapsedTime = now.difference(_currentState!.startTime);

    final newState = TimerState(
      isRunning: false,
      startTime: _currentState!.startTime,
      stopTime: now,
    );
    await repository.updateTimerState(newState);
  }

  Future<void> resetTimer() async {
    _elapsedTime = Duration.zero;
    final newState = TimerState(
      isRunning: false,
      startTime: DateTime.now(),
      stopTime: null,
    );
    await repository.updateTimerState(newState);
  }
}
