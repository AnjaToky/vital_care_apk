import 'package:sqflite/sqflite.dart';
import 'package:vital_care/configBdd/datbase_helper.dart';
import 'package:vital_care/model/profil_model.dart';
import 'package:vital_care/securite/encrypt_service.dart';
import 'package:vital_care/securite/secure_storage_service.dart';

class ProfilDao {
  final dbProvide = DatabaseHelper.instance;

  EncryptService? _encryptService;

  Future<void> _ensureEncryptService() async {
    if (_encryptService != null) return;
    final storage = SecureStorageService();
    _encryptService = await EncryptService.create(storage);
  }

  Future<int> ajouterProfil(Profil profil) async {
    await _ensureEncryptService();
    final db = await dbProvide.database;
    final map = profil.toMap();

    try {
      // Encrypt sensitive fields
      map['name'] = _encryptService!.encrypt(profil.name);
      map['age'] = _encryptService!.encrypt(profil.age.toString());
      map['taille'] = _encryptService!.encrypt(profil.taille.toString());
      map['poids'] = _encryptService!.encrypt(profil.poids.toString());
      map['allergies'] = _encryptService!.encrypt(profil.allergies);
      map['traitements'] = _encryptService!.encrypt(profil.traitements);

      return await db.insert(
        'profile',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      //print('Erreur lors de l\'ajout du profil : $e');
      return -1; // Indique une erreur
    }
  }

  Future<int> modifierProfil(Profil profil) async {
    await _ensureEncryptService();
    final db = await dbProvide.database;
    final map = profil.toMap();

    try {
      // Encrypt sensitive fields
      map['name'] = _encryptService!.encrypt(profil.name);
      map['age'] = _encryptService!.encrypt(profil.age.toString());
      map['taille'] = _encryptService!.encrypt(profil.taille.toString());
      map['poids'] = _encryptService!.encrypt(profil.poids.toString());
      map['allergies'] = _encryptService!.encrypt(profil.allergies);
      map['traitements'] = _encryptService!.encrypt(profil.traitements);

      return await db.update(
        'profile',
        map,
        where: 'id = ?',
        whereArgs: [profil.id],
      );
    } catch (e) {
      //print('Erreur lors de la modification du profil : $e');
      return -1; // Indique une erreur
    }
  }

  Future<Profil?> afficherProfil() async {
    final db = await dbProvide.database;
    final result = await db.query('profile', orderBy: 'id DESC');
    await _ensureEncryptService();

    Profil? profilDecrypte;

    for (final row in result) {
      try {
        final nameClair = _encryptService!.decrypt(row['name'] as String);
        final ageClair = _encryptService!.decrypt(row['age'] as String);
        final tailleClair = _encryptService!.decrypt(row['taille'] as String);
        final poidsClair = _encryptService!.decrypt(row['poids'] as String);
        final allergiesClair = _encryptService!.decrypt(
          row['allergies'] as String,
        );
        final traitementsClair = _encryptService!.decrypt(
          row['traitements'] as String,
        );

        profilDecrypte = Profil(
          id: row['id'] as int,
          name: nameClair,
          age: int.parse(ageClair),
          taille: double.parse(tailleClair),
          poids: double.parse(poidsClair),
          allergies: allergiesClair,
          traitements: traitementsClair,
          image: row['image'] as String,
        );
      } catch (e) {
       // print('Erreur lors du déchiffrement du profil : $e');
      }
    }

    return profilDecrypte;
  }
}
