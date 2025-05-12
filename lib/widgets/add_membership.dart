import 'package:ego/models/cliente.dart';
import 'package:ego/models/membresia.dart';
import 'package:ego/repository/cliente_repository.dart';
import 'package:ego/repository/membresia_respository.dart';
import 'package:ego/utils/utils.dart';
import 'package:flutter/material.dart';

class AddMembership extends StatefulWidget {
  final MembresiaRespository membresiaRespository;
  final ClienteRepository clienteRepository;
  final Function onMembershipAdded;

  const AddMembership({
    super.key,
    required this.membresiaRespository,
    required this.clienteRepository,
    required this.onMembershipAdded,
  });

  @override
  _AddMembershipState createState() => _AddMembershipState();
}

class _AddMembershipState extends State<AddMembership> {
  late TextEditingController mesesController;
  late TextEditingController costoController;
  String tipoSeleccionado = 'Normal';
  Cliente? clienteSeleccionado;

  @override
  void initState() {
    super.initState();
    mesesController = TextEditingController(text: '1');
    costoController = TextEditingController();
  }

  @override
  void dispose() {
    mesesController.dispose();
    costoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Añadir Membresía'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<List<Cliente>>(
              future:
                  widget.clienteRepository
                      .getClientesActivosAndSinMebresiaActiva(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error al cargar clientes');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay clientes disponibles');
                } else {
                  return DropdownButton<Cliente>(
                    isExpanded: true,
                    value: clienteSeleccionado,
                    hint: const Text('Seleccione un cliente'),
                    items:
                        snapshot.data!.map((Cliente cliente) {
                          return DropdownMenuItem<Cliente>(
                            value: cliente,
                            child: Text(
                              '${cliente.nombres} ${cliente.apellidos}',
                            ),
                          );
                        }).toList(),
                    onChanged: (Cliente? newValue) {
                      setState(() {
                        clienteSeleccionado = newValue;
                      });
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Meses:'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        int meses = int.tryParse(mesesController.text) ?? 1;
                        if (meses > 1) {
                          setState(() {
                            mesesController.text = (meses - 1).toString();
                          });
                        }
                      },
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: mesesController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        int meses = int.tryParse(mesesController.text) ?? 1;
                        setState(() {
                          mesesController.text = (meses + 1).toString();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: costoController,
              decoration: const InputDecoration(labelText: 'Costo (opcional)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: tipoSeleccionado,
              items:
                  ['Normal', 'Personalizado'].map((String tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  tipoSeleccionado = newValue!;
                });
              },
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
            if (clienteSeleccionado != null) {
              final int meses = int.tryParse(mesesController.text) ?? 1;
              final double? costo =
                  costoController.text.isNotEmpty
                      ? double.tryParse(costoController.text)
                      : null;
              int dias = meses * 30; // Convertir meses a días
              Membresia nuevaMembresia = Membresia(
                clienteId: clienteSeleccionado!.id!,
                fechaInicio: DateTime.now(),
                fechaFin: DateTime.now().add(Duration(days: dias)),
                costo: costo,
                tipo: tipoSeleccionado,
              );

              await widget.membresiaRespository.registrarMembresia(
                nuevaMembresia,
              );
              widget
                  .onMembershipAdded(); // Notificar que se añadió una membresía
              Navigator.of(context).pop();
            } else {
              Utils.mostrarMensaje(
                context: context,
                mensaje: 'Por favor, seleccione un cliente.',
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
