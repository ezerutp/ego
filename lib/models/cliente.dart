class Cliente {
  int? id;
  String nombres;
  String apellidos;
  String? dni;
  String? celular;

  Cliente({
    this.id,
    required this.nombres,
    required this.apellidos,
    this.dni,
    this.celular,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'dni': dni,
      'celular': celular,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      dni: map['dni'],
      celular: map['celular'],
    );
  }
}
