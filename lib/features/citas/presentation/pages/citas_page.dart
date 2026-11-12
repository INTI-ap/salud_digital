import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/estado_error.dart';
import '../../../../core/widgets/estado_vacio.dart';
import '../../domain/cita.dart';
import '../bloc/citas_bloc.dart';
import '../bloc/citas_event.dart';
import '../bloc/citas_state.dart';
import '../widgets/cita_card.dart';
import '../widgets/formulario_cita.dart';

/// Pantalla principal de la agenda de citas.
class CitasPage extends StatelessWidget {
  const CitasPage({super.key});

  Future<void> _abrirFormulario(BuildContext context) async {
    final cita = await showModalBottomSheet<Cita>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const FormularioCita(),
    );
    if (cita != null && context.mounted) {
      context.read<CitasBloc>().add(CrearCita(cita));
    }
  }

  Future<bool> _confirmarEliminacion(
    BuildContext context,
    Cita cita,
  ) async {
    final respuesta = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cita'),
        content: Text(
          '¿Eliminar la cita de ${cita.especialidad}? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    return respuesta ?? false;
  }

  Future<void> _eliminarConConfirmacion(
    BuildContext context,
    Cita cita,
  ) async {
    final confirmado = await _confirmarEliminacion(context, cita);
    if (confirmado && context.mounted) {
      context.read<CitasBloc>().add(EliminarCita(cita.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis citas'),
        actions: [
          IconButton(
            tooltip: 'Actualizar citas',
            onPressed: () =>
                context.read<CitasBloc>().add(const CargarCitas()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<CitasBloc, CitasState>(
        builder: (context, estado) {
          if (estado is CitasInicial || estado is CitasCargando) {
            return Center(
              child: Semantics(
                label: 'Cargando citas',
                child: const CircularProgressIndicator(),
              ),
            );
          }

          if (estado is CitasError) {
            return EstadoError(
              mensaje: estado.mensaje,
              onReintentar: () =>
                  context.read<CitasBloc>().add(const CargarCitas()),
            );
          }

          if (estado is CitasCargadas) {
            if (estado.citas.isEmpty) {
              return EstadoVacio(
                icono: Icons.event_busy,
                titulo: 'Aún no hay citas',
                mensaje: 'Registra la primera cita médica para organizar la '
                    'semana y recibir recordatorios.',
                accion: FilledButton.icon(
                  onPressed: () => _abrirFormulario(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar cita'),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 96),
              itemCount: estado.citas.length,
              itemBuilder: (context, indice) {
                final cita = estado.citas[indice];
                return Dismissible(
                  key: ValueKey<String>(cita.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    color: Theme.of(context).colorScheme.error,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                  confirmDismiss: (_) =>
                      _confirmarEliminacion(context, cita),
                  onDismissed: (_) => context
                      .read<CitasBloc>()
                      .add(EliminarCita(cita.id)),
                  child: CitaCard(
                    cita: cita,
                    onEliminar: () =>
                        _eliminarConConfirmacion(context, cita),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Registrar cita',
        onPressed: () => _abrirFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text('Registrar cita'),
      ),
    );
  }
}
