import '../domain/usuario.dart';

/// Error de autenticación con un mensaje apto para la persona usuaria.
class AuthException implements Exception {
  const AuthException(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}

/// Contrato de autenticación.
///
/// En S1 lo implementa [AuthRepositorioMemoria]; en S2 se reemplaza por una
/// implementación basada en Firebase Authentication sin cambiar el bloque ni la
/// pantalla de acceso.
abstract interface class AuthRepository {
  /// Devuelve el usuario de la sesión actual o `null` si no hay sesión.
  Future<Usuario?> usuarioActual();

  /// Emite el usuario cuando la sesión cambia (inicio o cierre).
  Stream<Usuario?> get cambiosDeSesion;

  /// Inicia sesión y devuelve el usuario autenticado.
  ///
  /// Lanza [AuthException] cuando las credenciales no son válidas.
  Future<Usuario> iniciarSesion({
    required String correo,
    required String contrasena,
  });

  /// Cierra la sesión actual.
  Future<void> cerrarSesion();
}
