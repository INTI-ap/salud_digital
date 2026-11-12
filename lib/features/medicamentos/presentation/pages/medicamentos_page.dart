import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/estado_error.dart';
import '../../../../core/widgets/estado_vacio.dart';
import '../../domain/medicamento.dart';
import '../bloc/medicamentos_bloc.dart';
import '../bloc/medicamentos_event.dart';
import '../bloc/medicamentos_state.dart';
import '../widgets/formulario_medicamento.dart';

/// Pantalla de medicamentos programados.
class MedicamentosPage extends StatelessWidget {
  const MedicamentosPage({super.key});

  Future<void> _abrirFormulario(BuildContext context) async {
    final medicamento = await showModalBottomSheet<Medicamento>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const FormularioMedicamento(),
    );
    if (medicamento != null && context.mounted) {
      context.read<MedicamentosBloc>().add(CrearMedicamento(medicamento));
    }
  }

  Future<void> _eliminarConConfirmacion(
    BuildContext context,
    Medicamento medicamento,
  ) async {
    final respuesta = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar medicamento'),
        content: Text(
          '¿Eliminar ${medicamento.nombre} de la lista? '
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
    if ((respuesta ?? false) && context.mounted) {
      context
          .read<MedicamentosBloc>()
          .add(EliminarMedicamento(medicamento.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis medicamentos'),
        actions: [
          IconButton(
            tooltip: 'Actualizar medicamentos',
            onPressed: () =>
                context.read<MedicamentosBloc>().add(const CargarMedicamentos()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<MedicamentosBloc, MedicamentosState>(
        builder: (context, estado) {
          if (estado is MedicamentosInicial || estado is MedicamentosCargando) {
            return Center(
              child: Semantics(
                label: 'Cargando medicamentos',
                child: const CircularProgressIndicator(),
              ),
            );
          }

          if (estado is MedicamentosError) {
            return EstadoError(
              mensaje: estado.mensaje,
              onReintentar: () => context
                  .read<MedicamentosBloc>()
                  .add(const CargarMedicamentos()),
            );
          }

          if (estado is MedicamentosCargados) {
            if (estado.medicamentos.isEmpty) {
              return EstadoVacio(
                icono: Icons.medication_liquid,
                titulo: 'Aún no hay medicamentos',
                mensaje: 'Registra los medicamentos y sus horarios para '
                    'organizar las tomas del día.',
                accion: FilledButton.icon(
                  onPressed: () => _abrirFormulario(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar medicamento'),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 96),
              itemCount: estado.medicamentos.length,
              itemBuilder: (context, indice) {
                final medicamento = estado.medicamentos[indice];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: tema.colorScheme.secondaryContainer,
                      child: Icon(
                        Icons.medication,
                        color: tema.colorScheme.onSecondaryContainer,
                      ),
                    ),
                    title: Text(
                      medicamento.nombre,
                      style: tema.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '${medicamento.dosis} · ${medicamento.horaTexto}',
                      style: tema.textTheme.bodyMedium,
                    ),
                    trailing: IconButton(
                      tooltip: 'Eliminar medicamento',
                      onPressed: () =>
                          _eliminarConConfirmacion(context, medicamento),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Registrar medicamento',
        onPressed: () => _abrirFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
      ),
    );
  }
}
