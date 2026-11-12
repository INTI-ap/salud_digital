import 'package:flutter/material.dart';

import '../../../../core/utils/fechas.dart';
import '../../domain/cita.dart';

/// Formulario para registrar una cita.
///
/// Devuelve una [Cita] mediante `Navigator.pop` cuando se guarda.
class FormularioCita extends StatefulWidget {
  const FormularioCita({super.key});

  @override
  State<FormularioCita> createState() => _FormularioCitaState();
}

class _FormularioCitaState extends State<FormularioCita> {
  final GlobalKey<FormState> _formulario = GlobalKey<FormState>();
  final TextEditingController _especialidad = TextEditingController();
  final TextEditingController _nota = TextEditingController();
  final TextEditingController _fechaTexto = TextEditingController();
  final TextEditingController _horaTexto = TextEditingController();

  DateTime? _fecha;
  TimeOfDay? _hora;

  @override
  void dispose() {
    _especialidad.dispose();
    _nota.dispose();
    _fechaTexto.dispose();
    _horaTexto.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final ahora = DateTime.now();
    final seleccion = await showDatePicker(
      context: context,
      initialDate: _fecha ?? ahora,
      firstDate: DateTime(ahora.year, ahora.month, ahora.day),
      lastDate: DateTime(ahora.year + 2),
      helpText: 'Fecha de la cita',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (seleccion != null) {
      setState(() {
        _fecha = seleccion;
        _fechaTexto.text = formatearFechaCorta(seleccion);
      });
    }
  }

  Future<void> _elegirHora() async {
    final seleccion = await showTimePicker(
      context: context,
      initialTime: _hora ?? const TimeOfDay(hour: 9, minute: 0),
      helpText: 'Hora de la cita',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (seleccion != null) {
      setState(() {
        _hora = seleccion;
        _horaTexto.text = formatearHora(seleccion.hour, seleccion.minute);
      });
    }
  }

  void _guardar() {
    if (!(_formulario.currentState?.validate() ?? false)) {
      return;
    }
    final fecha = _fecha;
    final hora = _hora;
    if (fecha == null || hora == null) {
      return;
    }
    final nota = _nota.text.trim();
    final cita = Cita(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      especialidad: _especialidad.text.trim(),
      fechaHora: DateTime(
        fecha.year,
        fecha.month,
        fecha.day,
        hora.hour,
        hora.minute,
      ),
      nota: nota.isEmpty ? null : nota,
    );
    Navigator.of(context).pop(cita);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Form(
          key: _formulario,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Nueva cita',
                      style: tema.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Cerrar',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _especialidad,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Especialidad',
                  hintText: 'Medicina general',
                  prefixIcon: Icon(Icons.medical_services_outlined),
                ),
                validator: (valor) {
                  if ((valor ?? '').trim().isEmpty) {
                    return 'Escribe la especialidad de la cita.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaTexto,
                readOnly: true,
                onTap: _elegirFecha,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  hintText: 'Selecciona una fecha',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                validator: (_) =>
                    _fecha == null ? 'Selecciona la fecha de la cita.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _horaTexto,
                readOnly: true,
                onTap: _elegirHora,
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  hintText: 'Selecciona una hora',
                  prefixIcon: Icon(Icons.schedule),
                ),
                validator: (_) =>
                    _hora == null ? 'Selecciona la hora de la cita.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nota,
                minLines: 2,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nota (opcional)',
                  hintText: 'Qué llevar o indicaciones previas',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Guardar cita'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
