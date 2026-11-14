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

/// Solicita registrar una nueva cuenta de usuario.
final class RegistrarUsuario extends SesionEvent {
  const RegistrarUsuario({
    required this.correo,
    required this.contrasena,
    required this.nombre,
  });

  final String correo;
  final String contrasena;
  final String nombre;
}

/// Solicita cerrar la sesión actual.
final class CerrarSesion extends SesionEvent {
  const CerrarSesion();
}
