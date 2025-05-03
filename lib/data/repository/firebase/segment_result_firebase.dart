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
  Future<void> addSegmentResult(
    String bibNumber,
    String name,
    String segmentName,
    Duration duration,
  ) async {
    final path = _getSegmentResultPath(bibNumber, segmentName);
    final response = await http.put(
      Uri.parse('$baseUrl/$path.json'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        SegmentResultDto.toJson(
          SegmentResult(
            id: path,
            bibNumber: bibNumber,
            name: name,
            segmentName: segmentName,
            duration: duration,
          ),
        ),
      ),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to add segment result');
    }
  }

  @override
  Future<void> deleteSegmentResult(String bibNumber, String segmentName) async {
    final path = _getSegmentResultPath(bibNumber, segmentName);
    final response = await http.delete(Uri.parse('$baseUrl/$path.json'));

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to delete segment result');
    }
  }


  @override
  Future<List<SegmentResult>> getSegmentResults() async {
    final response = await http.get(
      Uri.parse('$baseUrl/$segmentResultsCollection.json'),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to get segment results');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>?;
    if (data == null) return [];

    return data.entries
        .where((entry) => entry.value is Map<String, dynamic>)
        .map((entry) {
          try {
            return SegmentResultDto.fromJson(
              entry.key,
              entry.value as Map<String, dynamic>,
            );
          } catch (e) {
            // Optionally log or handle the error
            return null;
          }
        })
        .where((result) => result != null)
        .cast<SegmentResult>()
        .toList();
  }


}
