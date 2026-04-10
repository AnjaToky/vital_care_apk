import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vital_care/configBdd/datbase_helper.dart';
import 'package:vital_care/model/imc_model.dart';
import 'package:vital_care/securite/encrypt_service.dart';
import 'package:vital_care/securite/secure_storage_service.dart';

class ImcDao {
  final dbProvider = DatabaseHelper.instance;

  EncryptService? _encryptService;

  Future<void> _ensureEncryptService() async {
    if (_encryptService != null) return;
    final storage = SecureStorageService();
    _encryptService = await EncryptService.create(storage);
  }

  Future<int> ajouterImc(Imc imc) async {
    await _ensureEncryptService();
    final db = await dbProvider.database;
    final map = imc.toMap();
    try {
      map['imc_value'] = _encryptService!.encrypt(imc.valuerImc.toString());
      map['created_at'] = _encryptService!.encrypt(imc.createdAt.toIso8601String());
    } catch (e) {
      print('Error occurred while adding IMC: $e');
      rethrow;
    }
    return await db.insert(
      'imc',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> supprimerImc(int id) async {
    final db = await dbProvider.database;
    return await db.delete('imc', where: 'id = ?', whereArgs: [id]);
  }

  Future<List <Imc>> afficherImc() async{
    final db  = await dbProvider.database;
    final result = await db.query('imc', orderBy: 'id DESC');
    await _ensureEncryptService();
    List<Imc> imcDecrypte = [];

    for (var row in result) {
      try {
        final decryptedValue = _encryptService!.decrypt(row['imc_value'] as String);
        final decryptedDate = _encryptService!.decrypt(row['created_at'] as String);
        imcDecrypte.add(Imc(
          id: row['id'] as int,
          valuerImc: double.parse(decryptedValue),
          createdAt: DateTime.parse(decryptedDate),
        ));
      } catch (e) {
        print('Error occurred while decrypting IMC data: $e');
      }
    }
    return imcDecrypte;
  }
}
