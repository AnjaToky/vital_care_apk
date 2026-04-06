import 'package:vital_care/DAO/medicament_dao.dart';

class Medicament {
  int? id;
  String nom;
  double dosage;
  int frequence;
  DateTime heure;
  bool estPris;
  bool estManque = false;

  Medicament({
    this.id,
    required this.nom,
    required this.dosage,
    required this.frequence,
    required this.heure,
    this.estPris = false,
    this.estManque = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'dosage': dosage,
      'frequence': frequence,
      'heure': heure.toIso8601String(),
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
