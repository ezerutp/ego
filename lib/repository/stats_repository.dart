import 'package:ego/models/cliente.dart';
import 'package:ego/models/cliente_stats.dart';
import 'package:ego/models/membresia.dart';
import 'package:ego/models/membresia_stats.dart';
import 'package:ego/repository/cliente_repository.dart';
import 'package:ego/repository/membresia_respository.dart';

class StatsData {
  static Future<ClienteStats> getStatsClientes() async {
    ClienteRepository clienteRepository = ClienteRepository();

    List<Cliente> clientes = await clienteRepository.getTodosClientes();
    List<Cliente> clientesActivos = await clienteRepository.getClientes();
    List<Cliente> clientesSinMembresia =
        await clienteRepository.getClientesActivosAndSinMebresiaActiva();

    int totalReal = clientes.length;
    int totalActivos = clientesActivos.length;
    int sinMembresia = clientesSinMembresia.length;
    int conMembresia = totalActivos - sinMembresia;

    ClienteStats stats = ClienteStats(
      totalReal: totalReal,
      totalActivos: totalActivos,
      conMembresia: conMembresia,
      sinMembresia: sinMembresia,
    );

    return stats;
  }

  static Future<MembresiaStats> getStatsMembresias() async {
    MembresiaRespository membresiaRepository = MembresiaRespository();
    List<Membresia> membresias =
        await membresiaRepository.getMembresiasActivas();
    List<Membresia> normales = await membresiaRepository
        .getMembresiasActivasByTipo(MembresiaTipo.normal);
    List<Membresia> personalizadas = await membresiaRepository
        .getMembresiasActivasByTipo(MembresiaTipo.personalizado);

    int totalMembresias = membresias.length; //membresias.length;
    int totalNormales = normales.length; //normales.length;
    int totalPersonalizados = personalizadas.length; //personalizadas.length;

    MembresiaStats stats = MembresiaStats(
      totalMembresias: totalMembresias,
      totalNormales: totalNormales,
      totalPersonalizados: totalPersonalizados,
    );

    return stats;
  }
}
