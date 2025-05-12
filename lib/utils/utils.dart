import 'package:ego/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  /// Método para formatear la fecha en el formato deseado
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Método para construir la página de inicio (las cards de los miembros)
  static Widget buildMembershipTile(
    String name,
    String status,
    DateTime? date,
    bool isPersonalizado,
  ) {
    return Card(
      color: isPersonalizado ? AppColors.gold : AppColors.darkGray,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(
            color: isPersonalizado ? AppColors.black : Colors.white,
            fontWeight: isPersonalizado ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          status,
          style: TextStyle(
            color: isPersonalizado ? AppColors.black : AppColors.green,
            fontWeight: isPersonalizado ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.update,
            color: isPersonalizado ? AppColors.black : AppColors.white,
          ),
          onPressed: () {
            print('Extender membresía de $name');
          },
        ),
      ),
    );
  }

  /// Método para construir la página de inicio (las cards de los clientes)
  static Widget buildClienteTile(
    int? id,
    String name,
    String status,
    BuildContext context, {
    VoidCallback? onEdit,
    VoidCallback? onDelete,
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
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed:
                  onEdit ??
                  () {
                    print('Editar $name');
                  },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed:
                  onDelete ??
                  () {
                    mostrarDialogoEliminar(
                      context: context,
                      nombreCliente: name,
                      onConfirmar: () {},
                    );
                  },
            ),
          ],
        ),
      ),
    );
  }

  /// Método para mostrar un modal de confirmación para eliminar un cliente
  /// Le pasamos el contexto de la página, el nombre del cliente y la función a ejecutar al confirmar
  static void mostrarDialogoEliminar({
    required BuildContext context,
    required String nombreCliente,
    required VoidCallback onConfirmar,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Deseas eliminar al cliente "$nombreCliente"?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el modal
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el modal
                onConfirmar(); // Ejecuta la acción de eliminar
              },
            ),
          ],
        );
      },
    );
  }

  /// Método para mostrar un mensaje en un SnackBar
  static void mostrarMensaje({
    required BuildContext context,
    required String mensaje,
    Color backgroundColor = Colors.red,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
