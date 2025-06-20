import 'package:ego/theme/color.dart';
import 'package:ego/utils/backup.dart';
import 'package:flutter/material.dart';

class BackupPage {
  static Widget viewBackup(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Backup',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: const Text(
                'Crea un backup de tus datos para poder restaurarlos en caso de que los pierdas.',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Backup.createBackup(context);
              },
              child: const Text('Crear Backup'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //Backup.restoreBackup(context);
              },
              child: const Text('Restaurar Backup'),
            ),
          ],
        ),
      ),
    );
  }
}
