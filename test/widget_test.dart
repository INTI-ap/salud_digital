import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_digital/app.dart';
import 'package:salud_digital/features/auth/data/auth_repositorio_memoria.dart';
import 'package:salud_digital/features/citas/data/citas_repositorio_memoria.dart';
import 'package:salud_digital/features/medicamentos/data/medicamentos_repositorio_memoria.dart';

void main() {
  testWidgets('abre la agenda de citas con la sesión de demostración',
      (tester) async {
    await tester.pumpWidget(
      AppSalud(
        authRepository: AuthRepositorioMemoria(),
        citasRepository: CitasRepositorioMemoria(),
        medicamentosRepository: MedicamentosRepositorioMemoria(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mis citas'), findsOneWidget);
    expect(find.text('Aún no hay citas'), findsOneWidget);
  });

  testWidgets('navega a la pantalla de medicamentos', (tester) async {
    await tester.pumpWidget(
      AppSalud(
        authRepository: AuthRepositorioMemoria(),
        citasRepository: CitasRepositorioMemoria(),
        medicamentosRepository: MedicamentosRepositorioMemoria(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Medicamentos'));
    await tester.pumpAndSettle();

    expect(find.text('Mis medicamentos'), findsOneWidget);
    expect(find.text('Aún no hay medicamentos'), findsOneWidget);
  });

  testWidgets('muestra el aviso cuando Firebase no está configurado',
      (tester) async {
    await tester.pumpWidget(
      AppSalud(
        authRepository: AuthRepositorioMemoria(),
        citasRepository: CitasRepositorioMemoria(),
        medicamentosRepository: MedicamentosRepositorioMemoria(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data != null &&
            widget.data!.contains('Firebase no está configurado'),
      ),
      findsWidgets,
    );
  });
}
