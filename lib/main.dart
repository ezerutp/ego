import 'package:ego/models/cliente.dart';
import 'package:ego/models/membresia.dart';
import 'package:ego/repository/cliente_repository.dart';
import 'package:ego/repository/membresia_respository.dart';
import 'package:ego/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:ego/widgets/home_page_content.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.black),
      ),
      home: const MyHomePage(title: 'ego'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// This is the private State class that goes with MyHomePage.
class _MyHomePageState extends State<MyHomePage> {

  // Inicializa el repositorio de clientes
  final ClienteRepository _clienteRepository = ClienteRepository();
  final MembresiaRespository _membresiaRespository = MembresiaRespository();
  final Map<int, Membresia?> _membresiasPorCliente = {};
  int _selectedIndex = 0;
  List<Cliente> _clientes = [];
  
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await _initTestData();
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

    // Pre-cargar membresías una vez
    for (var cliente in clientes) {
      Membresia? membresia = await _membresiaRespository
          .getMembresiaByClienteId(cliente.id!);
      _membresiasPorCliente[cliente.id!] = membresia;
    }

    setState(() {
      _clientes = clientes;
    });
  }

  // Inicializa los datos de prueba al cargar la aplicacion
  Future<void> _initTestData() async {
    List<Cliente> clientes = await _clienteRepository.getClientes();
    if (clientes.isEmpty) {
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Isai', apellidos: 'Ticliahuanca'),
      );
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Maria', apellidos: 'Lopez'),
      );
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Carlos', apellidos: 'Gomez'),
      );
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Ana', apellidos: 'Martinez'),
      );
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Luis', apellidos: 'Fernandez'),
      );
      await _clienteRepository.insertCliente(
        Cliente(nombres: 'Sofia', apellidos: 'Ramirez'),
      );
      print('Clientes insertados');
    } else {
      print('Clientes ya existen, no se insertan duplicados');
    }
  }

  void _onAddMemberPressed() {
    // Lógica para añadir un nuevo miembro
    print('Añadir miembro presionado');
  }

  @override
  Widget build(BuildContext context) {
    // Lista de vistas por pestaña
    final List<Widget> _pages = [
      // Vista Home
      HomePageContent.buildHomePage(
        _clientes,
        _onAddMemberPressed,
        _membresiasPorCliente,
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

      body: _pages[_selectedIndex], //

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.darkGray,
        selectedItemColor: AppColors.orange,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}
