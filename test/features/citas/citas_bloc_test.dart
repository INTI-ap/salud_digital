import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_digital/features/citas/data/citas_repository.dart';
import 'package:salud_digital/features/citas/domain/cita.dart';
import 'package:salud_digital/features/citas/presentation/bloc/citas_bloc.dart';
import 'package:salud_digital/features/citas/presentation/bloc/citas_event.dart';
import 'package:salud_digital/features/citas/presentation/bloc/citas_state.dart';

class _RepositorioFalso implements CitasRepository {
  _RepositorioFalso({this.falla = false, List<Cita>? iniciales})
      : _citas = List<Cita>.of(iniciales ?? const <Cita>[]);

  final bool falla;
  final List<Cita> _citas;

  @override
  Future<List<Cita>> listar() async {
    if (falla) {
      throw Exception('falla de prueba');
    }
    return List<Cita>.unmodifiable(_citas);
  }

  @override
  Future<void> crear(Cita cita) async {
    if (falla) {
      throw Exception('falla de prueba');
    }
    _citas.add(cita);
  }

  @override
  Future<void> eliminar(String id) async {
    if (falla) {
      throw Exception('falla de prueba');
    }
    _citas.removeWhere((cita) => cita.id == id);
  }
}

Cita _cita(String id) => Cita(
      id: id,
      especialidad: 'Medicina general',
      fechaHora: DateTime(2026, 11, 12, 9),
    );

void main() {
  group('CitasBloc', () {
    test('inicia en CitasInicial', () {
      final bloc = CitasBloc(_RepositorioFalso());
      expect(bloc.state, isA<CitasInicial>());
      bloc.close();
    });

    blocTest<CitasBloc, CitasState>(
      'carga las citas del repositorio',
      build: () => CitasBloc(
        _RepositorioFalso(iniciales: <Cita>[_cita('1'), _cita('2')]),
      ),
      act: (bloc) => bloc.add(const CargarCitas()),
      expect: () => <Matcher>[
        isA<CitasCargando>(),
        isA<CitasCargadas>().having(
          (estado) => estado.citas.length,
          'cantidad de citas',
          2,
        ),
      ],
    );

    blocTest<CitasBloc, CitasState>(
      'crea una cita y refresca la lista',
      build: () => CitasBloc(_RepositorioFalso()),
      act: (bloc) => bloc.add(CrearCita(_cita('nueva'))),
      expect: () => <Matcher>[
        isA<CitasCargadas>().having(
          (estado) => estado.citas.single.id,
          'id de la cita',
          'nueva',
        ),
      ],
    );

    blocTest<CitasBloc, CitasState>(
      'elimina una cita existente',
      build: () => CitasBloc(
        _RepositorioFalso(iniciales: <Cita>[_cita('1')]),
      ),
      act: (bloc) => bloc.add(const EliminarCita('1')),
      expect: () => <Matcher>[
        isA<CitasCargadas>().having(
          (estado) => estado.citas,
          'citas restantes',
          isEmpty,
        ),
      ],
    );

    blocTest<CitasBloc, CitasState>(
      'emite CitasError cuando el repositorio falla',
      build: () => CitasBloc(_RepositorioFalso(falla: true)),
      act: (bloc) => bloc.add(const CargarCitas()),
      expect: () => <Matcher>[
        isA<CitasCargando>(),
        isA<CitasError>().having(
          (estado) => estado.mensaje,
          'mensaje',
          contains('cargar'),
        ),
      ],
    );
  });
}
