import 'package:ego/theme/color.dart';
import 'package:flutter/material.dart';

class CardCliente {
  /// Método para construir la página de inicio (las cards de los clientes)
  static Widget buildClienteTile(
    String name,
    String status, {
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onInfo,
  }) {
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.info, color: AppColors.gold),
              onPressed: onInfo ?? () {},
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed:
                  onEdit ??
                  () {
                    print('Editar $name');
                  },
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
