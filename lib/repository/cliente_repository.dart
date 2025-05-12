import 'package:ego/models/membresia.dart';
import 'package:ego/repository/membresia_respository.dart';

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

  /// Eliminar cliente (marcar como eliminado)
  Future<void> eliminarCliente(int clienteId) async {
    final db = await _databaseService.database;
    await db.update(
      'clientes',
      {'estado': 0},
      where: 'id = ?',
      whereArgs: [clienteId],
    );
  }

  /// Eliminar cliente permanentemente
  Future<void> eliminarClientePermanente(int clienteId) async {
    final db = await _databaseService.database;
    await db.delete('clientes', where: 'id = ?', whereArgs: [clienteId]);
  }

  /// Obtener todos los clientes (activos)
  Future<List<Cliente>> getClientes() async {
    final db = await _databaseService.database;
    final result = await db.query(
      'clientes',
      where: 'estado = 1',
      orderBy: 'nombres',
    );
    return result.map((map) => Cliente.fromMap(map)).toList();
  }

  /// Obtener clientes eliminados (inactivos)
  Future<List<Cliente>> getClientesEliminados() async {
    final db = await _databaseService.database;
    final result = await db.query(
      'clientes',
      where: 'estado = 0',
      orderBy: 'nombres',
    );
    return result.map((map) => Cliente.fromMap(map)).toList();
  }

  Future<List<Cliente>> getClientesActivosAndSinMebresiaActiva() async {
    final MembresiaRespository membresiaRespository = MembresiaRespository();
    final List<Cliente> clientes = await getClientes();
    if (clientes.isEmpty) {
      return [];
    } else {
      List<Cliente> clientesSinMembresia = [];
      for (var cliente in clientes) {
        Membresia? membresia = await membresiaRespository
            .getMembresiaActivaByClienteId(cliente.id!);
        if (membresia == null) {
          clientesSinMembresia.add(cliente);
        }
      }
      return clientesSinMembresia;
    }
  }

  /// Obtener todos los clientes
  Future<List<Cliente>> getTodosClientes() async {
    final db = await _databaseService.database;
    final result = await db.query('clientes', orderBy: 'nombres');

    return result.map((map) => Cliente.fromMap(map)).toList();
  }
}
