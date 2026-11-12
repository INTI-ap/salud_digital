import 'package:flutter/material.dart';

/// Aviso visible cuando Firebase no está configurado.
///
/// La app sigue funcionando con repositorios en memoria; este aviso evita que el
/// equipo confunda «datos de demostración» con datos en la nube.
class AvisoConfiguracion extends StatelessWidget {
  const AvisoConfiguracion({super.key, required this.mensaje, this.detalle});

  final String mensaje;
  final String? detalle;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Semantics(
      liveRegion: true,
      label: 'Aviso: $mensaje',
      child: Container(
        width: double.infinity,
        color: const Color(0xFFFFF3CD),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.cloud_off, color: Color(0xFF8A5A00), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mensaje,
                    style: tema.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5C3B00),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (detalle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      detalle!,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF5C3B00),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
