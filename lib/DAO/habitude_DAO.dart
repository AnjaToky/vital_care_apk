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



  Future <int> ajouterHabitude(Habitude habitude) async{
    await _ensureEncryptService();
    final db  = await dbProvider.database;
    final map = habitude.toMap();

    try{
      // Encrypt sensitive fields
      map['poid_habitude'] = _encryptService!.encrypt(habitude.poidHabitude.toString());
      map['hydratation'] = _encryptService!.encrypt(habitude.hydratation.toString());
      map['tension_systolique'] = _encryptService!.encrypt(habitude.tensionSystolique.toString());
      map['tenstion_diastolique'] = _encryptService!.encrypt(habitude.tenstionDiastolique.toString());

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


  Future <int> supprimerHabitude(int id) async{
    final db  = await dbProvider.database;
    return await db.delete(
      'habitude',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future <List<Habitude>> afficherHabitude() async{
    final db = await dbProvider.database;
    final result = await db.query('habitude', orderBy: 'id DESC');
    final habitudes = result.map((e) => Habitude.fromMap(e)).toList();
    await _ensureEncryptService();

    for(final h in habitudes){
      try {
        h.poidHabitude = double.parse(_encryptService!.decrypt(h.poidHabitude.toString()));
        h.hydratation = double.parse(_encryptService!.decrypt(h.hydratation.toString()));
        h.tensionSystolique = double.parse(_encryptService!.decrypt(h.tensionSystolique.toString()));
        h.tenstionDiastolique = double.parse(_encryptService!.decrypt(h.tenstionDiastolique.toString()));
      } catch (e) {
        print('Error decrypting habit data: $e');
      }
    }

    return habitudes;
  }
} 
