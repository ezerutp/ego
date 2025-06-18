import 'package:ego/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:ego/models/cliente.dart';
import 'package:ego/repository/cliente_repository.dart';

class AddClienteDialog extends StatelessWidget {
  final ClienteRepository clienteRepository;
  final Function onClienteAdded;
  final Cliente? cliente;

  const AddClienteDialog({
    Key? key,
    required this.clienteRepository,
    required this.onClienteAdded,
    this.cliente,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController apodoController = TextEditingController(
      text: cliente?.apodo ?? '',
    );
    final TextEditingController nombreController = TextEditingController(
      text: cliente?.nombres ?? '',
    );
    final TextEditingController apellidoController = TextEditingController(
      text: cliente?.apellidos ?? '',
    );
    final TextEditingController dniController = TextEditingController(
      text: cliente?.dni ?? '',
    );
    final TextEditingController celularController = TextEditingController(
      text: cliente?.celular ?? '',
    );

    return AlertDialog(
      title: Text(cliente == null ? 'Registrar Cliente' : 'Editar Cliente'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: apodoController,
              decoration: const InputDecoration(labelText: 'Apodo'),
            ),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: dniController,
              decoration: const InputDecoration(labelText: 'DNI'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: celularController,
              decoration: const InputDecoration(labelText: 'Celular'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            final String apodo = apodoController.text.trim();
            final String nombre = nombreController.text.trim();
            final String apellido = apellidoController.text.trim();
            final String dni = dniController.text.trim();
            final String celular = celularController.text.trim();

            if (nombre.isNotEmpty &&
                apellido.isNotEmpty &&
                dni.isNotEmpty &&
                celular.isNotEmpty) {
              if (cliente == null) {
                // REGISTRAR
                final nuevoCliente = Cliente(
                  apodo: apodo,
                  nombres: nombre,
                  apellidos: apellido,
                  dni: dni,
                  celular: celular,
                  estado: true,
                );
                await clienteRepository.insertCliente(nuevoCliente);
              } else {
                // EDITAR
                final clienteActualizado = cliente!.copyWith(
                  apodo: apodo,
                  nombres: nombre,
                  apellidos: apellido,
                  dni: dni,
                  celular: celular,
                );
                await clienteRepository.updateCliente(clienteActualizado);
              }
              onClienteAdded();
              Navigator.of(context).pop();
            } else {
              CustomDialogos.mostrarMensaje(
                context: context,
                mensaje: 'Por favor, complete todos los campos.',
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
