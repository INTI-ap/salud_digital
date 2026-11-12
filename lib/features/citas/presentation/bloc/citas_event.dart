import '../../domain/cita.dart';

/// Eventos del bloque de citas.
sealed class CitasEvent {
  const CitasEvent();
}

/// Pide cargar la lista de citas.
final class CargarCitas extends CitasEvent {
  const CargarCitas();
}

/// Pide registrar una cita nueva.
final class CrearCita extends CitasEvent {
  const CrearCita(this.cita);

  final Cita cita;
}

/// Pide eliminar una cita por identificador.
final class EliminarCita extends CitasEvent {
  const EliminarCita(this.id);

  final String id;
}
