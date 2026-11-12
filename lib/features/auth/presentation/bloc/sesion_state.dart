import '../../domain/usuario.dart';

/// Estados del bloque de sesión.
sealed class SesionState {
  const SesionState();
}

/// Se está comprobando si hay una sesión activa.
final class SesionVerificando extends SesionState {
  const SesionVerificando();
}

/// Se está procesando el inicio de sesión.
final class SesionIniciando extends SesionState {
  const SesionIniciando();
}

/// No hay usuario autenticado.
final class SesionSinUsuario extends SesionState {
  const SesionSinUsuario();
}

/// Hay un usuario autenticado.
final class SesionConUsuario extends SesionState {
  const SesionConUsuario(this.usuario);

  final Usuario usuario;
}

/// Ocurrió un error de autenticación con un mensaje para la persona usuaria.
final class SesionError extends SesionState {
  const SesionError(this.mensaje);

  final String mensaje;
}
