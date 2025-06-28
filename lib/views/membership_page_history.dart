import 'package:ego/models/membresia_stats.dart';
import 'package:ego/widgets/card_membership_history.dart';
import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../models/membresia.dart';
import '../theme/color.dart';

class MemberPageHistory {
  static Widget buildHomePage(
    BuildContext context,
    List<Membresia> membresias,
    MembresiaStats stats,
    Map<int, Cliente?> clientePorMembresia,
    TextEditingController searchController,
    String filtro,
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
          TextField(
            controller: searchController,
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
                  membresias
                      .where((membresia) {
                        final cliente =
                            clientePorMembresia[membresia.clienteId];
                        if (cliente == null) return false;
                        final nombreCompleto =
                            '${cliente.nombres} ${cliente.apellidos}'
                                .toLowerCase();
                        return nombreCompleto.contains(filtro.toLowerCase());
                      })
                      .map((membresia) {
                        var cliente = clientePorMembresia[membresia.clienteId];
                        return CardMembershipHistory(
                          cliente: cliente!,
                          membership: membresia,
                        );
                      })
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
