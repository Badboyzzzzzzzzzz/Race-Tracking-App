import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:race_tracker/data/dto/participant_dto.dart';
import 'package:race_tracker/data/repository/participant_repository.dart';
import 'package:race_tracker/model/participant.dart';

class ParticipantRepositoryFirebase extends ParticipantRepository {
  static const String baseUrl =
      'https://race-timer-tracker-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String participantCollection = "participants";
  static const String allParticipantUrl =
      '$baseUrl/$participantCollection.json';

  @override
  Future<Participant> addParticipant(
    String bibNumber,
    String name,
  ) async {
    final response = await http.post(
      Uri.parse(allParticipantUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'bibNumber': bibNumber,
        'name': name,      }),
    );
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to add participant');
    }
    final newID = jsonDecode(response.body)['name'];
    return Participant(
      id: newID,
      name: name,
      bibNumber: bibNumber,
    );
  }

  @override
  Future<List<Participant>> getParticipants() async {
    Uri uri = Uri.parse(allParticipantUrl);
    final http.Response response = await http.get(uri);

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception('Failed to get participants');
    }
    // Return all participants
    final data = jsonDecode(response.body) as Map<String, dynamic>?;
    if (data == null) return [];
    return data.entries
        .map((entry) => ParticipantDto.fromJson(entry.key, entry.value))
        .toList();
  }

  @override
  Future<void> updateParticipant(Participant participant) async {
    final uri = Uri.parse(
      '$baseUrl/$participantCollection/${participant.id}.json',
    );
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ParticipantDto.toJson(participant)),
    );
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to update participant');
    }
  }

  @override
  Future<void> removeParticipant(Participant participant) async {
    final uri = Uri.parse(
      '$baseUrl/$participantCollection/${participant.id}.json',
    );
    final response = await http.delete(uri);
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to remove participant');
    }
  }
}
