import '../../domain/medicamento.dart';

/// Estados del bloque de medicamentos.
sealed class MedicamentosState {
  const MedicamentosState();
}

final class MedicamentosInicial extends MedicamentosState {
  const MedicamentosInicial();
}

final class MedicamentosCargando extends MedicamentosState {
  const MedicamentosCargando();
}

final class MedicamentosCargados extends MedicamentosState {
  const MedicamentosCargados(this.medicamentos);

  final List<Medicamento> medicamentos;
}

final class MedicamentosError extends MedicamentosState {
  const MedicamentosError(this.mensaje);

  final String mensaje;
}
