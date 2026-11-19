import 'dart:async';
import 'package:flutter/foundation.dart';

/// Convierte un [Stream] en un [Listenable] que notifica a GoRouter cuando
/// el stream emite un nuevo valor.
///
/// Permite que GoRouter reevalúe su función de redirección (`redirect`) cada
/// vez que cambia el estado de sesión en el BLoC sin requerir navegación manual.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
