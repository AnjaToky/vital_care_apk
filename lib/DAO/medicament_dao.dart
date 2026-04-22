import 'package:sqflite/sqflite.dart';
import 'package:vital_care/configBdd/datbase_helper.dart';
import 'package:vital_care/model/medicament_model.dart';
import 'package:vital_care/securite/encrypt_service.dart';
import 'package:vital_care/securite/secure_storage_service.dart';

class MedicamentDao {
  final dbProvider = DatabaseHelper.instance;

  EncryptService? _encryptService;

  Future<void> _ensureEncryptService() async {
    if (_encryptService != null) return;
    final storage = SecureStorageService();
    _encryptService = await EncryptService.create(storage);
  }

  Future<int> ajouterMedicament(Medicament medicament) async {
    await _ensureEncryptService();
    final db = await dbProvider.database;
    final map = medicament.toMap();

    try {
      // Encrypt sensitive fields
      map['nom'] = _encryptService!.encrypt(medicament.nom);
      map['dosage'] = _encryptService!.encrypt(medicament.dosage.toString());
      map['frequence'] = _encryptService!.encrypt(
        medicament.frequence.toString(),
      );
      map['heure'] = _encryptService!.encrypt(medicament.heure.toString());
      map['create_at'] = _encryptService!.encrypt(
        medicament.createAt.toIso8601String(),
      );

      return await db.insert(
        'medicament',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      //print('Error occurred while adding medication: $e');
      rethrow;
    }
  }

  Future<int> supprimerMedicament(int id) async {
    final db = await dbProvider.database;
    return await db.delete('medicament', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> modifierMedicament(Medicament medicament) async {
    await _ensureEncryptService();
    final db = await dbProvider.database;
    final map = medicament.toMap();

    try {
      // Encrypt sensitive fields
      map['nom'] = _encryptService!.encrypt(medicament.nom);
      map['dosage'] = _encryptService!.encrypt(medicament.dosage.toString());
      map['frequence'] = _encryptService!.encrypt(
        medicament.frequence.toString(),
      );
      map['heure'] = _encryptService!.encrypt(
        medicament.heure.toIso8601String(),
      );
      map['create_at'] = _encryptService!.encrypt(
        medicament.createAt.toIso8601String(),
      );
      map['status'] = medicament.status.toString().split('.').last;

      return await db.update(
        'medicament',
        map,
        where: 'id = ?',
        whereArgs: [medicament.id],
      );
    } catch (e) {
      //print('Error occurred while updating medication: $e');
      rethrow;
    }
  }

  Future<List<Medicament>> afficherMedicaments() async {
    final db = await dbProvider.database;
    final result = await db.query('medicament', orderBy: 'id DESC');
    //final medicaments = result.map((e) => Medicament.fromMap(e)).toList();
    await _ensureEncryptService();
    List<Medicament> listeDecrypte = [];
    for (final row in result) {
      try {
        // 1. Décryptage (on récupère des Strings claires)
        final nomClair = _encryptService!.decrypt(row['nom'] as String);
        final dosageClair = _encryptService!.decrypt(row['dosage'] as String);
        final frequenceClair = _encryptService!.decrypt(
          row['frequence'] as String,
        );
        final createAtClaire = _encryptService!.decrypt(
          row['create_at'] as String,
        );
        final heureClaire = _encryptService!.decrypt(row['heure'] as String);

        // 2. Conversion des types (parsing)
        // C'est ici qu'on transforme les Strings en types attendus par le modèle
        listeDecrypte.add(
          Medicament(
            id: row['id'] as int,
            nom: nomClair,
            dosage: double.tryParse(dosageClair) ?? 0.0,
            frequence: int.tryParse(frequenceClair) ?? 0,
            heure: DateTime.tryParse(heureClaire) ?? DateTime.now(),
            createAt: DateTime.tryParse(createAtClaire) ?? DateTime.now(),
            status: MedicamentStatus.values.firstWhere(
              (e) => e.toString().split('.').last == row['status'],
              orElse: () => MedicamentStatus.enAttente,
            ),
          ),
        );
      } catch (e) {
        //print('Error decrypting medication data: $e');
      }
    }

    return listeDecrypte;
  }
}
