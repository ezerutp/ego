import 'package:flutter/material.dart';
import 'package:ego/models/cliente.dart';
import 'package:ego/widgets/dialog.dart';
import 'package:ego/widgets/add_cliente.dart';
import 'package:ego/repository/cliente_repository.dart';
import 'package:ego/repository/membresia_respository.dart';
import 'package:ego/utils/utils.dart';

class DialogService {
  static void mostrarInfoCliente(BuildContext context, Cliente cliente) {
    CustomDialogos.mostrarInfoCliente(context: context, cliente: cliente);
  }

  static void editarCliente({
    required BuildContext context,
    required Cliente cliente,
    required ClienteRepository clienteRepository,
    required VoidCallback onClienteAdded,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AddClienteDialog(
            clienteRepository: clienteRepository,
            cliente: cliente,
            onClienteAdded: onClienteAdded,
          ),
    );
  }

  static void confirmarEliminarCliente({
    required BuildContext context,
    required int clienteId,
    required String nombreCliente,
    required ClienteRepository clienteRepository,
    required VoidCallback onDeleted,
  }) {
    CustomDialogos.mostrarEliminar(
      context: context,
      titulo: 'Eliminar cliente',
      mensaje: '¿Está seguro de eliminar a $nombreCliente?',
      onConfirmar: () async {
        await clienteRepository.eliminarCliente(clienteId);
        onDeleted();
      },
    );
  }

  static void confirmarEliminarMembresia({
    required BuildContext context,
    required int membresiaId,
    required String nombreMembresia,
    required MembresiaRespository membresiaRespository,
    required VoidCallback onDeleted,
  }) {
    CustomDialogos.mostrarEliminar(
      context: context,
      titulo: 'Eliminar membresía',
      mensaje: '¿Estas seguro de eliminar $nombreMembresia?',
      onConfirmar: () async {
        await membresiaRespository.cancelarMembresia(membresiaId);
        onDeleted();
      },
    );
  }

  static Future<void> confirmarActualizarMembresia({
    required BuildContext context,
    required int membresiaId,
    required String nombreMembresia,
    required MembresiaRespository membresiaRespository,
    required VoidCallback onUpdated,
  }) async {
    final membresia = await membresiaRespository.getMembresiaById(membresiaId);

    if (membresia == null) {
      CustomDialogos.mostrarMensaje(
        context: context,
        mensaje: 'No se encontró la membresía',
      );
      return;
    }
    CustomDialogos.mostrarAumentarMembresia(
      context: context,
      nombreCliente: nombreMembresia,
      fechaInicio: membresia.fechaInicio,
      fechaFin: membresia.fechaFin,
      onConfirmar: (int meses) async {
        membresia.fechaFin = Utils.sumarMeses(membresia.fechaFin, meses);
        await membresiaRespository.updateMembresia(membresia);
        CustomDialogos.mostrarMensaje(
          context: context,
          mensaje: 'Membresía extendida $meses mes${meses > 1 ? "es" : ""}.',
          backgroundColor: Colors.green,
        );
        onUpdated();
      },
    );
  }
}
