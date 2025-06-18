import 'package:ego/utils/backup.dart';
import 'package:flutter/material.dart';

class BackupPage {
  static Widget viewBackup(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Backup',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Backup.createBackup(context);
              },
              child: const Text('Crear Backup'),
            ),
          ],
        ),
      ),
    );
  }
}
