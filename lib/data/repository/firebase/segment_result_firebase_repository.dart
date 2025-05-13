import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:race_tracker/data/dto/segment_result_dto.dart';
import 'package:race_tracker/data/repository/segment_result_repository.dart';
import 'package:race_tracker/model/race_result.dart';

class SegmentResultRepositoryFirebase implements SegmentResultRepository {
  static const String baseUrl =
      'https://race-timer-tracker-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String segmentResultsCollection = "segment_results";

  String _getSegmentResultPath(String bibNumber, String segmentName) {
    return '$segmentResultsCollection/${bibNumber}_$segmentName';
  }

  @override
  Future<List<SegmentResult>> getSegmentResults() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$segmentResultsCollection.json'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != HttpStatus.ok) {
        throw Exception(
          'Failed to fetch segment results: ${response.statusCode}',
        );
      }
      final Map<String, dynamic> data = jsonDecode(response.body) ?? {};
      return data.entries
          .map((entry) {
            try {
              return SegmentResultDto.fromJson(
                entry.key,
                entry.value as Map<String, dynamic>,
              );
            } catch (e) {
              print('Error parsing segment result ${entry.key}: $e');
              return null;
            }
          })
          .whereType<SegmentResult>()
          .toList();
    } catch (e) {
      print('Error fetching segment results: $e');
      rethrow;
    }
  }

  @override
  Future<void> addSegmentResult(
    String bibNumber,
    String name,
    String segmentName,
    Duration elapsedTime,
    DateTime finishedTime,
  ) async {
    try {
      final path = _getSegmentResultPath(bibNumber, segmentName);
      final result = SegmentResult(
        id: path,
        bibNumber: bibNumber,
        name: name,
        segmentName: segmentName,
        elapsedTime: elapsedTime,
        finishDateTime: finishedTime,
      );

      final response = await http.put(
        Uri.parse('$baseUrl/$path.json'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(SegmentResultDto.toJson(result)),
      );

      if (response.statusCode != HttpStatus.ok) {
        throw Exception('Failed to add segment result: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding segment result: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteSegmentResult(String bibNumber, String segmentName) async {
    try {
      final path = _getSegmentResultPath(bibNumber, segmentName);
      final response = await http.delete(
        Uri.parse('$baseUrl/$path.json'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != HttpStatus.ok) {
        throw Exception(
          'Failed to delete segment result: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error deleting segment result: $e');
      rethrow;
    }
  }
}
