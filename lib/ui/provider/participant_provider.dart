import 'package:flutter/material.dart';
import 'package:race_tracker/data/repository/firebase/participant_firebase.dart';
import 'package:race_tracker/data/repository/participant_repository.dart';
import 'package:race_tracker/model/participant.dart';
import 'package:race_tracker/ui/provider/async_values.dart';

class ParticipantProvider extends ChangeNotifier {
  final ParticipantRepository _participantRepository = ParticipantFirebase();
  AsyncValue<List<Participant>> _participants = AsyncValue.empty();

  // Getter for participants
  AsyncValue<List<Participant>> get participants => _participants;

  Future<void> fetchParticipants() async {
    try {
      _participants = AsyncValue.loading();
      notifyListeners();

      final participants = await _participantRepository.getParticipants();
      _participants = AsyncValue.success(participants);
      notifyListeners();
    } catch (error) {
      _participants = AsyncValue.error(error);
      notifyListeners();
    }
  }

  Future<void> addParticipant(Participant participant) async {
    await _participantRepository.addParticipant(
      participant.bibNumber,
      participant.name,
      participant.status,
    );
    notifyListeners();
  }

  Future<void> removeParticipant(Participant participant) async {
    await _participantRepository.removeParticipant(participant);
    notifyListeners();
  }

  Future<void> updateParticipant(Participant participant) async {
    await _participantRepository.updateParticipant(participant);
    notifyListeners();
  }
}
