import 'package:flutter/material.dart';

import '../../../../core/utils/fechas.dart';
import '../../domain/medicamento.dart';

/// Formulario para registrar un medicamento.
///
/// Devuelve un [Medicamento] mediante `Navigator.pop` cuando se guarda.
class FormularioMedicamento extends StatefulWidget {
  const FormularioMedicamento({super.key});

  @override
  State<FormularioMedicamento> createState() =>
      _FormularioMedicamentoState();
}

class _FormularioMedicamentoState extends State<FormularioMedicamento> {
  final GlobalKey<FormState> _formulario = GlobalKey<FormState>();
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _dosis = TextEditingController();
  final TextEditingController _horaTexto = TextEditingController();

  TimeOfDay? _hora;

  @override
  void dispose() {
    _nombre.dispose();
    _dosis.dispose();
    _horaTexto.dispose();
    super.dispose();
  }

  Future<void> _elegirHora() async {
    final seleccion = await showTimePicker(
      context: context,
      initialTime: _hora ?? const TimeOfDay(hour: 8, minute: 0),
      helpText: 'Hora del medicamento',
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
    final hora = _hora;
    if (hora == null) {
      return;
    }
    final medicamento = Medicamento(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nombre: _nombre.text.trim(),
      dosis: _dosis.text.trim(),
      hora: hora.hour,
      minuto: hora.minute,
    );
    Navigator.of(context).pop(medicamento);
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
                      'Nuevo medicamento',
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
                controller: _nombre,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Medicamento',
                  hintText: 'Enalapril',
                  prefixIcon: Icon(Icons.medication_outlined),
                ),
                validator: (valor) {
                  if ((valor ?? '').trim().isEmpty) {
                    return 'Escribe el nombre del medicamento.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dosis,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Dosis',
                  hintText: '10 mg',
                  prefixIcon: Icon(Icons.straighten),
                ),
                validator: (valor) {
                  if ((valor ?? '').trim().isEmpty) {
                    return 'Escribe la dosis indicada.';
                  }
                  return null;
                },
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
                    _hora == null ? 'Selecciona la hora del medicamento.' : null,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Guardar medicamento'),
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
