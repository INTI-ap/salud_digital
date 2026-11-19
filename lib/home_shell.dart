import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/widgets/aviso_configuracion.dart';
import 'firebase_bootstrap.dart';

/// Contenedor principal con la barra de navegación inferior integrada a GoRouter.
class HomeShell extends StatelessWidget {
  const HomeShell({
    super.key,
    required this.resultadoFirebase,
    required this.child,
  });

  final ResultadoFirebase resultadoFirebase;
  final Widget child;

  int _calcularIndice(BuildContext context) {
    final ubicacion = GoRouterState.of(context).matchedLocation;
    if (ubicacion.startsWith('/medicamentos')) {
      return 1;
    }
    if (ubicacion.startsWith('/perfil')) {
      return 2;
    }
    return 0; // /citas
  }

  void _alSeleccionarDestino(BuildContext context, int indice) {
    switch (indice) {
      case 0:
        context.go('/citas');
        break;
      case 1:
        context.go('/medicamentos');
        break;
      case 2:
        context.go('/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final indiceActual = _calcularIndice(context);

    return Scaffold(
      body: Column(
        children: [
          if (!resultadoFirebase.inicializado)
            AvisoConfiguracion(
              mensaje: resultadoFirebase.mensaje,
              detalle: resultadoFirebase.detalle,
            ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: indiceActual,
        onDestinationSelected: (indice) => _alSeleccionarDestino(context, indice),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Citas',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            selectedIcon: Icon(Icons.medication),
            label: 'Medicamentos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
