import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final resultadoFirebase = await inicializarFirebase();
  debugPrint(resultadoFirebase.mensaje);
  if (!resultadoFirebase.inicializado && resultadoFirebase.detalle != null) {
    debugPrint('Detalle de Firebase: ${resultadoFirebase.detalle}');
  }

  runApp(AppSalud(resultadoFirebase: resultadoFirebase));
}
