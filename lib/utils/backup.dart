import 'dart:io';
import 'package:ego/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
//import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ego/models/cliente.dart';
import 'package:ego/models/membresia.dart';
import 'package:ego/repository/cliente_repository.dart';
import 'package:ego/repository/membresia_respository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Backup {
  static Future<void> createBackup(BuildContext context) async {
    // Solicitar permisos solo si es Android 9 o menos
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
      ['ID', 'Apodo', 'Nombre', 'Apellido', 'DNI', 'Celular', 'Estado'],
      ...clientes.map(
        (c) => [
          c.id.toString(),
          c.apodo ?? '',
          c.nombres,
          c.apellidos,
          c.dni ?? '',
          c.celular ?? '',
          c.estado ? 'Activo' : 'Inactivo',
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

    // Usar path_provider para obtener ruta segura
    Directory? baseDir = await getExternalStorageDirectory();
    if (baseDir == null) {
      CustomDialogos.mostrarDialogoError(
        context,
        'Error',
        'No se pudo acceder al almacenamiento.',
      );
      return;
    }

    final backupDir = Directory('${baseDir.path}/BackupAppEgo');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    //String fecha = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    // Nombres de archivos con fecha
    //String nameClienteCsv = 'c_$fecha.csv';
    //String nameMembresiaCsv = 'm_$fecha.csv';.

    String nameClienteCsv = 'clientes.csv';
    String nameMembresiaCsv = 'membresias.csv';

    File clientesFile = File('${backupDir.path}/$nameClienteCsv');
    File membresiasFile = File('${backupDir.path}/$nameMembresiaCsv');

    await clientesFile.writeAsString(
      const ListToCsvConverter().convert(clienteCsv),
    );
    await membresiasFile.writeAsString(
      const ListToCsvConverter().convert(membresiaCsv),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¡Backup exitoso!'),
          content: Text('Los archivos se guardaron en:\n${backupDir.path}'),
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
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt <= 28) {
        // Android 9 o menor
        return await Permission.storage.request().isGranted;
      } else {
        // Android 10+ usa scoped storage, no necesitas permiso
        return true;
      }
    }

    return true; // iOS u otros
  }
}
