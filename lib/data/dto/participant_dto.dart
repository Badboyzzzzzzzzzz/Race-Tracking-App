import 'package:race_tracker/model/participant.dart';

class ParticipantDto {
  static Participant fromJson(String id, Map<String, dynamic> json) {
    return Participant(
      id: id,
      name: json['name'],
      bib: json['bib'],
      status: json['status'],
    );
  }

  static Map<String, dynamic> toJson(Participant participant) {
    return {
      'name': participant.name,
      'bib': participant.bib,
      'status': participant.status,
    };
  }
}
