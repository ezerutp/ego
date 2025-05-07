import '../models/cliente.dart';
import '../services/database_service.dart';

class ClienteRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<int> insertCliente(Cliente cliente) async {
    final db = await _databaseService.database;
    return await db.insert('clientes', cliente.toMap());
  }

  Future<int> updateCliente(Cliente cliente) async {
    final db = await _databaseService.database;
    return await db.update(
      'clientes',
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<Cliente?> getClienteById(int id) async {
    final db = await _databaseService.database;
    final result = await db.query('clientes', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return Cliente.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<List<Cliente>> getClientes() async {
    final db = await _databaseService.database;
    final result = await db.query('clientes');

    return result.map((map) => Cliente.fromMap(map)).toList();
  }
}
