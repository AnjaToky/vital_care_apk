import 'package:vital_care/DAO/imc_dao.dart';

class Imc {
  int? id;
  double valuerImc;
  DateTime createdAt;

  Imc({this.id, required this.valuerImc, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imc_value': valuerImc,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ImcModel {
  ImcDao imcDao = ImcDao();

  Future<int> ajouterImc(Imc imc) async => await imcDao.ajouterImc(imc);

  Future<int> supprimerImc(int id) async => await imcDao.supprimerImc(id);

  Future<List<Imc>> afficherImc() async => await imcDao.afficherImc();
}
