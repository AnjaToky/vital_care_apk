import 'package:vital_care/DAO/profil_dao.dart';

class Profil {
  int? id;
  String name;
  int age;
  double taille;
  double poids;
  String allergies;
  String traitements;
  String? image;

  Profil({
    this.id,
    required this.name,
    required this.age,
    required this.taille,
    required this.poids,
    required this.allergies,
    required this.traitements,
    required this.image,
  });

  Profil copyWith({
    int? id,
    String? name,
    int? age,
    double? taille,
    double? poids,
    String? allergies,
    String? traitements,
    String? image,
  }) {
    return Profil(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      taille: taille ?? this.taille,
      poids: poids ?? this.poids,
      allergies: allergies ?? this.allergies,
      traitements: traitements ?? this.traitements,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'taille': taille,
      'poids': poids,
      'allergies': allergies,
      'traitements': traitements,
      'image': image,
    };
  }
}

class ProfilModel {
  ProfilDao profilDao = ProfilDao();

  Future<int> ajouterProfil(Profil profil) async =>
      await profilDao.ajouterProfil(profil);

  Future<int> modifierProfil(Profil profil) async =>
      await profilDao.modifierProfil(profil);

  Future<Profil?> afficherProfil() async => await profilDao.afficherProfil();
}
