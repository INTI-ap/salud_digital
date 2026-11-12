import '../domain/medicamento.dart';

/// Contrato del repositorio de medicamentos.
abstract interface class MedicamentosRepository {
  Future<List<Medicamento>> listar();

  Future<void> crear(Medicamento medicamento);

  Future<void> eliminar(String id);
}
