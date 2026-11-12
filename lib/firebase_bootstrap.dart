import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Resultado de intentar inicializar Firebase.
///
/// La app no falla si Firebase no está configurado: informa el estado y sigue
/// funcionando con los repositorios en memoria.
@immutable
class ResultadoFirebase {
  const ResultadoFirebase({
    required this.inicializado,
    required this.mensaje,
    this.detalle,
  });

  final bool inicializado;
  final String mensaje;
  final String? detalle;

  static const ResultadoFirebase noConfigurado = ResultadoFirebase(
    inicializado: false,
    mensaje: 'Firebase no está configurado. '
        'La app funciona con datos de demostración.',
  );
}

/// Inicializa Firebase usando la configuración nativa de Android
/// (`google-services.json`, generado por `flutterfire configure`).
///
/// Si el proyecto todavía no está configurado, devuelve un resultado con
/// `inicializado: false` en lugar de detener la aplicación.
Future<ResultadoFirebase> inicializarFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    final proyecto = Firebase.app().options.projectId;
    return ResultadoFirebase(
      inicializado: true,
      mensaje: 'Firebase conectado: $proyecto',
    );
  } on FirebaseException catch (error) {
    return ResultadoFirebase(
      inicializado: false,
      mensaje: 'Firebase no está configurado; se usan datos de demostración.',
      detalle: '${error.code}: ${error.message ?? 'sin detalle'}',
    );
  } catch (error) {
    return ResultadoFirebase(
      inicializado: false,
      mensaje: 'No se pudo inicializar Firebase; se usan datos de demostración.',
      detalle: error.toString(),
    );
  }
}
