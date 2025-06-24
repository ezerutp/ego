import 'package:ego/models/cliente.dart';
import 'package:ego/models/membresia.dart';
import 'package:ego/utils/utils.dart';
import 'package:flutter/material.dart';

// Corregir esto: hay que quitar lo estatico y hacer un constructor
class CardMembershipHistory extends StatelessWidget {
  final Cliente cliente;
  final Membresia membership;

  const CardMembershipHistory({
    super.key,
    required this.cliente,
    required this.membership,
  });

  String get name => '${cliente.nombres} ${cliente.apellidos}';

  String get fechaTexto {
    final fechaFin = membership.fechaFin;
    final fechaCancelada = membership.fechaCancelacion;

    final diasRestantes = fechaFin.difference(DateTime.now()).inDays;

    if (membership.cancelada) {
      if (fechaCancelada != null) {
        return 'Vencía en $diasRestantes días y fue cancelada el : ${Utils.formatDate(fechaCancelada)}';
      } else {
        return 'Vencía en $diasRestantes días y fue cancelada';
      }
    }
    return 'Venció el día : ${Utils.formatDate(fechaFin)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 54, 54, 54),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
        subtitle: Text(
          fechaTexto,
          style: TextStyle(
            color: const Color.fromARGB(255, 206, 206, 206),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
