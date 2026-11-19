import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/bloc/sesion_bloc.dart';
import 'features/auth/presentation/bloc/sesion_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/citas/presentation/pages/citas_page.dart';
import 'features/medicamentos/presentation/pages/medicamentos_page.dart';
import 'features/perfil/presentation/pages/perfil_page.dart';
import 'firebase_bootstrap.dart';
import 'home_shell.dart';
import 'router_refresh.dart';

/// Configuración declarativa de rutas y protección de accesos con GoRouter.
class AppRouter {
  AppRouter({
    required this.sesionBloc,
    required this.resultadoFirebase,
  }) : _refreshNotifier = RouterRefreshNotifier(sesionBloc.stream) {
    router = GoRouter(
      initialLocation: '/',
      refreshListenable: _refreshNotifier,
      redirect: (context, state) => evaluarRedireccion(
        estado: sesionBloc.state,
        ubicacion: state.matchedLocation,
      ),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const PantallaCargaSplash(),
        ),
        GoRoute(
          path: '/acceso',
          builder: (context, state) => const LoginPage(),
        ),
        ShellRoute(
          builder: (context, state, child) => HomeShell(
            resultadoFirebase: resultadoFirebase,
            child: child,
          ),
          routes: [
            GoRoute(
              path: '/citas',
              builder: (context, state) => const CitasPage(),
            ),
            GoRoute(
              path: '/medicamentos',
              builder: (context, state) => const MedicamentosPage(),
            ),
            GoRoute(
              path: '/perfil',
              builder: (context, state) => PerfilPage(
                resultadoFirebase: resultadoFirebase,
              ),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => PaginaRutaNoEncontrada(
        ruta: state.uri.toString(),
      ),
    );
  }

  final SesionBloc sesionBloc;
  final ResultadoFirebase resultadoFirebase;
  final RouterRefreshNotifier _refreshNotifier;
  late final GoRouter router;

  /// Regla centralizada de redirección según el estado de la sesión.
  static String? evaluarRedireccion({
    required SesionState estado,
    required String ubicacion,
  }) {
    if (estado is SesionVerificando) {
      return ubicacion == '/' ? null : '/';
    }

    final autenticado = estado is SesionConUsuario;
    if (!autenticado) {
      return ubicacion == '/acceso' ? null : '/acceso';
    }
    if (ubicacion == '/' || ubicacion == '/acceso') {
      return '/citas';
    }
    return null;
  }

  void dispose() {
    _refreshNotifier.dispose();
  }
}

/// Pantalla mostrada mientras se verifica la sesión en frío.
class PantallaCargaSplash extends StatelessWidget {
  const PantallaCargaSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Preparando tu agenda…',
              style: tema.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

/// Pantalla accesible para rutas inexistentes o desconocidas.
class PaginaRutaNoEncontrada extends StatelessWidget {
  const PaginaRutaNoEncontrada({super.key, required this.ruta});

  final String ruta;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Página no encontrada')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'La ruta solicitada no existe',
                style: tema.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                ruta,
                style: tema.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.go('/citas'),
                icon: const Icon(Icons.home),
                label: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
