class Participant {
  final String id;
  final String name;
  final String bib;
  final ParticipantStatus status;
  const Participant({
    required this.id,
    required this.name,
    required this.bib,
    required this.status,
  });

  @override
  bool operator ==(Object other) {
    return other is Participant && other.name == name && other.bib == bib;
  }

  @override
  int get hashCode => super.hashCode ^ name.hashCode ^ bib.hashCode;
}

enum ParticipantStatus { notStarted, started, finished }
