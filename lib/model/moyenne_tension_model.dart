class MoyenneTension {
  int? id;
  double moyenneSystolique;
  double moyenneDiastolique;
  DateTime createdAt;

  MoyenneTension({
    this.id,
    required this.moyenneSystolique,
    required this.moyenneDiastolique,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moyenne_systolique': moyenneSystolique,
      'moyenne_diastolique': moyenneDiastolique,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
