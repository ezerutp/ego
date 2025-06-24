import 'package:ego/models/cliente.dart';
import 'package:ego/models/cliente_stats.dart';
import 'package:ego/models/membresia.dart';
import 'package:ego/models/membresia_stats.dart';
import 'package:ego/repository/cliente_repository.dart';
import 'package:ego/repository/membresia_respository.dart';
import 'package:ego/repository/stats_repository.dart';

class HomeController {
  final ClienteRepository clienteRepo;
  final MembresiaRespository membresiaRepo;

  HomeController(this.clienteRepo, this.membresiaRepo);

  Future<List<Cliente>> cargarClientes(Map<int, Membresia?> cache) async {
    List<Cliente> clientes = await clienteRepo.getClientes();
    for (var cliente in clientes) {
      cache[cliente.id!] = await membresiaRepo.getMembresiaActivaByClienteId(
        cliente.id!,
      );
    }
    return clientes;
  }

  Future<List<Membresia>> cargarMembresias(Map<int, Cliente?> cache) async {
    List<Membresia> membresias = await membresiaRepo.getMembresiasActivas();
    for (var membresia in membresias) {
      cache[membresia.clienteId] = await clienteRepo.getClienteById(
        membresia.clienteId,
      );
    }
    return membresias;
  }

  Future<List<Membresia>> cargarMembresiasInactivas(
    Map<int, Cliente?> cache,
  ) async {
    List<Membresia> membresiasInactivas =
        await membresiaRepo.getMembresiasInactivas();
    for (var membresia in membresiasInactivas) {
      cache[membresia.clienteId] = await clienteRepo.getClienteById(
        membresia.clienteId,
      );
    }
    return membresiasInactivas;
  }

  Future<ClienteStats> getStatsClientes() => StatsData.getStatsClientes();
  Future<MembresiaStats> getStatsMembresias() => StatsData.getStatsMembresias();
}
