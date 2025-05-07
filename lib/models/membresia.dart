class Membresia {
  final int? id;
  final int clienteId;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String tipo;
  final double costo;

  Membresia({
    this.id,
    required this.clienteId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.tipo,
    required this.costo,
  });

  bool get estaActiva {
    final ahora = DateTime.now();
    return ahora.isAfter(fechaInicio) && ahora.isBefore(fechaFin);
  }

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
