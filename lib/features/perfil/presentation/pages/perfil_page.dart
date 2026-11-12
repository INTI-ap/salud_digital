import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../firebase_bootstrap.dart';
import '../../../auth/presentation/bloc/sesion_bloc.dart';
import '../../../auth/presentation/bloc/sesion_event.dart';
import '../../../auth/presentation/bloc/sesion_state.dart';

/// Pantalla de perfil: sesión actual, estado de Firebase y datos del proyecto.
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key, required this.resultadoFirebase});

  final ResultadoFirebase resultadoFirebase;

  Future<void> _cerrarSesion(BuildContext context) async {
    final respuesta = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text(
          '¿Quieres cerrar la sesión? Podrás volver a ingresar con tus '
          'credenciales.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    if ((respuesta ?? false) && context.mounted) {
      context.read<SesionBloc>().add(const CerrarSesion());
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: BlocBuilder<SesionBloc, SesionState>(
        builder: (context, estado) {
          final usuario = estado is SesionConUsuario ? estado.usuario : null;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: tema.colorScheme.primaryContainer,
                        child: Text(
                          usuario?.iniciales ?? '?',
                          style: tema.textTheme.titleLarge?.copyWith(
                            color: tema.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              usuario?.nombre ?? 'Sin sesión',
                              style: tema.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              usuario?.correo ?? 'Inicia sesión para continuar',
                              style: tema.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: Icon(
                    resultadoFirebase.inicializado
                        ? Icons.cloud_done
                        : Icons.cloud_off,
                    color: resultadoFirebase.inicializado
                        ? const Color(0xFF1E7B4F)
                        : const Color(0xFF8A5A00),
                  ),
                  title: const Text('Estado de Firebase'),
                  subtitle: Text(
                    resultadoFirebase.detalle == null
                        ? resultadoFirebase.mensaje
                        : '${resultadoFirebase.mensaje}\n'
                            '${resultadoFirebase.detalle}',
                  ),
                  isThreeLine: resultadoFirebase.detalle != null,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sobre el proyecto',
                        style: tema.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Salud Digital del Adulto Mayor\n'
                        'Proyecto RSU · SIS048 · Unidad III\n'
                        'Universidad Andina del Cusco\n'
                        'Versión 0.1.0 (base S1)',
                        style: tema.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: usuario == null
                    ? null
                    : () => _cerrarSesion(context),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(64, 48),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
