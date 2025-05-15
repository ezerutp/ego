import 'package:ego/models/membresia.dart';
import 'package:ego/services/database_service.dart';

class MembresiaRespository {
  final DatabaseService _databaseService = DatabaseService();

  Future<int> _insertMembresia(Membresia membresia) async {
    final db = await _databaseService.database;
    return await db.insert('membresias', membresia.toMap());
  }

  Future<void> registrarMembresia(Membresia membresia) async {
    final result = await getMembresiaActivaByClienteId(membresia.clienteId);
    if (result == null) {
      await _insertMembresia(membresia);
    } else {
      membresia.id = result.id;
      membresia.fechaInicio = result.fechaInicio;
      if (!result.fechaFin.isBefore(membresia.fechaFin)) {
        membresia.fechaFin = result.fechaFin;
      }
      await updateMembresia(membresia);
    }
  }

  Future<Membresia?> getMembresiaById(int id) async {
    final db = await _databaseService.database;
    final result = await db.query(
      'membresias',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Membresia.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<int> updateMembresia(Membresia membresia) async {
    final db = await _databaseService.database;
    return await db.update(
      'membresias',
      membresia.toMap(),
      where: 'id = ?',
      whereArgs: [membresia.id],
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

  Future<Membresia?> getMembresiaActivaByClienteId(int id) async {
    final db = await _databaseService.database;
    final result = await db.query(
      'membresias',
      where: 'clienteId = ? AND date(fechaFin) >= date("now")',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Membresia.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<List<Membresia>> getMembresiasActivas() async {
    final db = await _databaseService.database;
    final result = await db.query(
      'membresias',
      where: 'date(fechaFin) >= date("now")',
      orderBy: 'fechaFin ASC',
    );
    return result.map((map) => Membresia.fromMap(map)).toList();
  }

  Future<List<Membresia>> getMembresiasActivasByTipo(MembresiaTipo tipo) async {
    final db = await _databaseService.database;
    final result = await db.query(
      'membresias',
      where: 'tipo = ? AND date(fechaFin) >= date("now")',
      whereArgs: [tipo.toDbValue],
      orderBy: 'fechaFin ASC',
    );
    return result.map((map) => Membresia.fromMap(map)).toList();
  }

  Future<List<Membresia>> getMembresias() async {
    final db = await _databaseService.database;
    final result = await db.query('membresias', orderBy: 'fechaFin DESC');
    return result.map((map) => Membresia.fromMap(map)).toList();
  }
}

enum MembresiaTipo { normal, personalizado }

extension MembresiaTipoExtension on MembresiaTipo {
  String get toDbValue {
    switch (this) {
      case MembresiaTipo.normal:
        return 'Normal';
      case MembresiaTipo.personalizado:
        return 'Personalizado';
    }
  }
}
