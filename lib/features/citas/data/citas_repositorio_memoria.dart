import '../domain/cita.dart';
import 'citas_repository.dart';

/// Repositorio en memoria para la S1.
///
/// Permite ejecutar y probar la app sin red ni Firebase. En S4 se sustituye por
/// una implementación de Firestore.
class CitasRepositorioMemoria implements CitasRepository {
  CitasRepositorioMemoria({List<Cita>? iniciales})
      : _citas = List<Cita>.of(iniciales ?? const <Cita>[]);

  /// Datos de demostración con fechas relativas al día de ejecución.
  factory CitasRepositorioMemoria.demo() {
    final ahora = DateTime.now();
    return CitasRepositorioMemoria(
      iniciales: <Cita>[
        Cita(
          id: 'demo-1',
          especialidad: 'Medicina general',
          fechaHora: ahora.add(const Duration(days: 2, hours: 1)),
          nota: 'Llevar los resultados de laboratorio.',
        ),
        Cita(
          id: 'demo-2',
          especialidad: 'Oftalmología',
          fechaHora: ahora.add(const Duration(days: 10)),
        ),
      ],
    );
  }

  final List<Cita> _citas;

  @override
  Future<List<Cita>> listar() async {
    final ordenadas = List<Cita>.of(_citas)
      ..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
    return List<Cita>.unmodifiable(ordenadas);
  }

  @override
  Future<void> crear(Cita cita) async {
    _citas.add(cita);
  }

  @override
  Future<void> eliminar(String id) async {
    _citas.removeWhere((cita) => cita.id == id);
  }
}
