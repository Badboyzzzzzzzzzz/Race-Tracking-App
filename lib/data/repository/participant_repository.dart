import 'package:race_tracker/model/participant.dart';

abstract class ParticipantRepository {

  Future<List<Participant>> getParticipants();
  Future<Participant> addParticipant(String name,String bib, ParticipantStatus status);
  Future<void> removeParticipant(Participant participant);
  Future<void> updateParticipant(Participant participant);
}



