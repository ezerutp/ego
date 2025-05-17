import 'package:intl/intl.dart';

class Utils {
  /// Método para formatear la fecha en el formato deseado
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Método para sumar meses a una fecha
  static DateTime sumarMeses(DateTime fecha, int cantidadMeses) {
    int nuevoMes = fecha.month + cantidadMeses;
    int nuevoAnio = fecha.year + ((nuevoMes - 1) ~/ 12);
    nuevoMes = ((nuevoMes - 1) % 12) + 1;

    int dia = fecha.day;
    // Ajustar el día si el nuevo mes no tiene ese día
    int ultimoDiaDelMes = DateTime(nuevoAnio, nuevoMes + 1, 0).day;
    if (dia > ultimoDiaDelMes) dia = ultimoDiaDelMes;

    return DateTime(nuevoAnio, nuevoMes, dia);
  }
}
