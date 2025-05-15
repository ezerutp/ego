import 'package:ego/models/cliente.dart';
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
    BuildContext context, {
    VoidCallback? onEdit,
    VoidCallback? onUpdate,
  }) {
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
          onPressed: onUpdate ?? () {},
        ),
      ),
    );
  }

  static void mostrarDialogoAumentarMembresia({
    required BuildContext context,
    required String nombreCliente,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required Function(int meses) onConfirmar,
  }) {
    int mesesAumentar = 1;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Aumentar membresía'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cliente: $nombreCliente'),
                  const SizedBox(height: 8),
                  Text('Fecha de inicio: ${Utils.formatDate(fechaInicio)}'),
                  Text('Fecha de fin actual: ${Utils.formatDate(fechaFin)}'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Meses a aumentar:'),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (mesesAumentar > 1) {
                                setState(() {
                                  mesesAumentar--;
                                });
                              }
                            },
                          ),
                          Text('$mesesAumentar'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                mesesAumentar++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                TextButton(
                  child: const Text('Confirmar'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    onConfirmar(mesesAumentar);
                  },
                ),
              ],
            );
          },
        );
      },
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
            /* IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed:
                  onEdit ??
                  () {
                    print('Editar $name');
                  },
            ), */
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete ?? () {},
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
          content: Text('¿Deseas eliminar al cliente $nombreCliente?'),
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

  static void mostrarDialogoInformacionCliente({
    required BuildContext context,
    required Cliente cliente,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Información del cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${cliente.getNombres} ${cliente.getApellidos}'),
              const SizedBox(height: 8),
              Text('DNI: ${cliente.getDni ?? 'No disponible'}'),
              const SizedBox(height: 8),
              Text('Celular: ${cliente.getCelular ?? 'No disponible'}'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
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

  /// Alias para formatDate en español
  static String formatearFecha(DateTime fecha) {
    return formatDate(fecha);
  }

  /// Método para sumar meses a una fecha
  static DateTime sumarMeses(DateTime fecha, int cantidadMeses) {
    int nuevoMes = fecha.month + cantidadMeses;
    int nuevoAnio = fecha.year + ((nuevoMes - 1) ~/ 12);
    nuevoMes = ((nuevoMes - 1) % 12) + 1;

    int dia = fecha.day;
    // Ajustar el día si el nuevo mes no tiene ese día
    int ultimoDiaDelMes = DateTime(nuevoAnio, nuevoMes + 1, 0).day;
    if (dia > ultimoDiaDelMes) dia = ultimoDiaDelMes;

    return DateTime(nuevoAnio, nuevoMes, dia);
  }
}
