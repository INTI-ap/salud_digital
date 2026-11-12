import '../domain/cita.dart';

/// Contrato del repositorio de citas.
///
/// La implementación en memoria se usa en S1; en S4–S6 se reemplaza por
/// Firestore sin modificar el bloque ni la pantalla.
abstract interface class CitasRepository {
  /// Devuelve las citas ordenadas por fecha.
  Future<List<Cita>> listar();

  /// Registra una cita nueva.
  Future<void> crear(Cita cita);

  /// Elimina la cita con el identificador indicado.
  Future<void> eliminar(String id);
}
