import 'package:vital_care/DAO/medicament_dao.dart';

enum MedicamentStatus { enAttente, valider, manquer }

class Medicament {
  int? id;
  String nom;
  double dosage;
  int frequence;
  DateTime heure;
  DateTime createAt;
  MedicamentStatus status;

  Medicament({
    this.id,
    required this.nom,
    required this.dosage,
    required this.frequence,
    required this.heure,
    required this.createAt,
    this.status = MedicamentStatus.enAttente,
  });

  Medicament copyWith({
    int? id,
    String? nom,
    double? dosage,
    int? frequence,
    DateTime? heure,
    DateTime? createAt,
    MedicamentStatus? status,
  }) {
    return Medicament(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      dosage: dosage ?? this.dosage,
      frequence: frequence ?? this.frequence,
      heure: heure ?? this.heure,
      createAt: createAt ?? this.createAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'dosage': dosage,
      'frequence': frequence,
      'heure': heure.toIso8601String(),
      'create_at': createAt.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }
}

class MedicamentModel {
  MedicamentDao medicamentDao = MedicamentDao();

  Future<int> ajouterMedicament(Medicament medicament) async =>
      await medicamentDao.ajouterMedicament(medicament);

  Future<int> supprimerMedicament(int id) async =>
      await medicamentDao.supprimerMedicament(id);

  Future<int> modifierMedicament(Medicament medicament) async =>
      await medicamentDao.modifierMedicament(medicament);

  Future<List<Medicament>> afficherMedicaments() async =>
      await medicamentDao.afficherMedicaments();
}
