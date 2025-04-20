import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:race_tracker/data/dto/participant_dto.dart';
import 'package:race_tracker/data/repository/participant_repository.dart';
import 'package:race_tracker/model/participant.dart';

class ParticipantFirebase extends ParticipantRepository {
  static const String baseUrl =
      'https://race-timer-tracker-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String participantCollection = "participants";
  static const String allParticipantUrl =
      '$baseUrl/$participantCollection.json';

  @override
  Future<Participant> addParticipant(
    String name,
    String bib,
    ParticipantStatus status,
  ) async {
    final response = await http.post(
      Uri.parse(allParticipantUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'bib': bib, 'status': status.name}),
    );
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to add participant');
    }
    final newID = jsonDecode(response.body)['name'];
    return Participant(id: newID, name: name, bibNumber: bib, status: status);
  }

  @override
  Future<List<Participant>> getParticipants() async {
    Uri uri = Uri.parse(allParticipantUrl);
    final response = await http.get(uri);
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to get participants');
    }
    // Return all participants
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ParticipantDto.fromJson(e['id'], e)).toList();
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
