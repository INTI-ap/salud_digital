/// Eventos del bloque de sesión.
sealed class SesionEvent {
  const SesionEvent();
}

/// Pide verificar si existe una sesión activa al abrir la aplicación.
final class VerificarSesion extends SesionEvent {
  const VerificarSesion();
}

/// Solicita iniciar sesión con correo y contraseña.
final class IniciarSesion extends SesionEvent {
  const IniciarSesion({
    required this.correo,
    required this.contrasena,
  });

  final String correo;
  final String contrasena;
}

/// Solicita cerrar la sesión actual.
final class CerrarSesion extends SesionEvent {
  const CerrarSesion();
}
