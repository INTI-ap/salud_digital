import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_digital/app_router.dart';
import 'package:salud_digital/features/auth/domain/usuario.dart';
import 'package:salud_digital/features/auth/presentation/bloc/sesion_state.dart';

void main() {
  group('AppRouter - Regla centralizada de redirección', () {
    const usuarioPrueba = Usuario(
      id: 'usr-123',
      nombre: 'Adelaida Pérez',
      correo: 'adelaida@example.com',
    );

    test('mientras verifica sesión, redirige a / si está en otra ruta', () {
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionVerificando(),
          ubicacion: '/citas',
        ),
        '/',
      );
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionVerificando(),
          ubicacion: '/perfil',
        ),
        '/',
      );
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionVerificando(),
          ubicacion: '/',
        ),
        isNull,
      );
    });

    test(
        'sin sesión (SesionSinUsuario), redirige cualquier ruta protegida a /acceso',
        () {
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionSinUsuario(),
          ubicacion: '/citas',
        ),
        '/acceso',
      );
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionSinUsuario(),
          ubicacion: '/medicamentos',
        ),
        '/acceso',
      );
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionSinUsuario(),
          ubicacion: '/perfil',
        ),
        '/acceso',
      );
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionSinUsuario(),
          ubicacion: '/acceso',
        ),
        isNull,
      );
    });

    test('con sesión activa (SesionConUsuario), redirige / y /acceso a /citas',
        () {
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionConUsuario(usuarioPrueba),
          ubicacion: '/',
        ),
        '/citas',
      );
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionConUsuario(usuarioPrueba),
          ubicacion: '/acceso',
        ),
        '/citas',
      );
    });

    test(
        'con sesión activa, permite navegar en rutas protegidas (/citas, /medicamentos, /perfil)',
        () {
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionConUsuario(usuarioPrueba),
          ubicacion: '/citas',
        ),
        isNull,
      );
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionConUsuario(usuarioPrueba),
          ubicacion: '/medicamentos',
        ),
        isNull,
      );
      expect(
        AppRouter.evaluarRedireccion(
          estado: const SesionConUsuario(usuarioPrueba),
          ubicacion: '/perfil',
        ),
        isNull,
      );
    });
  });

  group('PaginaRutaNoEncontrada - Ruta inexistente', () {
    testWidgets('muestra mensaje accesible cuando la ruta no existe',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PaginaRutaNoEncontrada(ruta: '/ruta-desconocida'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Página no encontrada'), findsOneWidget);
      expect(find.text('La ruta solicitada no existe'), findsOneWidget);
      expect(find.text('/ruta-desconocida'), findsOneWidget);
      expect(find.text('Volver al inicio'), findsOneWidget);
    });
  });
}
