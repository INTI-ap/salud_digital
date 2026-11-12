import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_digital/features/medicamentos/data/medicamentos_repository.dart';
import 'package:salud_digital/features/medicamentos/domain/medicamento.dart';
import 'package:salud_digital/features/medicamentos/presentation/bloc/medicamentos_bloc.dart';
import 'package:salud_digital/features/medicamentos/presentation/bloc/medicamentos_event.dart';
import 'package:salud_digital/features/medicamentos/presentation/bloc/medicamentos_state.dart';

class _RepositorioFalso implements MedicamentosRepository {
  _RepositorioFalso({this.falla = false, List<Medicamento>? iniciales})
      : _medicamentos = List<Medicamento>.of(iniciales ?? const <Medicamento>[]);

  final bool falla;
  final List<Medicamento> _medicamentos;

  @override
  Future<List<Medicamento>> listar() async {
    if (falla) {
      throw Exception('falla de prueba');
    }
    return List<Medicamento>.unmodifiable(_medicamentos);
  }

  @override
  Future<void> crear(Medicamento medicamento) async {
    if (falla) {
      throw Exception('falla de prueba');
    }
    _medicamentos.add(medicamento);
  }

  @override
  Future<void> eliminar(String id) async {
    if (falla) {
      throw Exception('falla de prueba');
    }
    _medicamentos.removeWhere((medicamento) => medicamento.id == id);
  }
}

Medicamento _medicamento(String id) => Medicamento(
      id: id,
      nombre: 'Enalapril',
      dosis: '10 mg',
      hora: 8,
      minuto: 0,
    );

void main() {
  group('MedicamentosBloc', () {
    test('inicia en MedicamentosInicial', () {
      final bloc = MedicamentosBloc(_RepositorioFalso());
      expect(bloc.state, isA<MedicamentosInicial>());
      bloc.close();
    });

    blocTest<MedicamentosBloc, MedicamentosState>(
      'carga los medicamentos del repositorio',
      build: () => MedicamentosBloc(
        _RepositorioFalso(
          iniciales: <Medicamento>[
            _medicamento('1'),
            _medicamento('2'),
          ],
        ),
      ),
      act: (bloc) => bloc.add(const CargarMedicamentos()),
      expect: () => <Matcher>[
        isA<MedicamentosCargando>(),
        isA<MedicamentosCargados>().having(
          (estado) => estado.medicamentos.length,
          'cantidad',
          2,
        ),
      ],
    );

    blocTest<MedicamentosBloc, MedicamentosState>(
      'crea un medicamento y refresca la lista',
      build: () => MedicamentosBloc(_RepositorioFalso()),
      act: (bloc) => bloc.add(CrearMedicamento(_medicamento('nuevo'))),
      expect: () => <Matcher>[
        isA<MedicamentosCargados>().having(
          (estado) => estado.medicamentos.single.id,
          'id',
          'nuevo',
        ),
      ],
    );

    blocTest<MedicamentosBloc, MedicamentosState>(
      'emite error cuando el repositorio falla',
      build: () => MedicamentosBloc(_RepositorioFalso(falla: true)),
      act: (bloc) => bloc.add(const CargarMedicamentos()),
      expect: () => <Matcher>[
        isA<MedicamentosCargando>(),
        isA<MedicamentosError>(),
      ],
    );
  });
}
