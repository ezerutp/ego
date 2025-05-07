import 'package:ego/models/membresia.dart';
import 'package:ego/services/database_service.dart';

class MembresiaRespository {
  final DatabaseService _databaseService = DatabaseService();

  Future<int> insertMembresia(Map<String, dynamic> membresia) async {
    final db = await _databaseService.database;
    return await db.insert('membresias', membresia);
  }

  Future<int> updateMembresia(Map<String, dynamic> membresia) async {
    final db = await _databaseService.database;
    return await db.update(
      'membresias',
      membresia,
      where: 'id = ?',
      whereArgs: [membresia['id']],
    );
  }

  Future<Membresia?> getMembresiaByClienteId(int id) async {
    final db = await _databaseService.database;
    final result = await db.query(
      'membresias',
      where: 'clienteId = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Membresia.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<List<Membresia>> getMembresias() async {
    final db = await _databaseService.database;
    final result = await db.query('membresias');

    return result.map((map) => Membresia.fromMap(map)).toList();
  }
}
