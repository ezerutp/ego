import 'package:ego/models/cliente_stats.dart';
import 'package:ego/widgets/card_cliente.dart';
import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../models/membresia.dart';
import '../theme/color.dart';

class HomePageContent {
  static Widget buildHomePage(
    BuildContext context,
    List<Cliente> clientes,
    ClienteStats stats,
    Function onAddClientePressed,
    Map<int, Membresia?> membresiasPorCliente,
    Function(BuildContext context, int clienteId) onInformacionCliente,
    Function(BuildContext context, int clienteId) onEditarCliente,
    Function(BuildContext context, int id, String nombre) onEliminarCliente,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Totales: ${stats.totalActivosValue}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Activos: ${stats.conMembresiaValue}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Vencidos: ${stats.sinMembresiaValue}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () => onAddClientePressed(),
            child: const Text(
              '+ Añadir cliente',
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
                    final tieneMembresia =
                        membresiasPorCliente[cliente.id] != null;
                    return CardCliente(
                      cliente: cliente,
                      tieneMembresia: tieneMembresia,
                      onInfo: () => onInformacionCliente(context, cliente.id!),
                      onEdit: () => onEditarCliente(context, cliente.id!),
                      onDelete:
                          () => onEliminarCliente(
                            context,
                            cliente.id!,
                            '${cliente.nombres} ${cliente.apellidos}',
                          ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
