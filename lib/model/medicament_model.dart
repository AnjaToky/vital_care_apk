import 'package:vital_care/DAO/medicament_dao.dart';

enum MedicamentStatus { enAttente, valider, manquer }

class Medicament {
  int? id;
  String nom;
  double dosage;
  int frequence;
  DateTime heure;
  MedicamentStatus status;
  

  Medicament({
    this.id,
    required this.nom,
    required this.dosage,
    required this.frequence,
    required this.heure,
    this.status = MedicamentStatus.enAttente,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'dosage': dosage,
      'frequence': frequence,
      'heure': heure.toIso8601String(),
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
