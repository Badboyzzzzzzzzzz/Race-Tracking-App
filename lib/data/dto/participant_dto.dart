import 'package:race_tracker/model/participant.dart';

class ParticipantDto {
  static Participant fromJson(String id, Map<String, dynamic> json) {
    return Participant(
      id: id,
      name: json['name'] ?? '',
      bibNumber: json['bibNumber'] ?? '',
    );
  }

  static Map<String, dynamic> toJson(Participant participant) {
    return {'name': participant.name, 'bibNumber': participant.bibNumber};
  }
}
