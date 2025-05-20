import 'package:ego/controllers/home_controller.dart';
import 'package:ego/main.dart';
import 'package:ego/models/cliente.dart';
import 'package:ego/models/cliente_stats.dart';
import 'package:ego/models/membresia_stats.dart';
import 'package:ego/utils/backup.dart';
import 'package:ego/utils/utils.dart';
import 'package:ego/widgets/add_cliente.dart';
import 'package:ego/widgets/add_membership.dart';
import 'package:ego/widgets/button_navigation.dart';
import 'package:ego/widgets/dialog.dart';
import 'package:ego/widgets/membership_page_content.dart';
import 'package:ego/models/membresia.dart';
import 'package:ego/repository/cliente_repository.dart';
import 'package:ego/repository/membresia_respository.dart';
import 'package:ego/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:ego/widgets/home_page_content.dart';

class MyHomePageState extends State<MyHomePage> {
  // Inicializa el repositorio de clientes
  final ClienteRepository _clienteRepository = ClienteRepository();
  final MembresiaRespository _membresiaRespository = MembresiaRespository();

  //HomeController
  late final HomeController _homeController;

  // mapas para datos cacheados
  final Map<int, Membresia?> _membresiasPorCliente = {};
  final Map<int, Cliente?> _clientesPorMembresia = {};

  ClienteStats _stats = ClienteStats(
    totalReal: 0,
    totalActivos: 0,
    conMembresia: 0,
    sinMembresia: 0,
  );
  MembresiaStats _membresiaStats = MembresiaStats(
    totalMembresias: 0,
    totalNormales: 0,
    totalPersonalizados: 0,
  );

  // Variables para el estado de la aplicación
  int _selectedIndex = 0;

  // Listas para almacenar los datos de clientes y membresías
  List<Cliente> _clientes = [];
  List<Membresia> _membresias = [];

  @override
  void initState() {
    super.initState();
    _homeController = HomeController(_clienteRepository, _membresiaRespository);
    _getData();
  }

  // metodo para el boton
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // metodo para cargar los datos de clientes, membresias y estadisticas
  void _getData() async {
    final List<Cliente> clientes = await _homeController.cargarClientes(
      _membresiasPorCliente,
    );
    final List<Membresia> membresias = await _homeController.cargarMembresias(
      _clientesPorMembresia,
    );
    final ClienteStats stats = await _homeController.getStatsClientes();
    final MembresiaStats membresiaStats =
        await _homeController.getStatsMembresias();
    setState(() {
      _clientes = clientes;
      _membresias = membresias;
      _stats = stats;
      _membresiaStats = membresiaStats;
    });
  }

  void _onClienteInfoPressed(BuildContext context, int clienteId) {
    final cliente = _clientes.firstWhere((c) => c.id == clienteId);
    CustomDialogos.mostrarInfoCliente(context: context, cliente: cliente);
  }

  void _confirmarYEliminarCliente(
    BuildContext context,
    int clienteId,
    String nombreCliente,
  ) {
    CustomDialogos.mostrarEliminar(
      context: context,
      titulo: 'Eliminar cliente',
      mensaje: '¿Está seguro de eliminar a $nombreCliente?',
      onConfirmar: () async {
        await _clienteRepository.eliminarCliente(clienteId);
        _getData(); // actualiza estado con setState()
      },
    );
  }

  void _confirmarEliminarMembresia(
    BuildContext context,
    int membresiaId,
    String nombreMembresia,
  ) {
    CustomDialogos.mostrarEliminar(
      context: context,
      titulo: 'Eliminar membresía',
      mensaje: '¿Estas seguro de eliminar $nombreMembresia?',
      onConfirmar: () async {
        await _membresiaRespository.cancelarMembresia(membresiaId);
        _getData(); // actualiza estado con setState()
      },
    );
  }

  // CORREGIR ESTO PIPIPI
  Future<void> _confirmarActualizarMembresia(
    BuildContext context,
    int membresiaId,
    String nombreMembresia,
  ) async {
    final membresia = await _membresiaRespository.getMembresiaById(membresiaId);

    if (membresia == null) {
      CustomDialogos.mostrarMensaje(
        context: context,
        mensaje: 'No se encontró la membresía',
      );
      return;
    }
    CustomDialogos.mostrarAumentarMembresia(
      context: context,
      nombreCliente: nombreMembresia,
      fechaInicio: membresia.fechaInicio,
      fechaFin: membresia.fechaFin,
      onConfirmar: (int meses) async {
        membresia.fechaFin = Utils.sumarMeses(membresia.fechaFin, meses);

        await _membresiaRespository.updateMembresia(membresia);

        CustomDialogos.mostrarMensaje(
          context: context,
          mensaje: 'Membresía extendida $meses mes${meses > 1 ? "es" : ""}.',
          backgroundColor: Colors.green,
        );

        _getData();
      },
    );
  }

  void _onAddClientePressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddClienteDialog(
          clienteRepository: _clienteRepository,
          onClienteAdded: _getData,
        );
      },
    );
  }

  void _onAddMembershipPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMembership(
          membresiaRespository: _membresiaRespository,
          clienteRepository: _clienteRepository,
          onMembershipAdded: _getData,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lista de vistas por pestaña
    final List<Widget> pages = [
      // Vista Home
      HomePageContent.buildHomePage(
        context,
        _clientes,
        _stats,
        _onAddClientePressed,
        _membresiasPorCliente,
        _onClienteInfoPressed,
        _confirmarYEliminarCliente,
      ),

      // Vista Membresías
      MemberPageContent.buildHomePage(
        context,
        _membresias,
        _membresiaStats,
        _onAddMembershipPressed,
        _clientesPorMembresia,
        _confirmarActualizarMembresia,
        _confirmarEliminarMembresia,
      ),

      // Vista Backup
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Backup',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Backup.createBackup(context);
              },
              child: const Text('Crear Backup'),
            ),
          ],
        ),
      ),

      // Vista Notificaciones
      const Center(
        child: Text(
          'Notificaciones',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),

      // Vista Configuración
      const Center(
        child: Text(
          'Configuración',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.darkBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/image/logo.png', height: 30),
            const SizedBox(width: 10),
          ],
        ),
      ),

      body: pages[_selectedIndex], //
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
