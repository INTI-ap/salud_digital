import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repositorio_firebase.dart';
import 'features/auth/data/auth_repositorio_memoria.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/bloc/sesion_bloc.dart';
import 'features/auth/presentation/bloc/sesion_event.dart';
import 'features/citas/data/citas_repository.dart';
import 'features/citas/data/citas_repositorio_memoria.dart';
import 'features/citas/presentation/bloc/citas_bloc.dart';
import 'features/citas/presentation/bloc/citas_event.dart';
import 'features/medicamentos/data/medicamentos_repository.dart';
import 'features/medicamentos/data/medicamentos_repositorio_memoria.dart';
import 'features/medicamentos/presentation/bloc/medicamentos_bloc.dart';
import 'features/medicamentos/presentation/bloc/medicamentos_event.dart';
import 'firebase_bootstrap.dart';

/// Raíz de la aplicación.
///
/// Gestiona la inyección de repositorios, BLoCs y la navegación declarativa
/// con GoRouter y tema Material 3 accesible.
class AppSalud extends StatefulWidget {
  AppSalud({
    super.key,
    this.resultadoFirebase = ResultadoFirebase.noConfigurado,
    AuthRepository? authRepository,
    CitasRepository? citasRepository,
    MedicamentosRepository? medicamentosRepository,
  })  : _authRepository = authRepository ??
            (resultadoFirebase.inicializado
                ? AuthRepositorioFirebase()
                : AuthRepositorioMemoria()),
        _citasRepository = citasRepository ?? CitasRepositorioMemoria.demo(),
        _medicamentosRepository =
            medicamentosRepository ?? MedicamentosRepositorioMemoria.demo();

  final ResultadoFirebase resultadoFirebase;
  final AuthRepository _authRepository;
  final CitasRepository _citasRepository;
  final MedicamentosRepository _medicamentosRepository;

  @override
  State<AppSalud> createState() => _AppSaludState();
}

class _AppSaludState extends State<AppSalud> {
  late final SesionBloc _sesionBloc;
  late final CitasBloc _citasBloc;
  late final MedicamentosBloc _medicamentosBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _sesionBloc = SesionBloc(widget._authRepository)
      ..add(const VerificarSesion());
    _citasBloc = CitasBloc(widget._citasRepository)
      ..add(const CargarCitas());
    _medicamentosBloc = MedicamentosBloc(widget._medicamentosRepository)
      ..add(const CargarMedicamentos());
    _appRouter = AppRouter(
      sesionBloc: _sesionBloc,
      resultadoFirebase: widget.resultadoFirebase,
    );
  }

  @override
  void dispose() {
    _appRouter.dispose();
    _sesionBloc.close();
    _citasBloc.close();
    _medicamentosBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: widget._authRepository),
        RepositoryProvider<CitasRepository>.value(
          value: widget._citasRepository,
        ),
        RepositoryProvider<MedicamentosRepository>.value(
          value: widget._medicamentosRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SesionBloc>.value(value: _sesionBloc),
          BlocProvider<CitasBloc>.value(value: _citasBloc),
          BlocProvider<MedicamentosBloc>.value(value: _medicamentosBloc),
        ],
        child: MaterialApp.router(
          title: 'Salud Digital',
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.router,
          theme: AppTheme.claro,
          darkTheme: AppTheme.oscuro,
          highContrastTheme: AppTheme.altoContrasteClaro,
          highContrastDarkTheme: AppTheme.altoContrasteOscuro,
          themeMode: ThemeMode.system,
          locale: const Locale('es', 'PE'),
          supportedLocales: const [Locale('es', 'PE')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
