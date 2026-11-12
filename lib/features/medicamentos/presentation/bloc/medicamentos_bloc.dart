import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/medicamentos_repository.dart';
import 'medicamentos_event.dart';
import 'medicamentos_state.dart';

/// Bloque de medicamentos.
class MedicamentosBloc
    extends Bloc<MedicamentosEvent, MedicamentosState> {
  MedicamentosBloc(this._repositorio)
      : super(const MedicamentosInicial()) {
    on<CargarMedicamentos>(_alCargar);
    on<CrearMedicamento>(_alCrear);
    on<EliminarMedicamento>(_alEliminar);
  }

  final MedicamentosRepository _repositorio;

  Future<void> _alCargar(
    CargarMedicamentos event,
    Emitter<MedicamentosState> emit,
  ) async {
    emit(const MedicamentosCargando());
    await _refrescar(emit);
  }

  Future<void> _alCrear(
    CrearMedicamento event,
    Emitter<MedicamentosState> emit,
  ) async {
    try {
      await _repositorio.crear(event.medicamento);
      await _refrescar(emit);
    } catch (_) {
      emit(
        const MedicamentosError(
          'No se pudo guardar el medicamento. Intenta nuevamente.',
        ),
      );
    }
  }

  Future<void> _alEliminar(
    EliminarMedicamento event,
    Emitter<MedicamentosState> emit,
  ) async {
    try {
      await _repositorio.eliminar(event.id);
      await _refrescar(emit);
    } catch (_) {
      emit(
        const MedicamentosError('No se pudo eliminar el medicamento.'),
      );
    }
  }

  Future<void> _refrescar(Emitter<MedicamentosState> emit) async {
    try {
      final medicamentos = await _repositorio.listar();
      emit(MedicamentosCargados(medicamentos));
    } catch (_) {
      emit(
        const MedicamentosError('No se pudieron cargar los medicamentos.'),
      );
    }
  }
}
