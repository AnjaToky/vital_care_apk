class Profil {
  int? id;
  String name;
  int age;
  double taille;
  double poids;
  String allergies;
  String traitements;
  String image;

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


  factory Profil.fromMap(Map<String, dynamic> map) {
    return Profil(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      taille: map['taille'],
      poids: map['poids'],
      allergies: map['allergies'],
      traitements: map['traitements'],
      image: map['image'],
    );
  }
}
