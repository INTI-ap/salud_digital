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

  testWidgets('logout con confirmación redirige automáticamente a /acceso',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      AppSalud(
        authRepository: AuthRepositorioMemoria(),
        citasRepository: CitasRepositorioMemoria(),
        medicamentosRepository: MedicamentosRepositorioMemoria(),
      ),
    );
    await tester.pumpAndSettle();

    // Navegar al perfil
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();

    expect(find.text('Mi perfil'), findsOneWidget);

    // Tocar el botón de cerrar sesión
    final botonCerrar = find.widgetWithText(OutlinedButton, 'Cerrar sesión');
    await tester.ensureVisible(botonCerrar);
    await tester.tap(botonCerrar);
    await tester.pumpAndSettle();

    // Aparece el diálogo de confirmación
    expect(
      find.text(
        '¿Quieres cerrar la sesión? Podrás volver a ingresar con tus credenciales.',
      ),
      findsOneWidget,
    );
    expect(find.text('Cancelar'), findsOneWidget);

    // Cancelar primero
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Mi perfil'), findsOneWidget);

    // Volver a tocar y ahora confirmar
    await tester.tap(botonCerrar);
    await tester.pumpAndSettle();

    // Confirmar en el diálogo
    await tester.tap(find.widgetWithText(FilledButton, 'Cerrar sesión'));
    await tester.pumpAndSettle();

    // GoRouter redirige automáticamente a /acceso
    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
  });
}
