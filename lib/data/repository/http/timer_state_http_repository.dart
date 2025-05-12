import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:race_tracker/data/dto/timer_state_dto.dart';
import 'package:race_tracker/data/repository/timer_state_repository.dart';
import 'package:race_tracker/model/race_status.dart';

class HttpTimerStateRepository implements TimerStateRepository {
  static const String baseUrl =
      'YOUR_API_BASE_URL'; // Replace with your API URL
  static const String timerStateEndpoint = '/timer-state';
  Timer? _pollingTimer;
  final _controller = StreamController<TimerState>.broadcast();
  TimerState? _lastState;

  HttpTimerStateRepository() {
    _initializeTimerState();
    _startPolling();
  }

  void _startPolling() {
    // Poll every second for updates
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _fetchTimerState();
    });
  }

  Future<void> _initializeTimerState() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$timerStateEndpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == HttpStatus.notFound) {
        // Initialize with default state if not found
        final initialState = TimerState(
          isRunning: false,
          startTime: DateTime.now(),
          stopTime: null,
        );
        await updateTimerState(initialState);
      } else if (response.statusCode == HttpStatus.ok) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _lastState = TimerStateDto.fromJson(data);
        _controller.add(_lastState!);
      }
    } catch (e) {
      print('Error initializing timer state: $e');
      // Initialize with default state on error
      final initialState = TimerState(
        isRunning: false,
        startTime: DateTime.now(),
        stopTime: null,
      );
      await updateTimerState(initialState);
    }
  }

  Future<void> _fetchTimerState() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$timerStateEndpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final newState = TimerStateDto.fromJson(data);

        // Only emit if state has changed
        if (_lastState == null ||
            _lastState!.isRunning != newState.isRunning ||
            _lastState!.startTime != newState.startTime ||
            _lastState!.stopTime != newState.stopTime) {
          _lastState = newState;
          _controller.add(newState);
        }
      }
    } catch (e) {
      print('Error fetching timer state: $e');
    }
  }

  @override
  Stream<TimerState> getTimerState() {
    return _controller.stream;
  }

  @override
  Future<void> updateTimerState(TimerState state) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$timerStateEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(TimerStateDto.toJson(state)),
      );

      if (response.statusCode != HttpStatus.ok) {
        throw Exception('Failed to update timer state: ${response.statusCode}');
      }

      _lastState = state;
      _controller.add(state);
    } catch (e) {
      print('Error updating timer state: $e');
      rethrow;
    }
  }

  void dispose() {
    _pollingTimer?.cancel();
    _controller.close();
  }
}
