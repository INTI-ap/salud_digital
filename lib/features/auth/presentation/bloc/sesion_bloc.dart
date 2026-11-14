import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import 'sesion_event.dart';
import 'sesion_state.dart';

/// Bloque de sesión.
///
/// Recibe el repositorio por constructor: en S1 es una implementación en memoria
/// y en S2 será Firebase Authentication. El bloque no cambia.
class SesionBloc extends Bloc<SesionEvent, SesionState> {
  SesionBloc(this._repositorio) : super(const SesionVerificando()) {
    on<VerificarSesion>(_alVerificar);
    on<IniciarSesion>(_alIniciar);
    on<RegistrarUsuario>(_alRegistrar);
    on<CerrarSesion>(_alCerrar);
  }

  final AuthRepository _repositorio;

  Future<void> _alVerificar(
    VerificarSesion event,
    Emitter<SesionState> emit,
  ) async {
    emit(const SesionVerificando());
    try {
      final usuario = await _repositorio.usuarioActual();
      emit(
        usuario == null
            ? const SesionSinUsuario()
            : SesionConUsuario(usuario),
      );
    } catch (_) {
      emit(const SesionError('No se pudo verificar la sesión.'));
    }
  }

  Future<void> _alIniciar(
    IniciarSesion event,
    Emitter<SesionState> emit,
  ) async {
    emit(const SesionIniciando());
    try {
      final usuario = await _repositorio.iniciarSesion(
        correo: event.correo,
        contrasena: event.contrasena,
      );
      emit(SesionConUsuario(usuario));
    } on AuthException catch (error) {
      emit(SesionError(error.mensaje));
    } catch (_) {
      emit(const SesionError('No se pudo iniciar sesión. Intenta nuevamente.'));
    }
  }

  Future<void> _alRegistrar(
    RegistrarUsuario event,
    Emitter<SesionState> emit,
  ) async {
    emit(const SesionIniciando());
    try {
      final usuario = await _repositorio.registrarse(
        correo: event.correo,
        contrasena: event.contrasena,
        nombre: event.nombre,
      );
      emit(SesionConUsuario(usuario));
    } on AuthException catch (error) {
      emit(SesionError(error.mensaje));
    } catch (_) {
      emit(const SesionError('No se pudo crear la cuenta. Intenta nuevamente.'));
    }
  }

  Future<void> _alCerrar(
    CerrarSesion event,
    Emitter<SesionState> emit,
  ) async {
    try {
      await _repositorio.cerrarSesion();
      emit(const SesionSinUsuario());
    } catch (_) {
      emit(const SesionError('No se pudo cerrar la sesión.'));
    }
  }
}
