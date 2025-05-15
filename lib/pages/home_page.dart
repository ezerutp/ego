import 'package:ego/main.dart';
import 'package:ego/models/cliente.dart';
import 'package:ego/models/cliente_stats.dart';
import 'package:ego/models/membresia_stats.dart';
import 'package:ego/repository/stats_repository.dart';
import 'package:ego/utils/utils.dart';
import 'package:ego/widgets/add_cliente.dart';
import 'package:ego/widgets/add_membership.dart';
import 'package:ego/widgets/button_navigation.dart';
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
  // mapas para datos cacheados
  final Map<int, Membresia?> _membresiasPorCliente = {};
  final Map<int, Cliente?> _clientesPorMembresia = {};

  // Variables para el estado de la aplicación
  int _selectedIndex = 0;
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

  // Listas para almacenar los datos de clientes y membresías
  List<Cliente> _clientes = [];
  List<Membresia> _membresias = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //Test test = Test();
    //await test.initTestData(); // Inicializa los datos de prueba
    //await test.insertMembresias(); // Inserta membresías de prueba
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
    await _cargarClientes();
    await _cargarMembresias();
    await _cargarEstadisticas();
  }

  Future<void> _cargarClientes() async {
    List<Cliente> clientes = await _clienteRepository.getClientes();
    for (var cliente in clientes) {
      Membresia? membresia = await _membresiaRespository
          .getMembresiaActivaByClienteId(cliente.id!);
      _membresiasPorCliente[cliente.id!] = membresia;
    }
    setState(() {
      _clientes = clientes;
    });
  }

  Future<void> _cargarMembresias() async {
    List<Membresia> membresias =
        await _membresiaRespository.getMembresiasActivas();
    for (var membresia in membresias) {
      Cliente? cliente = await _clienteRepository.getClienteById(
        membresia.clienteId,
      );
      _clientesPorMembresia[membresia.clienteId] = cliente;
    }
    setState(() {
      _membresias = membresias;
    });
  }

  Future<void> _cargarEstadisticas() async {
    ClienteStats? stats = await StatsData.getStatsClientes();
    MembresiaStats? statsMembresia = await StatsData.getStatsMembresias();
    setState(() {
      _stats = stats;
      _membresiaStats = statsMembresia;
    });
  }

  void _onClienteInfoPressed(BuildContext context, int clienteId) {
    final cliente = _clientes.firstWhere((c) => c.id == clienteId);
    Utils.mostrarDialogoInformacionCliente(context: context, cliente: cliente);
  }

  void _confirmarYEliminarCliente(
    BuildContext context,
    int clienteId,
    String nombreCliente,
  ) {
    Utils.mostrarDialogoEliminar(
      context: context,
      nombreCliente: nombreCliente,
      onConfirmar: () async {
        await _clienteRepository.eliminarCliente(clienteId);
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
      Utils.mostrarMensaje(
        context: context,
        mensaje: 'No se encontró la membresía',
      );
      return;
    }
    Utils.mostrarDialogoAumentarMembresia(
      context: context,
      nombreCliente: nombreMembresia,
      fechaInicio: membresia.fechaInicio,
      fechaFin: membresia.fechaFin,
      onConfirmar: (int meses) async {
        membresia.fechaFin = Utils.sumarMeses(membresia.fechaFin, meses);

        await _membresiaRespository.updateMembresia(membresia);

        Utils.mostrarMensaje(
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
