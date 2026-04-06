class Tension {
  int? id;
  double tensionSystolique;
  double tensionDiastolique;

  Tension({
    this.id,
    required this.tensionSystolique,
    required this.tensionDiastolique,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tension_systolique': tensionSystolique,
      'tension_diastolique': tensionDiastolique,
    };
  }
}
