import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      // Initialize FFI for Web
      var factory = databaseFactoryFfiWeb;
      // Force database factory to be initialized
      return await factory.openDatabase('bitacora_campo.db',
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: _onCreate,
          ));
    } else {
      String path = join(await getDatabasesPath(), 'bitacora_campo.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exploradores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        lugar TEXT,
        equipo_id INTEGER,
        telefono TEXT,
        fecha TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE log_magnetometro(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        x REAL,
        y REAL,
        z REAL,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE log_barometro(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        presion REAL,
        timestamp TEXT
      )
    ''');
  }

  // CRUD Exploradores
  Future<int> insertExplorer(Map<String, dynamic> row) async {
    Database db = await database;
    print('Inserting explorer: $row');
    int id = await db.insert('exploradores', row);
    print('Inserted explorer with id: $id');
    return id;
  }

  Future<List<Map<String, dynamic>>> getExplorers() async {
    Database db = await database;
    return await db.query('exploradores');
  }

  // CRUD Magnetometro
  Future<int> insertMagnetometerLog(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('log_magnetometro', row);
  }

  Future<List<Map<String, dynamic>>> getMagnetometerLogs() async {
    Database db = await database;
    return await db.query('log_magnetometro', orderBy: 'timestamp DESC');
  }

  // CRUD Barometro
  Future<int> insertBarometerLog(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('log_barometro', row);
  }

  Future<List<Map<String, dynamic>>> getBarometerLogs() async {
    Database db = await database;
    return await db.query('log_barometro', orderBy: 'timestamp DESC');
  }
}
