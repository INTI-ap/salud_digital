import '../../domain/cita.dart';

/// Estados del bloque de citas.
sealed class CitasState {
  const CitasState();
}

/// Estado inicial, antes de la primera carga.
final class CitasInicial extends CitasState {
  const CitasInicial();
}

/// La lista se está cargando.
final class CitasCargando extends CitasState {
  const CitasCargando();
}

/// La lista se cargó correctamente.
final class CitasCargadas extends CitasState {
  const CitasCargadas(this.citas);

  final List<Cita> citas;
}

/// Ocurrió un error con un mensaje para la persona usuaria.
final class CitasError extends CitasState {
  const CitasError(this.mensaje);

  final String mensaje;
}
