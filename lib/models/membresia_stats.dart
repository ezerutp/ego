class MembresiaStats {
  int? totalMembresias;
  int? totalNormales;
  int? totalPersonalizados;

  MembresiaStats({
    this.totalMembresias,
    this.totalNormales,
    this.totalPersonalizados,
  });

  int? get totalMembresiasValue => totalMembresias;
  int? get totalNormalesValue => totalNormales;
  int? get totalPersonalizadosValue => totalPersonalizados;
  set totalMembresiasValue(int? value) => totalMembresias = value;
  set totalNormalesValue(int? value) => totalNormales = value;
  set totalPersonalizadosValue(int? value) => totalPersonalizados = value;
}
