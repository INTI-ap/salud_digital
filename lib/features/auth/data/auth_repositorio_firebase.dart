import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../domain/usuario.dart';
import 'auth_repository.dart';

/// Implementación de [AuthRepository] respaldada por Firebase Authentication (S2).
class AuthRepositorioFirebase implements AuthRepository {
  AuthRepositorioFirebase({fb.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _firebaseAuth;

  @override
  Future<Usuario?> usuarioActual() async {
    final user = _firebaseAuth.currentUser;
    return user != null ? _mapearUsuario(user) : null;
  }

  @override
  Stream<Usuario?> get cambiosDeSesion =>
      _firebaseAuth.authStateChanges().map(
            (user) => user != null ? _mapearUsuario(user) : null,
          );

  @override
  Future<Usuario> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final credencial = await _firebaseAuth.signInWithEmailAndPassword(
        email: correo.trim(),
        password: contrasena,
      );
      final user = credencial.user;
      if (user == null) {
        throw const AuthException('No se pudo autenticar al usuario.');
      }
      return _mapearUsuario(user);
    } on fb.FirebaseAuthException catch (error) {
      throw AuthException(_mapearError(error));
    } catch (error) {
      if (error is AuthException) rethrow;
      throw AuthException('No se pudo iniciar sesión: $error');
    }
  }

  @override
  Future<Usuario> registrarse({
    required String correo,
    required String contrasena,
    required String nombre,
  }) async {
    try {
      final credencial = await _firebaseAuth.createUserWithEmailAndPassword(
        email: correo.trim(),
        password: contrasena,
      );
      final user = credencial.user;
      if (user == null) {
        throw const AuthException('No se pudo registrar al usuario.');
      }
      final nombreLimpio = nombre.trim();
      if (nombreLimpio.isNotEmpty) {
        await user.updateDisplayName(nombreLimpio);
      }
      return _mapearUsuario(user, nombreFallback: nombreLimpio);
    } on fb.FirebaseAuthException catch (error) {
      throw AuthException(_mapearError(error));
    } catch (error) {
      if (error is AuthException) rethrow;
      throw AuthException('No se pudo registrar la cuenta: $error');
    }
  }

  @override
  Future<void> cerrarSesion() async {
    try {
      await _firebaseAuth.signOut();
    } on fb.FirebaseAuthException catch (error) {
      throw AuthException(_mapearError(error));
    } catch (error) {
      throw AuthException('No se pudo cerrar la sesión: $error');
    }
  }

  Usuario _mapearUsuario(fb.User user, {String? nombreFallback}) {
    final displayName = user.displayName?.trim();
    final nombre = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : ((nombreFallback != null && nombreFallback.trim().isNotEmpty)
            ? nombreFallback.trim()
            : (user.email?.split('@').first ?? 'Usuario'));

    return Usuario(
      id: user.uid,
      correo: user.email ?? '',
      nombre: nombre,
    );
  }

  String _mapearError(fb.FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'No existe una cuenta registrada con este correo.';
      case 'wrong-password':
        return 'La contraseña es incorrecta.';
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos. Verifica tus datos.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta registrada con este correo electrónico.';
      case 'invalid-email':
        return 'El correo electrónico ingresado no tiene un formato válido.';
      case 'weak-password':
        return 'La contraseña es muy débil. Debe tener al menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'El acceso con correo y contraseña no está habilitado en Firebase Console.';
      case 'user-disabled':
        return 'Esta cuenta de usuario ha sido inhabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Intenta nuevamente más tarde.';
      case 'network-request-failed':
        return 'Sin conexión a internet. Verifica tu red e intenta otra vez.';
      default:
        return error.message ?? 'Error de autenticación (${error.code}).';
    }
  }
}
