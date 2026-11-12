import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/data/auth_repositorio_memoria.dart';
import 'features/auth/presentation/bloc/sesion_bloc.dart';
import 'features/auth/presentation/bloc/sesion_event.dart';
import 'features/auth/presentation/bloc/sesion_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/citas/data/citas_repository.dart';
import 'features/citas/data/citas_repositorio_memoria.dart';
import 'features/citas/presentation/bloc/citas_bloc.dart';
import 'features/citas/presentation/bloc/citas_event.dart';
import 'features/medicamentos/data/medicamentos_repository.dart';
import 'features/medicamentos/data/medicamentos_repositorio_memoria.dart';
import 'features/medicamentos/presentation/bloc/medicamentos_bloc.dart';
import 'features/medicamentos/presentation/bloc/medicamentos_event.dart';
import 'firebase_bootstrap.dart';
import 'home_shell.dart';

/// Raíz de la aplicación.
///
/// Los repositorios son inyectables para poder probar la app sin Firebase y para
/// sustituirlos en S2 (autenticación) y S4–S6 (Firestore).
class AppSalud extends StatelessWidget {
  AppSalud({
    super.key,
    this.resultadoFirebase = ResultadoFirebase.noConfigurado,
    AuthRepository? authRepository,
    CitasRepository? citasRepository,
    MedicamentosRepository? medicamentosRepository,
  })  : _authRepository = authRepository ?? AuthRepositorioMemoria(),
        _citasRepository = citasRepository ?? CitasRepositorioMemoria.demo(),
        _medicamentosRepository =
            medicamentosRepository ?? MedicamentosRepositorioMemoria.demo();

  final ResultadoFirebase resultadoFirebase;
  final AuthRepository _authRepository;
  final CitasRepository _citasRepository;
  final MedicamentosRepository _medicamentosRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<CitasRepository>.value(value: _citasRepository),
        RepositoryProvider<MedicamentosRepository>.value(
          value: _medicamentosRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SesionBloc>(
            create: (_) =>
                SesionBloc(_authRepository)..add(const VerificarSesion()),
          ),
          BlocProvider<CitasBloc>(
            create: (_) =>
                CitasBloc(_citasRepository)..add(const CargarCitas()),
          ),
          BlocProvider<MedicamentosBloc>(
            create: (_) => MedicamentosBloc(_medicamentosRepository)
              ..add(const CargarMedicamentos()),
          ),
        ],
        child: MaterialApp(
          title: 'Salud Digital',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.claro,
          locale: const Locale('es', 'PE'),
          supportedLocales: const [Locale('es', 'PE')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: _Inicio(resultadoFirebase: resultadoFirebase),
        ),
      ),
    );
  }
}

/// Decide qué pantalla mostrar según el estado de la sesión.
class _Inicio extends StatelessWidget {
  const _Inicio({required this.resultadoFirebase});

  final ResultadoFirebase resultadoFirebase;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SesionBloc, SesionState>(
      builder: (context, estado) {
        if (estado is SesionVerificando) {
          return const _PantallaCarga();
        }
        if (estado is SesionConUsuario) {
          return HomeShell(resultadoFirebase: resultadoFirebase);
        }
        return const LoginPage();
      },
    );
  }
}

class _PantallaCarga extends StatelessWidget {
  const _PantallaCarga();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Preparando tu agenda…',
              style: tema.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
