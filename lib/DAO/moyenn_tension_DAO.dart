import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vital_care/configBdd/datbaseHelper.dart';
import 'package:vital_care/model/moyenne_tension_model.dart';
import 'package:vital_care/securite/encrypt_service.dart';
import 'package:vital_care/securite/secure_storage_service.dart';

class MoyennTensionDao {
  final dbProvider = DatabaseHelper.instance;

  EncryptService? _encryptService;

  Future<void> _ensureEncryptService() async {
    if (_encryptService != null) return;
    final storage = SecureStorageService();
    _encryptService = await EncryptService.create(storage);
  }

  Future<int> ajouterTension(MoyenneTension tension) async {
    await _ensureEncryptService();
    final db = await dbProvider.database;
    final map = tension.toMap();
    try {
      map['moyenne_systoloque'] = _encryptService!.encrypt(
        tension.moyenneSystolique.toString(),
      );
      map['moyenne_diastolique'] = _encryptService!.encrypt(
        tension.moyenneDiastolique.toString(),
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

  Future<List<MoyenneTension>> afficherTension() async {
    final db = await dbProvider.database;
    final result = await db.query('tension', orderBy: 'id DESC');
    await _ensureEncryptService();
    List<MoyenneTension> moyennTensionDecrypte = [];

    for (var row in result) {
      try {
        final decryptedMoyenneSystolique = _encryptService!.decrypt(
          row['moyenne_systoloque'] as String,
        );
        final decryptedMoyenneDiastolique = _encryptService!.decrypt(
          row['moyenne_diastolique'] as String,
        );
        final decryptedDate = _encryptService!.decrypt(
          row['created_at'] as String,
        );

        moyennTensionDecrypte.add(
          MoyenneTension(
            id: row['id'] as int,
            moyenneSystolique: double.parse(decryptedMoyenneSystolique),
            moyenneDiastolique: double.parse(decryptedMoyenneDiastolique),
            createdAt: DateTime.parse(decryptedDate),
          ),
        );
      } catch (e) {
        print('Error occurred while decrypting tension data: $e');
      }
    }
    return moyennTensionDecrypte;
  }
}
