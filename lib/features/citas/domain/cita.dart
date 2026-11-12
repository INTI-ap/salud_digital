/// Cita médica del adulto mayor.
///
/// Entidad de dominio: no depende de Flutter ni de Firebase.
class Cita {
  const Cita({
    required this.id,
    required this.especialidad,
    required this.fechaHora,
    this.nota,
  });

  final String id;
  final String especialidad;
  final DateTime fechaHora;
  final String? nota;
}
