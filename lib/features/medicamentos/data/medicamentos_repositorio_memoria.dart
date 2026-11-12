import '../domain/medicamento.dart';
import 'medicamentos_repository.dart';

/// Repositorio en memoria para la S1.
class MedicamentosRepositorioMemoria implements MedicamentosRepository {
  MedicamentosRepositorioMemoria({List<Medicamento>? iniciales})
      : _medicamentos = List<Medicamento>.of(iniciales ?? const <Medicamento>[]);

  factory MedicamentosRepositorioMemoria.demo() {
    return MedicamentosRepositorioMemoria(
      iniciales: const <Medicamento>[
        Medicamento(
          id: 'demo-1',
          nombre: 'Enalapril',
          dosis: '10 mg',
          hora: 8,
          minuto: 0,
        ),
        Medicamento(
          id: 'demo-2',
          nombre: 'Metformina',
          dosis: '850 mg',
          hora: 20,
          minuto: 30,
        ),
      ],
    );
  }

  final List<Medicamento> _medicamentos;

  @override
  Future<List<Medicamento>> listar() async {
    final ordenados = List<Medicamento>.of(_medicamentos)
      ..sort((a, b) {
        final porHora = a.hora.compareTo(b.hora);
        return porHora != 0 ? porHora : a.minuto.compareTo(b.minuto);
      });
    return List<Medicamento>.unmodifiable(ordenados);
  }

  @override
  Future<void> crear(Medicamento medicamento) async {
    _medicamentos.add(medicamento);
  }

  @override
  Future<void> eliminar(String id) async {
    _medicamentos.removeWhere((medicamento) => medicamento.id == id);
  }
}
