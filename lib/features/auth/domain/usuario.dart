/// Usuario autenticado en la aplicación.
///
/// En S1 se usa una implementación de demostración; en S2 este modelo se mapea
/// desde `User` de Firebase Authentication.
class Usuario {
  const Usuario({
    required this.id,
    required this.correo,
    required this.nombre,
  });

  final String id;
  final String correo;
  final String nombre;

  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) {
      return '?';
    }
    if (partes.length == 1) {
      return partes.first.substring(0, 1).toUpperCase();
    }
    return (partes.first.substring(0, 1) + partes.last.substring(0, 1))
        .toUpperCase();
  }
}
