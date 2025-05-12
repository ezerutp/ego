class ClienteStats {
  int? totalReal;
  int? totalActivos;
  int? conMembresia;
  int? sinMembresia;

  ClienteStats({
    this.totalReal,
    this.totalActivos,
    this.conMembresia,
    this.sinMembresia,
  });

  int? get totalRealValue => totalReal;
  int? get totalActivosValue => totalActivos;
  int? get conMembresiaValue => conMembresia;
  int? get sinMembresiaValue => sinMembresia;

  set totalRealValue(int? value) => totalReal = value;
  set totalActivosValue(int? value) => totalActivos = value;
  set sinMembresiaValue(int? value) => sinMembresia = value;
  set conMembresiaValue(int? value) => conMembresia = value;
}
