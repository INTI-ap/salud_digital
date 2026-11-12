/// Utilidades de formato de fechas en español.
///
/// Se escriben a mano para no agregar una dependencia de internacionalización en
/// la base del proyecto. En S3 se puede migrar a `intl` si el equipo lo requiere.
library;

const List<String> _dias = <String>[
  'lunes',
  'martes',
  'miércoles',
  'jueves',
  'viernes',
  'sábado',
  'domingo',
];

const List<String> _meses = <String>[
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

String _dosDigitos(int valor) => valor.toString().padLeft(2, '0');

/// Ejemplo: «martes 10 de noviembre · 16:00».
String formatearFechaHora(DateTime fecha) {
  final dia = _dias[fecha.weekday - 1];
  final mes = _meses[fecha.month - 1];
  return '$dia ${fecha.day} de $mes · '
      '${_dosDigitos(fecha.hour)}:${_dosDigitos(fecha.minute)}';
}

/// Ejemplo: «10/11/2026».
String formatearFechaCorta(DateTime fecha) {
  return '${_dosDigitos(fecha.day)}/${_dosDigitos(fecha.month)}/${fecha.year}';
}

/// Ejemplo: «08:05».
String formatearHora(int hora, int minuto) {
  return '${_dosDigitos(hora)}:${_dosDigitos(minuto)}';
}
