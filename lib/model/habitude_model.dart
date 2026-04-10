import 'package:vital_care/DAO/habitude_dao.dart';

class Habitude {
  int? id;
  double poidHabitude;
  double hydratation;
  int nbrPas;
  double tensionSystolique;
  double tenstionDiastolique;
  DateTime createdAt;

  Habitude({
    this.id,
    required this.poidHabitude,
    required this.hydratation,
    required this.nbrPas,
    required this.tensionSystolique,
    required this.tenstionDiastolique,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'poid_habitude': poidHabitude,
      'hydratation': hydratation,
      'nbr_pas': nbrPas,
      'tension_systolique': tensionSystolique,
      'tension_diastolique': tenstionDiastolique,
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
