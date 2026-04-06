import 'package:sqflite/sqflite.dart';
import 'package:vital_care/configBdd/datbaseHelper.dart';
import 'package:vital_care/model/habitude_model.dart';
import 'package:vital_care/securite/encrypt_service.dart';
import 'package:vital_care/securite/secure_storage_service.dart';

class HabitudeDao {
  final dbProvider = DatabaseHelper.instance;

  EncryptService? _encryptService;

  Future<void> _ensureEncryptService() async {
    if (_encryptService != null) return;
    final storage = SecureStorageService();
    _encryptService = await EncryptService.create(storage);
  }

  Future<int> ajouterHabitude(Habitude habitude) async {
    await _ensureEncryptService();
    final db = await dbProvider.database;
    final map = habitude.toMap();

    try {
      // Encrypt sensitive fields
      map['poid_habitude'] = _encryptService!.encrypt(
        habitude.poidHabitude.toString(),
      );
      map['hydratation'] = _encryptService!.encrypt(
        habitude.hydratation.toString(),
      );
      map['tension_systolique'] = _encryptService!.encrypt(
        habitude.tensionSystolique.toString(),
      );
      map['tenstion_diastolique'] = _encryptService!.encrypt(
        habitude.tenstionDiastolique.toString(),
      );
      map['created_at'] = _encryptService!.encrypt(
        habitude.createdAt.toIso8601String(),
      );

      return await db.insert(
        'habitude',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error occurred while adding habit: $e');
      rethrow;
    }
  }

  Future<int> supprimerHabitude(int id) async {
    final db = await dbProvider.database;
    return await db.delete('habitude', where: 'id = ?', whereArgs: [id]);
  }

  Future<Habitude?> afficherHabitude() async {
    final db = await dbProvider.database;
    final result = await db.query('habitude', orderBy: 'id DESC');
    await _ensureEncryptService();
    Habitude? habitudeDecrypte;
    for (final row in result) {
      try {
        final poidHabitudeClair = _encryptService!.decrypt(
          row['poid_habitude'] as String,
        );
        final hydratationClair = _encryptService!.decrypt(
          row['hydratation'] as String,
        );
        final tensionSystoliqueClair = _encryptService!.decrypt(
          row['tension_systolique'] as String,
        );
        final tensionDiastoliqueClair = _encryptService!.decrypt(
          row['tenstion_diastolique'] as String,
        );
        final createdAtClair = _encryptService!.decrypt(
          row['created_at'] as String,
        );
        
        habitudeDecrypte = Habitude(
          id: row['id'] as int,
          poidHabitude: double.parse(poidHabitudeClair),
          hydratation: double.parse(hydratationClair),
          tensionSystolique: double.parse(tensionSystoliqueClair),
          tenstionDiastolique: double.parse(tensionDiastoliqueClair),
          createdAt: DateTime.parse(createdAtClair),
        );
      } catch (e) {
        print('Error decrypting habit data: $e');
      }
    }

    return habitudeDecrypte;
  }
}
