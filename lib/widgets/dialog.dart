import 'package:ego/models/cliente.dart';
import 'package:ego/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomDialogos {
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

  static void mostrarDialogoError(
    BuildContext context,
    String titulo,
    String mensaje,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  static void mostrarEliminar({
    required BuildContext context,
    required String titulo,
    required String mensaje,
    required VoidCallback onConfirmar,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(titulo),
            content: Text(mensaje),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Confirmar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirmar();
                },
              ),
            ],
          ),
    );
  }

  static void mostrarInfoCliente({
    required BuildContext context,
    required Cliente cliente,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Información del cliente'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (cliente.getApodo != null &&
                    cliente.getApodo!.isNotEmpty) ...[
                  Text('Apodo: ${cliente.getApodo}'),
                  const SizedBox(height: 8),
                ],
                Text('Nombre: ${cliente.getNombres} ${cliente.getApellidos}'),
                const SizedBox(height: 8),
                Text('DNI: ${cliente.getDni ?? 'No disponible'}'),
                const SizedBox(height: 8),
                Text('Teléfono: ${cliente.getCelular ?? 'No disponible'}'),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  static void mostrarAumentarMembresia({
    required BuildContext context,
    required String nombreCliente,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required Function(int meses) onConfirmar,
  }) {
    int mesesAumentar = 1;
    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Aumentar membresía'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cliente: $nombreCliente'),
                      Text('Inicio: ${Utils.formatDate(fechaInicio)}'),
                      Text('Fin actual: ${Utils.formatDate(fechaFin)}'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Meses:'),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (mesesAumentar > 1) {
                                    setState(() => mesesAumentar--);
                                  }
                                },
                              ),
                              Text('$mesesAumentar'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed:
                                    () => setState(() => mesesAumentar++),
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text('Confirmar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirmar(mesesAumentar);
                      },
                    ),
                  ],
                ),
          ),
    );
  }
}
