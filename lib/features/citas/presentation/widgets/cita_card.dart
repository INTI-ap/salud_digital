import 'package:flutter/material.dart';

import '../../../../core/utils/fechas.dart';
import '../../domain/cita.dart';

/// Tarjeta de una cita en la lista.
class CitaCard extends StatelessWidget {
  const CitaCard({
    super.key,
    required this.cita,
    required this.onEliminar,
  });

  final Cita cita;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final tieneNota = (cita.nota ?? '').trim().isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        isThreeLine: tieneNota,
        leading: CircleAvatar(
          backgroundColor: tema.colorScheme.primaryContainer,
          child: Icon(
            Icons.event_available,
            color: tema.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(cita.especialidad, style: tema.textTheme.titleMedium),
        subtitle: Text(
          tieneNota
              ? '${formatearFechaHora(cita.fechaHora)}\n${cita.nota}'
              : formatearFechaHora(cita.fechaHora),
          style: tema.textTheme.bodyMedium,
        ),
        trailing: IconButton(
          tooltip: 'Eliminar cita',
          onPressed: onEliminar,
          icon: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }
}
