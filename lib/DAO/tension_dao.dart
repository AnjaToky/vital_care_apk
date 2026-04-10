import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vital_care/configBdd/datbase_helper.dart';
import 'package:vital_care/model/tension_model.dart';
import 'package:vital_care/securite/encrypt_service.dart';
import 'package:vital_care/securite/secure_storage_service.dart';

class TensionDao {
  final dbProvider = DatabaseHelper.instance;

  EncryptService? _encryptService;

  Future<void> _ensureEncryptService() async {
    if (_encryptService != null) return;
    final storage = SecureStorageService();
    _encryptService = await EncryptService.create(storage);
  }

  Future<int> ajouterTension(Tension tension) async {
    await _ensureEncryptService();
    final db = await dbProvider.database;
    final map = tension.toMap();
    try {
      map['tension_systolique'] = _encryptService!.encrypt(
        tension.tensionSystolique.toString(),
      );
      map['tension_diastolique'] = _encryptService!.encrypt(
        tension.tensionDiastolique.toString(),
      );
      map['created_at'] = _encryptService!.encrypt(
        tension.createdAt.toIso8601String(),
      );
    } catch (e) {
      print('Error occurred while adding tension: $e');
      rethrow;
    }
    return await db.insert(
      'tension',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> supprimerTension(int id) async {
    final db = await dbProvider.database;
    return await db.delete('tension', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Tension>> afficherTension() async {
    final db = await dbProvider.database;
    final result = await db.query('tension', orderBy: 'id DESC');
    await _ensureEncryptService();
    List<Tension> tensionDecrypte = [];

    for (var row in result) {
      try {
        final decryptedSystolique = _encryptService!.decrypt(
          row['tension_systolique'] as String,
        );
        final decryptedDiastolique = _encryptService!.decrypt(
          row['tension_diastolique'] as String,
        );
        final decryptedDate = _encryptService!.decrypt(
          row['created_at'] as String,
        );

        tensionDecrypte.add(
          Tension(
            id: row['id'] as int,
            tensionSystolique: double.parse(decryptedSystolique),
            tensionDiastolique: double.parse(decryptedDiastolique),
            createdAt: DateTime.parse(decryptedDate),
          ),
        );
      } catch (e) {
        print('Error occurred while decrypting tension data: $e');
      }
    }
    return tensionDecrypte;
  }
}
