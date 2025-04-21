import 'package:flutter/material.dart';
import 'package:race_tracker/data/repository/participant_repository.dart';
import 'package:race_tracker/model/participant.dart';
import 'package:race_tracker/ui/provider/async_values.dart';

class ParticipantProvider extends ChangeNotifier {
  final ParticipantRepository participantRepository;
  AsyncValue<List<Participant>> _participants = AsyncValue.empty();
  ParticipantProvider({required this.participantRepository}) {
    fetchParticipants();
  }

  // Getter for participants
  AsyncValue<List<Participant>> get participants => _participants;

  Future<void> fetchParticipants() async {
    try {
      _participants = AsyncValue.loading();
      notifyListeners();

      final participants = await participantRepository.getParticipants();
      _participants = AsyncValue.success(participants);
      notifyListeners();
    } catch (error) {
      _participants = AsyncValue.error(error);
      notifyListeners();
    }
  }

  Future<void> addParticipant(String bibNumber, String name) async {
    await participantRepository.addParticipant(bibNumber, name);
    notifyListeners();
  }

  Future<void> removeParticipant(Participant participant) async {
    await participantRepository.removeParticipant(participant);
    notifyListeners();
  }

  Future<void> updateParticipant(Participant participant) async {
    await participantRepository.updateParticipant(participant);
    notifyListeners();
  }
}
