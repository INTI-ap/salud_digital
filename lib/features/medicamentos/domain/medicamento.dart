/// Medicamento programado por la persona usuaria.
class Medicamento {
  const Medicamento({
    required this.id,
    required this.nombre,
    required this.dosis,
    required this.hora,
    required this.minuto,
  });

  final String id;
  final String nombre;
  final String dosis;
  final int hora;
  final int minuto;

  /// Hora en formato de 24 horas, por ejemplo «08:05».
  String get horaTexto {
    final hh = hora.toString().padLeft(2, '0');
    final mm = minuto.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}
