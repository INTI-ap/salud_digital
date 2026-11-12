import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/sesion_bloc.dart';
import '../bloc/sesion_event.dart';
import '../bloc/sesion_state.dart';

/// Pantalla de acceso.
///
/// En S1 valida contra el repositorio en memoria; en S2 se conecta a Firebase
/// Authentication sin cambiar los eventos ni los estados.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formulario = GlobalKey<FormState>();
  final TextEditingController _correo =
      TextEditingController(text: 'demo@uandina.edu.pe');
  final TextEditingController _contrasena = TextEditingController(text: '123456');

  bool _verContrasena = false;

  @override
  void dispose() {
    _correo.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  void _ingresar() {
    if (!(_formulario.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<SesionBloc>().add(
          IniciarSesion(
            correo: _correo.text.trim(),
            contrasena: _contrasena.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final iniciando = context.watch<SesionBloc>().state is SesionIniciando;

    return Scaffold(
      body: SafeArea(
        child: BlocListener<SesionBloc, SesionState>(
          listenWhen: (anterior, actual) => actual is SesionError,
          listener: (context, estado) {
            if (estado is SesionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(estado.mensaje)),
              );
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formulario,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.health_and_safety,
                        size: 64,
                        color: tema.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Salud Digital',
                        textAlign: TextAlign.center,
                        style: tema.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Agenda de citas y medicamentos para el adulto mayor',
                        textAlign: TextAlign.center,
                        style: tema.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _correo,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          hintText: 'nombre@correo.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (valor) {
                          final texto = (valor ?? '').trim();
                          if (texto.isEmpty) {
                            return 'Escribe tu correo electrónico.';
                          }
                          if (!texto.contains('@') || !texto.contains('.')) {
                            return 'El correo no parece válido.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contrasena,
                        obscureText: !_verContrasena,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        onFieldSubmitted: (_) => _ingresar(),
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: _verContrasena
                                ? 'Ocultar contraseña'
                                : 'Mostrar contraseña',
                            onPressed: () => setState(
                              () => _verContrasena = !_verContrasena,
                            ),
                            icon: Icon(
                              _verContrasena
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (valor) {
                          if ((valor ?? '').length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: iniciando ? null : _ingresar,
                        icon: iniciando
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.login),
                        label: Text(iniciando ? 'Ingresando…' : 'Ingresar'),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        color: tema.colorScheme.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sesión de demostración',
                                style: tema.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Correo: demo@uandina.edu.pe\n'
                                'Contraseña: 123456\n'
                                'En la S2 estas credenciales se reemplazan por '
                                'Firebase Authentication.',
                                style: tema.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
