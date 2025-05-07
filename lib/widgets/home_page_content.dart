import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../models/membresia.dart';
import '../theme/color.dart';

class HomePageContent {
  static Widget buildHomePage(
    List<Cliente> clientes,
    Function onAddMemberPressed,
    Map<int, Membresia?> membresiasPorCliente,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Totales: 40', style: TextStyle(color: Colors.white)),
              Text('Activos: 30', style: TextStyle(color: Colors.white)),
              Text('Vencidos: 10', style: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () => onAddMemberPressed(),
            child: const Text(
              '+ Añadir miembro',
              style: TextStyle(fontSize: 16, color: AppColors.white),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              hintText: 'Buscar miembro',
              hintStyle: const TextStyle(
                color: AppColors.gray,
                fontStyle: FontStyle.italic,
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.white),
              fillColor: AppColors.darkGray,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children:
                  clientes.map((cliente) {
                    var nombreCompleto =
                        '${cliente.nombres} ${cliente.apellidos}';
                    var membresia =
                        membresiasPorCliente[cliente
                            .id];
                    if (membresia != null) {
                      return _buildMemberTile(
                        nombreCompleto,
                        'Activo',
                        membresia.fechaFin.toString(),
                      );
                    } else {
                      return _buildMemberTile(
                        nombreCompleto,
                        'Sin membresía',
                        '',
                      );
                    }
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildMemberTile(String name, String status, String date) {
    return Card(
      color: AppColors.darkGray,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          status,
          style: TextStyle(
            color: status == 'Activo' ? AppColors.green : AppColors.red,
          ),
        ),
        trailing: Text(date, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
