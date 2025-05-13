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

  Future<bool> addParticipant(String bibNumber, String name) async {
    try {
      /// Check for duplicate BIB number
      await fetchParticipants();
      final isDuplicate =
          _participants.data?.any((p) => p.bibNumber == bibNumber) ?? false;
      if (isDuplicate) {
        _participants = AsyncValue.error(
          'BIB number $bibNumber already exists',
        );
        notifyListeners();
        return false;
      }

      /// If no duplicate, proceed with adding
      await participantRepository.addParticipant(bibNumber, name);
      await fetchParticipants(); // Refresh the list
      return true;
    } catch (e) {
      _participants = AsyncValue.error(e.toString());
      notifyListeners();
      return false;
    }
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
