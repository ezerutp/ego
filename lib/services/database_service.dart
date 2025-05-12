import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ego_gym.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombres TEXT,
        apellidos TEXT,
        dni TEXT,
        celular TEXT,
        estado INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE membresias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clienteId INTEGER,
        fechaInicio TEXT,
        fechaFin TEXT,
        tipo TEXT,
        costo REAL,
        FOREIGN KEY (clienteId) REFERENCES clientes (id)
      )
    ''');
  }
}
