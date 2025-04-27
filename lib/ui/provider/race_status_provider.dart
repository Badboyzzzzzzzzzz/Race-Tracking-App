import 'package:flutter/material.dart';
import 'package:race_tracker/data/repository/race_status_repository.dart';
import 'package:race_tracker/model/race_status.dart';

class RaceStatusProvider extends ChangeNotifier {
  final RaceStatusRepository _repository;
  RaceStatus? _currentStatus;
  bool _isLoading = false;
  String? _error;

  RaceStatusProvider(this._repository);

  RaceStatus? get currentStatus => _currentStatus;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isCompleted => _currentStatus?.isCompleted ?? false;

  Future<void> loadSegmentStatus(String segmentName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentStatus = await _repository.getSegmentStatus(segmentName);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> startSegment(String segmentName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Check if segment is already completed
      final isCompleted = await _repository.isSegmentCompleted(segmentName);
      if (isCompleted) {
        _error = 'This segment has already been completed';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _repository.startSegment(segmentName);
      await loadSegmentStatus(segmentName);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeSegment(String segmentName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.completeSegment(segmentName);
      await loadSegmentStatus(segmentName);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
