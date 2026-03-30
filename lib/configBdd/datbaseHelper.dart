import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String nomDb = "coche_liste.db";
  static const int versionDb = 2;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, nomDb);

    return await openDatabase(path, version: versionDb, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE profile (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      age TEXT NOT NULL,
      taille TEXT NOT NULL,
      poids TEXT NOT NULL,
      allergies TEXT,
      traitements TEXT,
      image TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE habitude (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      poid_habitude TEXT NOT NULL,
      hydratation TEXT NOT NULL,
      tension_systolique TEXT NOT NULL,
      tension_diastolique TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE medicament (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nom TEXT NOT NULL,
      dosage TEXT NOT NULL,
      frequence TEXT NOT NULL,
      heure TEXT NOT NULL
    )
  ''');
  }
}
