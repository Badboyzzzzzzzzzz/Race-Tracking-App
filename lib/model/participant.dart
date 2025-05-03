class Participant {
  final String id;
  final String bibNumber;
  final String name;

  Participant({required this.id, required this.bibNumber, required this.name});

  @override
  bool operator ==(Object other) {
    return other is Participant &&
        other.id == id &&
        other.name == name &&
        other.bibNumber == bibNumber;
  }

  @override
  int get hashCode => super.hashCode ^ name.hashCode ^ bibNumber.hashCode;
}
