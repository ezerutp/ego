import 'package:flutter/material.dart';
import 'package:ego/models/cliente.dart';
import 'package:ego/repository/cliente_repository.dart';
import 'package:ego/utils/utils.dart';

class AddClienteDialog extends StatelessWidget {
  final ClienteRepository clienteRepository;
  final Function onClienteAdded;

  const AddClienteDialog({
    Key? key,
    required this.clienteRepository,
    required this.onClienteAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController apellidoController = TextEditingController();
    final TextEditingController dniController = TextEditingController();
    final TextEditingController celularController = TextEditingController();

    return AlertDialog(
      title: const Text('Añadir Cliente'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            final String nombre = nombreController.text.trim();
            final String apellido = apellidoController.text.trim();
            final String dni = dniController.text.trim();
            final String celular = celularController.text.trim();

            if (nombre.isNotEmpty &&
                apellido.isNotEmpty &&
                dni.isNotEmpty &&
                celular.isNotEmpty) {
              Cliente nuevoCliente = Cliente(
                nombres: nombre,
                apellidos: apellido,
                dni: dni,
                celular: celular,
                estado: true,
              );
              await clienteRepository.insertCliente(nuevoCliente);
              onClienteAdded();
              Navigator.of(context).pop();
            } else {
              Utils.mostrarMensaje(
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
