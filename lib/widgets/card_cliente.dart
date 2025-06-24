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
  String get status => tieneMembresia ? 'ACTIVO' : 'SIN MEMBRESÍA';

  /// Método para construir la página de inicio (las cards de los clientes)
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.darkGray,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text.rich(
          TextSpan(
            children: [
              if (cliente.apodo?.trim().isNotEmpty == true)
                TextSpan(
                  text: '${cliente.apodo!.toUpperCase()} • ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    fontSize: 13.5,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.cyanAccent.withValues(alpha: 0.8),
                        offset: Offset(0, 0),
                      ),
                      Shadow(
                        blurRadius: 20.0,
                        color: Colors.cyanAccent.withValues(alpha: 0.6),
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              TextSpan(
                text: nombreCompleto,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        subtitle: Text(
          status,
          style: TextStyle(
            color: status == 'ACTIVO' ? AppColors.green : AppColors.red,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.info, color: Colors.green),
              onPressed: onInfo ?? () {},
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.yellow),
              onPressed: onEdit ?? () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: onDelete ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}
