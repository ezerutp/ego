import 'package:ego/models/cliente.dart';
import 'package:ego/theme/color.dart';
import 'package:flutter/material.dart';

class CardCliente extends StatelessWidget {
  final Cliente cliente;
  final bool tieneMembresia;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onInfo;

  const CardCliente({
    super.key,
    required this.cliente,
    required this.tieneMembresia,
    this.onEdit,
    this.onDelete,
    this.onInfo,
  });

  String get nombreCompleto => '${cliente.nombres} ${cliente.apellidos}';

  String get status => tieneMembresia ? 'Activo' : 'Sin membresía';

  /// Método para construir la página de inicio (las cards de los clientes)
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.darkGray,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          nombreCompleto,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          status,
          style: TextStyle(
            color: status == 'Activo' ? AppColors.green : AppColors.red,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.info, color: AppColors.gold),
              onPressed: onInfo ?? () {},
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit ?? () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}
