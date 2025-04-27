import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:race_tracker/data/dto/segment_result_dto.dart';
import 'package:race_tracker/data/repository/segment_result_repository.dart';
import 'package:race_tracker/model/segment_result.dart';

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
            segmentName: segmentName,
            duration: duration,
            confirmedBibs: [],
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
  Future<List<SegmentResult>> getParticipantResults(String bibNumber) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/$segmentResultsCollection.json?orderBy="\$key"&startAt="$bibNumber"&endAt="$bibNumber\\uf8ff"',
      ),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to get participant results');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>?;
    if (data == null) return [];

    return data.values
        .map((result) => SegmentResultDto.fromJson(result.key, result.value))
        .toList();
  }

  @override
  Future<List<SegmentResult>> getSegmentResults(String segmentName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$segmentResultsCollection.json'),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to get segment results');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>?;
    if (data == null) return [];

    return data.values
        .map((result) => SegmentResultDto.fromJson(result.key, result.value))
        .where((result) => result.segmentName == segmentName)
        .toList();
  }

  @override
  Future<SegmentResult?> getSpecificResult(
    String bibNumber,
    String segmentName,
  ) async {
    final path = _getSegmentResultPath(bibNumber, segmentName);
    final response = await http.get(Uri.parse('$baseUrl/$path.json'));

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to get specific result');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>?;
    if (data == null) return null;

    return SegmentResultDto.fromJson(data.keys.first, data.values.first);
  }
}
