import 'package:ego/controllers/home_controller.dart';
import 'package:ego/main.dart';
import 'package:ego/models/cliente.dart';
import 'package:ego/models/cliente_stats.dart';
import 'package:ego/models/membresia_stats.dart';
import 'package:ego/services/dialogo_servicio.dart';
import 'package:ego/views/backup.dart';
import 'package:ego/views/membership_page_history.dart';
import 'package:ego/widgets/add_cliente.dart';
import 'package:ego/widgets/add_membership.dart';
import 'package:ego/widgets/button_navigation.dart';
import 'package:ego/views/membership_page_content.dart';
import 'package:ego/models/membresia.dart';
import 'package:ego/repository/cliente_repository.dart';
import 'package:ego/repository/membresia_respository.dart';
import 'package:ego/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:ego/views/home_page_content.dart';

class MyHomePageState extends State<MyHomePage> {
  // Inicializa el repositorio de clientes
  final ClienteRepository _clienteRepository = ClienteRepository();
  final MembresiaRespository _membresiaRespository = MembresiaRespository();

  // Controlador de búsqueda
  TextEditingController _clienteSearchController = TextEditingController();
  TextEditingController _membresiaSearchController = TextEditingController();
  TextEditingController _membresiaInactivaSearchController =
      TextEditingController();
  String _filtroClientes = '';
  String _filtroMembresias = '';
  String _filtroMembresiasInactivas = '';

  //HomeController
  late final HomeController _homeController;

  // mapas para datos cacheados
  final Map<int, Membresia?> _membresiasPorCliente = {};
  final Map<int, Cliente?> _clientesPorMembresiaInactivas = {};
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
  List<Membresia> _membresiasInactivas = [];

  @override
  void initState() {
    super.initState();
    _homeController = HomeController(_clienteRepository, _membresiaRespository);

    _clienteSearchController.addListener(() {
      setState(() {
        _filtroClientes = _clienteSearchController.text.toLowerCase();
      });
    });

    _membresiaSearchController.addListener(() {
      setState(() {
        _filtroMembresias = _membresiaSearchController.text.toLowerCase();
      });
    });

    _membresiaInactivaSearchController.addListener(() {
      setState(() {
        _filtroMembresiasInactivas =
            _membresiaInactivaSearchController.text.toLowerCase();
      });
    });
    _cargarDatosIniciales();
  }

  // metodo para el boton
  void _cambiarPestana(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // metodo para cargar los datos de clientes, membresias y estadisticas
  void _cargarDatosIniciales() async {
    final List<Cliente> clientes = await _homeController.cargarClientes(
      _membresiasPorCliente,
    );
    final List<Membresia> membresias = await _homeController.cargarMembresias(
      _clientesPorMembresia,
    );
    final List<Membresia> membresiasInactivas = await _homeController
        .cargarMembresiasInactivas(_clientesPorMembresiaInactivas);

    final ClienteStats stats = await _homeController.getStatsClientes();
    final MembresiaStats membresiaStats =
        await _homeController.getStatsMembresias();
    setState(() {
      _clientes = clientes;
      _membresias = membresias;
      _membresiasInactivas = membresiasInactivas;
      _stats = stats;
      _membresiaStats = membresiaStats;
    });
  }

  void _onClienteInfoPressed(BuildContext context, int clienteId) {
    final cliente = _clientes.firstWhere((c) => c.id == clienteId);
    DialogService.mostrarInfoCliente(context, cliente);
  }

  void _onEditarClientePressed(BuildContext context, int clienteId) {
    final cliente = _clientes.firstWhere((c) => c.id == clienteId);
    DialogService.editarCliente(
      context: context,
      cliente: cliente,
      clienteRepository: _clienteRepository,
      onClienteAdded: _cargarDatosIniciales,
    );
  }

  void _mostrarDialogoEliminarCliente(
    BuildContext context,
    int clienteId,
    String nombreCliente,
  ) {
    DialogService.confirmarEliminarCliente(
      context: context,
      clienteId: clienteId,
      nombreCliente: nombreCliente,
      clienteRepository: _clienteRepository,
      onDeleted: _cargarDatosIniciales,
    );
  }

  void _mostrarDialogoEliminarMembresia(
    BuildContext context,
    int membresiaId,
    String nombreMembresia,
  ) {
    DialogService.confirmarEliminarMembresia(
      context: context,
      membresiaId: membresiaId,
      nombreMembresia: nombreMembresia,
      membresiaRespository: _membresiaRespository,
      onDeleted: _cargarDatosIniciales,
    );
  }

  // CORREGIR ESTO PIPIPI
  Future<void> _mostrarDialogoActualizarMembresia(
    BuildContext context,
    int membresiaId,
    String nombreMembresia,
  ) async {
    await DialogService.confirmarActualizarMembresia(
      context: context,
      membresiaId: membresiaId,
      nombreMembresia: nombreMembresia,
      membresiaRespository: _membresiaRespository,
      onUpdated: _cargarDatosIniciales,
    );
  }

  void _mostrarDialogoAgregarCliente() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddClienteDialog(
          clienteRepository: _clienteRepository,
          onClienteAdded: _cargarDatosIniciales,
        );
      },
    );
  }

  void _mostrarDialogoAgregarMembresia() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMembership(
          membresiaRespository: _membresiaRespository,
          clienteRepository: _clienteRepository,
          onMembershipAdded: _cargarDatosIniciales,
        );
      },
    );
  }

  List<Widget> _buildPages(BuildContext context) => [
    // Vista Home
    HomePageContent.buildHomePage(
      context,
      _clientes,
      _stats,
      _mostrarDialogoAgregarCliente,
      _membresiasPorCliente,
      _onClienteInfoPressed,
      _onEditarClientePressed,
      _mostrarDialogoEliminarCliente,
      _clienteSearchController,
      _filtroClientes,
    ),

    // Vista Membresías
    MemberPageContent.buildHomePage(
      context,
      _membresias,
      _membresiaStats,
      _mostrarDialogoAgregarMembresia,
      _clientesPorMembresia,
      _mostrarDialogoActualizarMembresia,
      _mostrarDialogoEliminarMembresia,
      _membresiaSearchController,
      _filtroMembresias,
    ),

    // Vista Membresías Inactivas
    MemberPageHistory.buildHomePage(
      context,
      _membresiasInactivas,
      _membresiaStats,
      _clientesPorMembresiaInactivas,
      _membresiaInactivaSearchController,
      _filtroMembresiasInactivas,
    ),

    // Vista Backup
    BackupPage.viewBackup(context),

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/image/logo-new.png', height: 30),
            const SizedBox(width: 10),
          ],
        ),
      ),

      body: _buildPages(context)[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _cambiarPestana,
      ),
    );
  }
}
