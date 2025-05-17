import 'package:ego/models/cliente.dart';
import 'package:ego/models/membresia.dart';
import 'package:ego/theme/color.dart';
import 'package:ego/utils/utils.dart';
import 'package:flutter/material.dart';

// Corregir esto: hay que quitar lo estatico y hacer un constructor
class CardMembership extends StatelessWidget {
  final Cliente cliente;
  final Membresia membership;
  final VoidCallback? onEdit;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;

  const CardMembership({
    super.key,
    required this.cliente,
    required this.membership,
    this.onEdit,
    this.onUpdate,
    this.onDelete,
  });

  bool get isPersonalizado => membership.tipo == 'Personalizado';

  String get name => '${cliente.nombres} ${cliente.apellidos}';

  String get fechaTexto {
    final fechaFin = membership.fechaFin;
    final diasRestantes = fechaFin.difference(DateTime.now()).inDays;
    if (diasRestantes == 0) {
      return '${Utils.formatDate(fechaFin)} • ¡Vence hoy!';
    } else {
      return '${Utils.formatDate(fechaFin)} • Faltan $diasRestantes días';
    }
  }

  @override
  Widget build(BuildContext context) {
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
          fechaTexto,
          style: TextStyle(
            color: isPersonalizado ? AppColors.black : AppColors.green,
            fontWeight: isPersonalizado ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.update,
                color: isPersonalizado ? AppColors.black : AppColors.white,
              ),
              onPressed: onUpdate ?? () {},
            ),
            IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: isPersonalizado ? AppColors.black : AppColors.white,
              ),
              onPressed:
                  onDelete ??
                  () {
                    print('Eliminar $name');
                  },
            ),
          ],
        ),
      ),
    );
  }
}
