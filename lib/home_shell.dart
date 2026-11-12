import 'package:flutter/material.dart';

import 'core/widgets/aviso_configuracion.dart';
import 'features/citas/presentation/pages/citas_page.dart';
import 'features/medicamentos/presentation/pages/medicamentos_page.dart';
import 'features/perfil/presentation/pages/perfil_page.dart';
import 'firebase_bootstrap.dart';

/// Contenedor principal con la navegación entre funcionalidades.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.resultadoFirebase});

  final ResultadoFirebase resultadoFirebase;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    final paginas = <Widget>[
      const CitasPage(),
      const MedicamentosPage(),
      PerfilPage(resultadoFirebase: widget.resultadoFirebase),
    ];

    return Scaffold(
      body: Column(
        children: [
          if (!widget.resultadoFirebase.inicializado)
            AvisoConfiguracion(
              mensaje: widget.resultadoFirebase.mensaje,
              detalle: widget.resultadoFirebase.detalle,
            ),
          Expanded(
            child: IndexedStack(
              index: _indice,
              children: paginas,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (indice) => setState(() => _indice = indice),
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
