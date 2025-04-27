import 'package:flutter/material.dart';
import 'package:race_tracker/data/repository/segment_result_repository.dart';
import 'package:race_tracker/model/segment_result.dart';
import 'package:race_tracker/ui/provider/async_values.dart';

class SegmentResultProvider extends ChangeNotifier {
  final SegmentResultRepository _repository;
  AsyncValue<List<SegmentResult>> _segmentResults = AsyncValue.empty();
  String _currentSegment = 'swim';

  SegmentResultProvider(this._repository);

  AsyncValue<List<SegmentResult>> get segmentResults => _segmentResults;
  String get currentSegment => _currentSegment;

  void setCurrentSegment(String segment) {
    _currentSegment = segment;
    notifyListeners();
  }

  Future<void> fetchSegmentResults(String segmentName) async {
    try {
      _segmentResults = AsyncValue.loading();
      notifyListeners();

      final results = await _repository.getSegmentResults(segmentName);
      _segmentResults = AsyncValue.success(results);
      notifyListeners();
    } catch (error) {
      _segmentResults = AsyncValue.error(error);
      notifyListeners();
    }
  }

  Future<void> addResult(
    String bibNumber,
    String segmentName,
    Duration duration,
  ) async {
    try {
      await _repository.addSegmentResult(bibNumber, segmentName, duration);
      await fetchSegmentResults(_currentSegment);
    } catch (error) {
      _segmentResults = AsyncValue.error(error);
      notifyListeners();
    }
  }

  Future<void> deleteResult(String bibNumber, String segmentName) async {
    try {
      await _repository.deleteSegmentResult(bibNumber, segmentName);
      await fetchSegmentResults(_currentSegment);
    } catch (error) {
      _segmentResults = AsyncValue.error(error);
      notifyListeners();
    }
  }

  Future<List<SegmentResult>> getParticipantResults(String bibNumber) async {
    try {
      return await _repository.getParticipantResults(bibNumber);
    } catch (error) {
      _segmentResults = AsyncValue.error(error);
      notifyListeners();
      return [];
    }
  }
}
