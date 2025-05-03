import 'package:flutter/material.dart';
import 'package:race_tracker/data/repository/segment_result_repository.dart';
import 'package:race_tracker/model/race_result.dart';
import 'package:race_tracker/ui/provider/async_values.dart';

class SegmentResultProvider extends ChangeNotifier {
  final SegmentResultRepository _repository;
  AsyncValue<List<SegmentResult>> _segmentResults = AsyncValue.empty();

  SegmentResultProvider(this._repository) {
    fetchSegmentResults();
  }

  AsyncValue<List<SegmentResult>> get segmentResults => _segmentResults;

  Future<void> fetchSegmentResults() async {
    try {
      _segmentResults = AsyncValue.loading();
      notifyListeners();
      final results = await _repository.getSegmentResults();
      _segmentResults = AsyncValue.success(results);
      notifyListeners();
    } catch (error) {
      _segmentResults = AsyncValue.error(error);
      notifyListeners();
    }
  }

  Future<void> addResult(
    String bibNumber,
    String name,
    String segmentName,
    Duration duration,
  ) async {
    try {
      await _repository.addSegmentResult(
        bibNumber,
        name,
        segmentName,
        duration,
      );
      await fetchSegmentResults();
    } catch (error) {
      _segmentResults = AsyncValue.error(error);
      notifyListeners();
    }
  }

  Future<void> deleteResult(String bibNumber, String segmentName) async {
    try {
      await _repository.deleteSegmentResult(bibNumber, segmentName);
      await fetchSegmentResults();
    } catch (error) {
      _segmentResults = AsyncValue.error(error);
      notifyListeners();
    }
  }
}
