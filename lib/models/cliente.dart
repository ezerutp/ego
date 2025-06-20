class Cliente {
  int? id;
  String? apodo;
  String nombres;
  String apellidos;
  String? dni;
  String? celular;
  bool estado = true;

  Cliente({
    this.id,
    this.apodo,
    required this.nombres,
    required this.apellidos,
    this.dni,
    this.celular,
    required this.estado,
  });

  int? get getId => id;
  String? get getApodo => apodo;
  String get getNombres => nombres;
  String get getApellidos => apellidos;
  String? get getDni => dni;
  String? get getCelular => celular;
  bool get getEstado => estado;

  set setId(int? value) => id = value;
  set setApodo(String? value) => apodo = value;
  set setNombres(String value) => nombres = value;
  set setApellidos(String value) => apellidos = value;
  set setDni(String? value) => dni = value;
  set setCelular(String? value) => celular = value;
  set setEstado(bool value) => estado = value;

  Cliente copyWith({
    int? id,
    String? apodo,
    String? nombres,
    String? apellidos,
    String? dni,
    String? celular,
    bool? estado,
  }) {
    return Cliente(
      id: id ?? this.id,
      apodo: apodo ?? this.apodo,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      dni: dni ?? this.dni,
      celular: celular ?? this.celular,
      estado: estado ?? this.estado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'apodo': apodo,
      'nombres': nombres,
      'apellidos': apellidos,
      'dni': dni,
      'celular': celular,
      'estado': estado,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      apodo: map['apodo'],
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      dni: map['dni'],
      celular: map['celular'],
      estado: map['estado'] == 1 ? true : false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cliente && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
