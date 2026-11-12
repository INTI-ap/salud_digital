import 'package:flutter_test/flutter_test.dart';
import 'package:salud_digital/features/citas/data/citas_repositorio_memoria.dart';
import 'package:salud_digital/features/citas/domain/cita.dart';

Cita _cita(String id, DateTime fecha) => Cita(
      id: id,
      especialidad: 'Medicina general',
      fechaHora: fecha,
    );

void main() {
  group('CitasRepositorioMemoria', () {
    test('inicia vacío cuando no recibe datos', () async {
      final repositorio = CitasRepositorioMemoria();
      expect(await repositorio.listar(), isEmpty);
    });

    test('crea una cita y la devuelve en la lista', () async {
      final repositorio = CitasRepositorioMemoria();
      final cita = _cita('1', DateTime(2026, 11, 12, 9));

      await repositorio.crear(cita);

      final citas = await repositorio.listar();
      expect(citas, hasLength(1));
      expect(citas.single.id, '1');
    });

    test('ordena las citas por fecha', () async {
      final repositorio = CitasRepositorioMemoria(
        iniciales: <Cita>[
          _cita('tarde', DateTime(2026, 11, 20, 16)),
          _cita('temprano', DateTime(2026, 11, 12, 9)),
        ],
      );

      final citas = await repositorio.listar();

      expect(citas.first.id, 'temprano');
      expect(citas.last.id, 'tarde');
    });

    test('elimina una cita por identificador', () async {
      final repositorio = CitasRepositorioMemoria(
        iniciales: <Cita>[_cita('1', DateTime(2026, 11, 12, 9))],
      );

      await repositorio.eliminar('1');

      expect(await repositorio.listar(), isEmpty);
    });

    test('la lista devuelta es inmutable', () async {
      final repositorio = CitasRepositorioMemoria(
        iniciales: <Cita>[_cita('1', DateTime(2026, 11, 12, 9))],
      );
      final citas = await repositorio.listar();

      expect(
        () => citas.add(_cita('2', DateTime(2026, 11, 13, 9))),
        throwsUnsupportedError,
      );
    });

    test('los datos de demostración traen dos citas', () async {
      final repositorio = CitasRepositorioMemoria.demo();
      expect(await repositorio.listar(), hasLength(2));
    });
  });
}
