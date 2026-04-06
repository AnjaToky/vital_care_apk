import 'package:vital_care/DAO/habitude_DAO.dart';

class Habitude {
  int? id;
  double poidHabitude;
  double hydratation;
  double tensionSystolique;
  double tenstionDiastolique;
  DateTime createdAt;

  Habitude({
    this.id,
    required this.poidHabitude,
    required this.hydratation,
    required this.tensionSystolique,
    required this.tenstionDiastolique,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'poid_habitude': poidHabitude,
      'hydratation': hydratation,
      'tension_systolique': tensionSystolique,
      'tenstion_diastolique': tenstionDiastolique,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class HabitudeModel {
  HabitudeDao habitudeDao = HabitudeDao();

  Future<int> ajouterHabitude(Habitude habitude) async =>
      await habitudeDao.ajouterHabitude(habitude);

  Future<int> supprimerHabitude(int id) async =>
      await habitudeDao.supprimerHabitude(id);

  Future<Habitude?> afficherHabitude() async =>
      await habitudeDao.afficherHabitude();
}
