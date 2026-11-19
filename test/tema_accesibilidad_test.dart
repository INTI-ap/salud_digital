import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_digital/core/theme/app_theme.dart';
import 'package:salud_digital/features/auth/data/auth_repositorio_memoria.dart';
import 'package:salud_digital/features/auth/presentation/bloc/sesion_bloc.dart';
import 'package:salud_digital/features/auth/presentation/pages/login_page.dart';

void main() {
  group('AppTheme - 4 variantes de Material 3', () {
    test('genera temas claro, oscuro y alto contraste válidos', () {
      final claro = AppTheme.claro;
      final oscuro = AppTheme.oscuro;
      final altoClaro = AppTheme.altoContrasteClaro;
      final altoOscuro = AppTheme.altoContrasteOscuro;

      expect(claro.useMaterial3, isTrue);
      expect(oscuro.useMaterial3, isTrue);
      expect(altoClaro.useMaterial3, isTrue);
      expect(altoOscuro.useMaterial3, isTrue);

      expect(claro.brightness, Brightness.light);
      expect(oscuro.brightness, Brightness.dark);
      expect(altoClaro.brightness, Brightness.light);
      expect(altoOscuro.brightness, Brightness.dark);

      // Tipografía accesible base 18sp
      expect(claro.textTheme.bodyLarge?.fontSize, 18.0);
      expect(claro.textTheme.bodyMedium?.fontSize, 18.0);
    });
  });

  group('Accesibilidad - Texto al 200%', () {
    testWidgets('LoginPage escala texto al 200% sin generar overflow',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final authRepo = AuthRepositorioMemoria();
      final sesionBloc = SesionBloc(authRepo);
      addTearDown(sesionBloc.close);

      await tester.pumpWidget(
        BlocProvider<SesionBloc>.value(
          value: sesionBloc,
          child: MaterialApp(
            theme: AppTheme.claro,
            home: const MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(2.0),
                size: Size(540, 960),
              ),
              child: LoginPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Ingresar'), findsOneWidget);
    });
  });
}
