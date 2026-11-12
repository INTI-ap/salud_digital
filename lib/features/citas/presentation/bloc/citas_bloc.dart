import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/citas_repository.dart';
import 'citas_event.dart';
import 'citas_state.dart';

/// Bloque de citas.
///
/// Toda la lógica pasa por el repositorio inyectado; la interfaz solo agrega
/// eventos y muestra estados.
class CitasBloc extends Bloc<CitasEvent, CitasState> {
  CitasBloc(this._repositorio) : super(const CitasInicial()) {
    on<CargarCitas>(_alCargar);
    on<CrearCita>(_alCrear);
    on<EliminarCita>(_alEliminar);
  }

  final CitasRepository _repositorio;

  Future<void> _alCargar(
    CargarCitas event,
    Emitter<CitasState> emit,
  ) async {
    emit(const CitasCargando());
    await _refrescar(emit);
  }

  Future<void> _alCrear(
    CrearCita event,
    Emitter<CitasState> emit,
  ) async {
    try {
      await _repositorio.crear(event.cita);
      await _refrescar(emit);
    } catch (_) {
      emit(const CitasError('No se pudo guardar la cita. Intenta nuevamente.'));
    }
  }

  Future<void> _alEliminar(
    EliminarCita event,
    Emitter<CitasState> emit,
  ) async {
    try {
      await _repositorio.eliminar(event.id);
      await _refrescar(emit);
    } catch (_) {
      emit(const CitasError('No se pudo eliminar la cita.'));
    }
  }

  Future<void> _refrescar(Emitter<CitasState> emit) async {
    try {
      final citas = await _repositorio.listar();
      emit(CitasCargadas(citas));
    } catch (_) {
      emit(const CitasError('No se pudieron cargar las citas.'));
    }
  }
}
