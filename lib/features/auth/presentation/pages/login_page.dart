import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/sesion_bloc.dart';
import '../bloc/sesion_event.dart';
import '../bloc/sesion_state.dart';

/// Pantalla de acceso y registro (S2).
///
/// Se conecta a Firebase Authentication mediante [SesionBloc]. Permite tanto el
/// inicio de sesión de cuentas existentes como la creación de nuevas cuentas.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formulario = GlobalKey<FormState>();
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();

  bool _esRegistro = false;
  bool _verContrasena = false;

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  void _enviar() {
    if (!(_formulario.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();
    final bloc = context.read<SesionBloc>();
    if (_esRegistro) {
      bloc.add(
        RegistrarUsuario(
          correo: _correo.text.trim(),
          contrasena: _contrasena.text,
          nombre: _nombre.text.trim(),
        ),
      );
    } else {
      bloc.add(
        IniciarSesion(
          correo: _correo.text.trim(),
          contrasena: _contrasena.text,
        ),
      );
    }
  }

  void _alternarModo() {
    setState(() {
      _esRegistro = !_esRegistro;
      _formulario.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final procesando = context.watch<SesionBloc>().state is SesionIniciando;

    return Scaffold(
      body: SafeArea(
        child: BlocListener<SesionBloc, SesionState>(
          listenWhen: (anterior, actual) => actual is SesionError,
          listener: (context, estado) {
            if (estado is SesionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(estado.mensaje),
                  backgroundColor: tema.colorScheme.error,
                ),
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
                        _esRegistro
                            ? 'Crea tu cuenta para gestionar citas y medicamentos'
                            : 'Agenda de citas y medicamentos para el adulto mayor',
                        textAlign: TextAlign.center,
                        style: tema.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 28),
                      if (_esRegistro) ...[
                        TextFormField(
                          controller: _nombre,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Nombre completo',
                            hintText: 'Ej. María Pérez',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (valor) {
                            if ((valor ?? '').trim().isEmpty) {
                              return 'Escribe tu nombre.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
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
                        onFieldSubmitted: (_) => _enviar(),
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
                        onPressed: procesando ? null : _enviar,
                        icon: procesando
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(_esRegistro ? Icons.person_add : Icons.login),
                        label: Text(
                          procesando
                              ? (_esRegistro ? 'Registrando…' : 'Ingresando…')
                              : (_esRegistro ? 'Crear cuenta' : 'Ingresar'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: procesando ? null : _alternarModo,
                        child: Text(
                          _esRegistro
                              ? '¿Ya tienes una cuenta? Inicia sesión aquí'
                              : '¿No tienes cuenta? Regístrate aquí',
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
