import 'dart:async';

import '../domain/usuario.dart';
import 'auth_repository.dart';

/// Implementación de demostración para la S1.
///
/// No usa Firebase: permite ejecutar la app y probar el flujo de sesión sin red.
/// En S2 se reemplaza por `AuthFirebaseRepository`.
class AuthRepositorioMemoria implements AuthRepository {
  /// Si [conSesionDemo] es `true`, la app abre con una sesión ya iniciada.
  AuthRepositorioMemoria({bool conSesionDemo = true})
      : _usuario = conSesionDemo ? _usuarioDemo : null;

  static const Usuario _usuarioDemo = Usuario(
    id: 'demo',
    correo: 'demo@uandina.edu.pe',
    nombre: 'Usuario de demostración',
  );

  final StreamController<Usuario?> _controlador =
      StreamController<Usuario?>.broadcast();

  Usuario? _usuario;

  @override
  Future<Usuario?> usuarioActual() async => _usuario;

  @override
  Stream<Usuario?> get cambiosDeSesion => _controlador.stream;

  @override
  Future<Usuario> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (!correo.contains('@')) {
      throw const AuthException('Escribe un correo electrónico válido.');
    }
    if (contrasena.length < 6) {
      throw const AuthException('La contraseña debe tener al menos 6 caracteres.');
    }

    final usuario = Usuario(
      id: correo.toLowerCase(),
      correo: correo.toLowerCase(),
      nombre: correo.split('@').first,
    );
    _usuario = usuario;
    _controlador.add(usuario);
    return usuario;
  }

  @override
  Future<Usuario> registrarse({
    required String correo,
    required String contrasena,
    required String nombre,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (!correo.contains('@')) {
      throw const AuthException('Escribe un correo electrónico válido.');
    }
    if (contrasena.length < 6) {
      throw const AuthException('La contraseña debe tener al menos 6 caracteres.');
    }

    final usuario = Usuario(
      id: correo.toLowerCase(),
      correo: correo.toLowerCase(),
      nombre: nombre.trim().isNotEmpty ? nombre.trim() : correo.split('@').first,
    );
    _usuario = usuario;
    _controlador.add(usuario);
    return usuario;
  }

  @override
  Future<void> cerrarSesion() async {
    _usuario = null;
    _controlador.add(null);
  }

  /// Libera el controlador del stream. Se usa en pruebas.
  Future<void> dispose() => _controlador.close();
}
