import 'package:ego/models/cliente.dart';
import 'package:ego/models/membresia.dart';
import 'package:ego/repository/cliente_repository.dart';
import 'package:ego/repository/membresia_respository.dart';

class Test {
  final MembresiaRespository _membresiaRespository = MembresiaRespository();
  final ClienteRepository _clienteRepository = ClienteRepository();

  Future<void> insertMembresias() async {
    await _membresiaRespository.registrarMembresia(
      Membresia(
        clienteId: 2,
        fechaInicio: DateTime.now(),
        fechaFin: DateTime.now().add(const Duration(days: 30)),
        tipo: 'No Activa',
        costo: 0.0,
      ),
    );
    await _membresiaRespository.registrarMembresia(
      Membresia(
        clienteId: 3,
        fechaInicio: DateTime.now(),
        fechaFin: DateTime.now().add(const Duration(days: 30)),
        tipo: 'Personalizado',
        costo: 60.0,
      ),
    );
    await _membresiaRespository.registrarMembresia(
      Membresia(
        clienteId: 4,
        fechaInicio: DateTime.now(),
        fechaFin: DateTime.now().add(const Duration(days: 30)),
        tipo: 'No Activa',
        costo: 0.0,
      ),
    );
    await _membresiaRespository.registrarMembresia(
      Membresia(
        clienteId: 5,
        fechaInicio: DateTime.now(),
        fechaFin: DateTime.now().add(const Duration(days: -9)),
        tipo: 'Activa',
        costo: 70.0,
      ),
    );
  }

  // Inicializa los datos de prueba al cargar la aplicacion
  Future<void> initTestData() async {
    List<Cliente> clientes = await _clienteRepository.getClientes();
    if (clientes.isEmpty) {
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Isai', apellidos: 'Ticliahuanca', estado: true),
      );
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Maria', apellidos: 'Lopez', estado: true),
      );
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Carlos', apellidos: 'Gomez', estado: true),
      );
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Ana', apellidos: 'Martinez', estado: true),
      );
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Luis', apellidos: 'Fernandez', estado: true),
      );
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Sofia', apellidos: 'Ramirez', estado: true),
      );

      print('Clientes insertados');
    } else {
      print('Clientes ya existen, no se insertan duplicados');
    }
  }
}
