class Imc{
  int? id;
  double valuerImc;
  DateTime createdAt;

  Imc({
    this.id,
    required this.valuerImc,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valuer_imc': valuerImc,
      'created_at': createdAt.toIso8601String(),
    };
  }
}