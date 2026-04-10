import 'package:vital_care/DAO/tension_dao.dart';

class Tension {
  int? id;
  double tensionSystolique;
  double tensionDiastolique;
  DateTime createdAt;

  Tension({
    this.id,
    required this.tensionSystolique,
    required this.tensionDiastolique,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tension_systolique': tensionSystolique,
      'tension_diastolique': tensionDiastolique,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TensionModel {
  TensionDao tensionDao = TensionDao();
  Future<int> ajouterTension(Tension tension) async =>
      tensionDao.ajouterTension(tension);
  Future<int> supprimerTension(int id) async => tensionDao.supprimerTension(id);
  Future<List<Tension>> afficherTension() async => tensionDao.afficherTension();
}
