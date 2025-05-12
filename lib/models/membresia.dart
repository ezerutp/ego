class Membresia {
  int? id;
  int clienteId;
  DateTime fechaInicio;
  DateTime fechaFin;
  String? tipo;
  double? costo;

  Membresia({
    this.id,
    required this.clienteId,
    required this.fechaInicio,
    required this.fechaFin,
    this.tipo,
    this.costo,
  });

  bool get estaActiva {
    final ahora = DateTime.now();
    return ahora.isAfter(fechaInicio) && ahora.isBefore(fechaFin);
  }

  int? get getId => id;
  int get getClienteId => clienteId;
  DateTime get getFechaInicio => fechaInicio;
  DateTime get getFechaFin => fechaFin;
  String? get getTipo => tipo;
  double? get getCosto => costo;
  bool get isPersonalizado => tipo == 'Personalizado' ? true : false;

  set setId(int? value) => id = value;
  set setClienteId(int value) => clienteId = value;
  set setFechaInicio(DateTime value) => fechaInicio = value;
  set setFechaFin(DateTime value) => fechaFin = value;
  set setTipo(String? value) => tipo = value;
  set setCosto(double? value) => costo = value;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'tipo': tipo,
      'costo': costo,
    };
  }

  factory Membresia.fromMap(Map<String, dynamic> map) {
    return Membresia(
      id: map['id'],
      clienteId: map['clienteId'],
      fechaInicio: DateTime.parse(map['fechaInicio']),
      fechaFin: DateTime.parse(map['fechaFin']),
      tipo: map['tipo'],
      costo: map['costo'],
    );
  }
}
