import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:race_tracker/data/repository/race_status_repository.dart';
import 'package:race_tracker/model/race_status.dart';

class RaceStatusRepositoryFirebase implements RaceStatusRepository {
  static const String baseUrl =
      'https://race-timer-tracker-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String raceStatusCollection = "race_status";

  String _getStatusPath(String segmentName) {
    return '$raceStatusCollection/$segmentName';
  }

  @override
  Future<RaceStatus?> getSegmentStatus(String segmentName) async {
    final path = _getStatusPath(segmentName);
    final response = await http.get(Uri.parse('$baseUrl/$path.json'));

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to get segment status');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>?;
    if (data == null) return null;

    return RaceStatus.fromJson(data);
  }

  @override
  Future<void> startSegment(String segmentName) async {
    final path = _getStatusPath(segmentName);
    final status = RaceStatus(
      segmentName: segmentName,
      isCompleted: false,
      startTime: DateTime.now(),
      endTime: null,
    );

    final response = await http.put(
      Uri.parse('$baseUrl/$path.json'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(status.toJson()),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to start segment');
    }
  }

  @override
  Future<void> completeSegment(String segmentName) async {
    final path = _getStatusPath(segmentName);
    final currentStatus = await getSegmentStatus(segmentName);

    if (currentStatus == null) {
      throw Exception('Segment not started');
    }

    final status = RaceStatus(
      segmentName: segmentName,
      isCompleted: true,
      startTime: currentStatus.startTime,
      endTime: DateTime.now(),
    );

    final response = await http.put(
      Uri.parse('$baseUrl/$path.json'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(status.toJson()),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to complete segment');
    }
  }

  @override
  Future<bool> isSegmentCompleted(String segmentName) async {
    final status = await getSegmentStatus(segmentName);
    return status?.isCompleted ?? false;
  }
}
