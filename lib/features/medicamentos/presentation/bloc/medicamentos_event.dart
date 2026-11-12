import '../../domain/medicamento.dart';

/// Eventos del bloque de medicamentos.
sealed class MedicamentosEvent {
  const MedicamentosEvent();
}

final class CargarMedicamentos extends MedicamentosEvent {
  const CargarMedicamentos();
}

final class CrearMedicamento extends MedicamentosEvent {
  const CrearMedicamento(this.medicamento);

  final Medicamento medicamento;
}

final class EliminarMedicamento extends MedicamentosEvent {
  const EliminarMedicamento(this.id);

  final String id;
}
