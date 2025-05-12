import 'package:ego/main.dart';
import 'package:ego/models/cliente.dart';
import 'package:ego/models/cliente_stats.dart';
import 'package:ego/models/membresia_stats.dart';
import 'package:ego/repository/stats_repository.dart';
import 'package:ego/utils/utils.dart';
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
    _getTestData();
  }

  // metodo para el boton
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Recupera los datos de prueba de la base de datos
  void _getTestData() async {
    List<Cliente> clientes = await _clienteRepository.getClientes();
    List<Membresia> membresias =
        await _membresiaRespository.getMembresiasActivas();

    // carga las membresias activas por cliente (para listar en la vista de clientes (Activo - Sin membresia))
    for (var cliente in clientes) {
      Membresia? membresia = await _membresiaRespository
          .getMembresiaActivaByClienteId(cliente.id!);
      _membresiasPorCliente[cliente.id!] = membresia;
    }

    // carga los clientes y los cachea en un mapa (para listar en la vista de membresias)
    for (var membresia in membresias) {
      Cliente? cliente = await _clienteRepository.getClienteById(
        membresia.clienteId,
      );
      _clientesPorMembresia[membresia.clienteId] = cliente;
    }

    ClienteStats? stats = await StatsData.getStatsClientes();
    MembresiaStats? statsMembresia =
        await StatsData.getStatsMembresias(); // obtiene las estadisticas de membresias

    setState(() {
      _membresias = membresias;
      _clientes = clientes;
      _stats = stats;
      _membresiaStats = statsMembresia;
    });
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
        _getTestData(); // actualiza estado con setState()
      },
    );
  }

  void _onAddClientePressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nombreController = TextEditingController();
        final TextEditingController apellidoController =
            TextEditingController();
        final TextEditingController dniController = TextEditingController();
        final TextEditingController celularController = TextEditingController();

        return AlertDialog(
          title: const Text('Añadir Cliente'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: apellidoController,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                ),
                TextField(
                  controller: dniController,
                  decoration: const InputDecoration(labelText: 'DNI'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: celularController,
                  decoration: const InputDecoration(labelText: 'Celular'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final String nombre = nombreController.text.trim();
                final String apellido = apellidoController.text.trim();
                final String dni = dniController.text.trim();
                final String celular = celularController.text.trim();

                if (nombre.isNotEmpty &&
                    apellido.isNotEmpty &&
                    dni.isNotEmpty &&
                    celular.isNotEmpty) {
                  Cliente nuevoCliente = Cliente(
                    nombres: nombre,
                    apellidos: apellido,
                    dni: dni,
                    celular: celular,
                    estado: true,
                  );
                  await _clienteRepository.insertCliente(nuevoCliente);
                  _getTestData(); // Actualiza la lista de clientes
                  Navigator.of(context).pop();
                } else {
                  Utils.mostrarMensaje(
                    context: context,
                    mensaje: 'Por favor, complete todos los campos.',
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _onAddMembershipPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController mesesController = TextEditingController(
          text: '1',
        );
        final TextEditingController costoController = TextEditingController();
        String tipoSeleccionado = 'Normal';
        Cliente? clienteSeleccionado;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Añadir Membresía'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<List<Cliente>>(
                      future:
                          _clienteRepository
                              .getClientesActivosAndSinMebresiaActiva(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error al cargar clientes');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No hay clientes disponibles');
                        } else {
                          return DropdownButton<Cliente>(
                            isExpanded: true,
                            value: clienteSeleccionado,
                            hint: const Text('Seleccione un cliente'),
                            items:
                                snapshot.data!.map((Cliente cliente) {
                                  return DropdownMenuItem<Cliente>(
                                    value: cliente,
                                    child: Text(
                                      '${cliente.nombres} ${cliente.apellidos}',
                                    ),
                                  );
                                }).toList(),
                            onChanged: (Cliente? newValue) {
                              setState(() {
                                clienteSeleccionado = newValue;
                              });
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Meses:'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                int meses =
                                    int.tryParse(mesesController.text) ?? 1;
                                if (meses > 1) {
                                  setState(() {
                                    mesesController.text =
                                        (meses - 1).toString();
                                  });
                                }
                              },
                            ),
                            SizedBox(
                              width: 40,
                              child: TextField(
                                controller: mesesController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                readOnly: true,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                int meses =
                                    int.tryParse(mesesController.text) ?? 1;
                                setState(() {
                                  mesesController.text = (meses + 1).toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: costoController,
                      decoration: const InputDecoration(
                        labelText: 'Costo (opcional)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: tipoSeleccionado,
                      items:
                          ['Normal', 'Personalizado'].map((String tipo) {
                            return DropdownMenuItem<String>(
                              value: tipo,
                              child: Text(tipo),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          tipoSeleccionado = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (clienteSeleccionado != null) {
                      final int meses = int.tryParse(mesesController.text) ?? 1;
                      final double? costo =
                          costoController.text.isNotEmpty
                              ? double.tryParse(costoController.text)
                              : null;
                      int dias = meses * 30; // Convertir meses a días
                      Membresia nuevaMembresia = Membresia(
                        clienteId: clienteSeleccionado!.id!,
                        fechaInicio: DateTime.now(),

                        fechaFin: DateTime.now().add(Duration(days: dias)),
                        costo: costo,
                        tipo: tipoSeleccionado,
                      );

                      await _membresiaRespository.registrarMembresia(
                        nuevaMembresia,
                      );
                      _getTestData(); // Actualiza la lista de membresías
                      Navigator.of(context).pop();
                    } else {
                      Utils.mostrarMensaje(
                        context: context,
                        mensaje: 'Por favor, seleccione un cliente.',
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
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
        _confirmarYEliminarCliente,
      ),

      // Vista Membresías
      MemberPageContent.buildHomePage(
        _membresias,
        _membresiaStats,
        _onAddMembershipPressed,
        _clientesPorMembresia,
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

      bottomNavigationBar: BottomNavigationBar(
        //type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.darkGray,
        selectedItemColor: AppColors.orange,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Miembros'),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            label: 'Membresías',
          ),
          /* BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ), */
        ],
      ),
    );
  }
}
