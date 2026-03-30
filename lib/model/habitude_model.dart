class Habitude {
  int? id;
  double poidHabitude;
  double hydratation;
  double tensionSystolique;
  double tenstionDiastolique;

  Habitude({
    this.id,
    required this.poidHabitude,
    required this.hydratation,
    required this.tensionSystolique,
    required this.tenstionDiastolique,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'poid_habitude': poidHabitude,
      'hydratation': hydratation,
      'tension_systolique': tensionSystolique,
      'tenstion_diastolique': tenstionDiastolique,
    };
  }

  factory Habitude.fromMap(Map<String, dynamic> map) {
    return Habitude(
      id: map['id'],
      poidHabitude: map['poid_habitude'],
      hydratation: map['hydratation'],
      tensionSystolique: map['tension_systolique'],
      tenstionDiastolique: map['tenstion_diastolique'],
    );
  }
}
