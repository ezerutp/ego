import 'dart:io';
import 'package:ego/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ego/models/cliente.dart';
import 'package:ego/models/membresia.dart';
import 'package:ego/repository/cliente_repository.dart';
import 'package:ego/repository/membresia_respository.dart';

class Backup {
  static Future<void> createBackup(BuildContext context) async {
    // Solicitar permisos
    if (!await _requestPermission()) {
      CustomDialogos.mostrarDialogoError(
        context,
        'Permiso denegado',
        'No se pudo guardar el backup porque no se otorgaron permisos de almacenamiento.',
      );
      return;
    }

    List<Cliente> clientes = await ClienteRepository().getTodosClientes();
    List<Membresia> membresias = await MembresiaRespository().getMembresias();

    List<List<String>> clienteCsv = [
      ['ID', 'Apodo', 'Nombre', 'Apellido', 'DNI', 'Celular'],
      ...clientes.map(
        (c) => [
          c.id.toString(),
          c.nombres,
          c.apellidos,
          c.dni ?? '',
          c.celular ?? '',
        ],
      ),
    ];

    List<List<String>> membresiaCsv = [
      [
        'ID',
        'ClienteID',
        'FechaInicio',
        'FechaFin',
        'FechaCancelacion',
        'Cancelada',
        'Tipo',
        'Costo',
      ],
      ...membresias.map(
        (m) => [
          m.id.toString(),
          m.clienteId.toString(),
          m.fechaInicio.toIso8601String(),
          m.fechaFin.toIso8601String(),
          m.fechaCancelacion?.toIso8601String() ?? '',
          m.cancelada ? 'Sí' : 'No',
          m.tipo,
          m.costo?.toString() ?? '',
        ],
      ),
    ];

    // Ruta pública
    Directory externalDir = Directory(
      '/storage/emulated/0/Documents/BackupAppEgo',
    );
    if (!await externalDir.exists()) {
      await externalDir.create(recursive: true);
    }
    String fecha = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String nameClienteCsv = 'clientes_$fecha.csv';
    String nameMembresiaCsv = 'membresias_$fecha.csv';

    File clientesFile = File('${externalDir.path}/$nameClienteCsv');
    File membresiasFile = File('${externalDir.path}/$nameMembresiaCsv');

    await clientesFile.writeAsString(
      const ListToCsvConverter().convert(clienteCsv),
    );
    await membresiasFile.writeAsString(
      const ListToCsvConverter().convert(membresiaCsv),
    );

    // Mostrar diálogo de éxito
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¡Backup exitoso!'),
          content: Text('Los archivos se guardaron en:\n${externalDir.path}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) {
        return true;
      }

      if (await Permission.storage.request().isGranted) {
        return true;
      }

      // Android 11+
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return true; // En iOS u otros, no aplica
  }
}
