import 'package:ego/models/membresia_stats.dart';
import 'package:ego/widgets/card_membership.dart';
import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../models/membresia.dart';
import '../theme/color.dart';

class MemberPageContent {
  static Widget buildHomePage(
    BuildContext context,
    List<Membresia> membresias,
    MembresiaStats stats,
    Function onAddMembershipPressed,
    Map<int, Cliente?> clientePorMembresia,
    Function(BuildContext context, int id, String nombre) actualizarMembresia,
    Function(BuildContext context, int id, String nombre) eliminarMembresia,
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
                'Totales: ${stats.totalMembresiasValue}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Normales: ${stats.totalNormalesValue}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Personalizados: ${stats.totalPersonalizadosValue}',
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
            onPressed: () => onAddMembershipPressed(),
            child: const Text(
              '+ Añadir membresía',
              style: TextStyle(fontSize: 16, color: AppColors.white),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              hintText: 'Buscar membresía',
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
                  membresias.map((membresia) {
                    var cliente = clientePorMembresia[membresia.clienteId];
                    return CardMembership(
                      cliente: cliente!,
                      membership: membresia,
                      onUpdate:
                          () => actualizarMembresia(
                            context,
                            membresia.id!,
                            '${cliente.nombres} ${cliente.apellidos}',
                          ),
                      onDelete:
                          () => eliminarMembresia(
                            context,
                            membresia.id!,
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
