import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_digital/features/auth/data/auth_repositorio_memoria.dart';
import 'package:salud_digital/features/auth/presentation/bloc/sesion_bloc.dart';
import 'package:salud_digital/features/auth/presentation/bloc/sesion_event.dart';
import 'package:salud_digital/features/auth/presentation/bloc/sesion_state.dart';

void main() {
  group('SesionBloc', () {
    blocTest<SesionBloc, SesionState>(
      'verifica la sesión de demostración',
      build: () => SesionBloc(AuthRepositorioMemoria()),
      act: (bloc) => bloc.add(const VerificarSesion()),
      expect: () => <Matcher>[
        isA<SesionVerificando>(),
        isA<SesionConUsuario>().having(
          (estado) => estado.usuario.correo,
          'correo',
          'demo@uandina.edu.pe',
        ),
      ],
    );

    blocTest<SesionBloc, SesionState>(
      'sin sesión previa pasa a SesionSinUsuario',
      build: () => SesionBloc(
        AuthRepositorioMemoria(conSesionDemo: false),
      ),
      act: (bloc) => bloc.add(const VerificarSesion()),
      expect: () => <Matcher>[
        isA<SesionVerificando>(),
        isA<SesionSinUsuario>(),
      ],
    );

    blocTest<SesionBloc, SesionState>(
      'rechaza una contraseña de menos de seis caracteres',
      build: () => SesionBloc(AuthRepositorioMemoria()),
      act: (bloc) => bloc.add(
        const IniciarSesion(correo: 'demo@uandina.edu.pe', contrasena: '123'),
      ),
      wait: const Duration(milliseconds: 400),
      expect: () => <Matcher>[
        isA<SesionIniciando>(),
        isA<SesionError>().having(
          (estado) => estado.mensaje,
          'mensaje',
          contains('6'),
        ),
      ],
    );

    blocTest<SesionBloc, SesionState>(
      'cierra la sesión',
      build: () => SesionBloc(AuthRepositorioMemoria()),
      act: (bloc) => bloc.add(const CerrarSesion()),
      expect: () => <Matcher>[isA<SesionSinUsuario>()],
    );
  });
}
