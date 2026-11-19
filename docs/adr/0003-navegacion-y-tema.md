# ADR 0003 — Navegación declarativa con GoRouter, rutas protegidas y tema accesible Material 3

- **Fecha:** 14/11/2026
- **Estado:** aceptada
- **Decisores:** equipo de proyecto, con revisión del docente de SIS048
- **Contexto:** Unidad III, sesión S3 · Guía 09

## Contexto

Tras la implementación de la autenticación con Firebase en la sesión S2, la aplicación requiere un mecanismo robusto y centralizado de navegación que proteja las pantallas de la agenda de citas, el control de medicamentos y el perfil de usuario. 

La navegación imperativa tradicional (`Navigator.push`, `Navigator.pop`) distribuye la lógica de protección entre múltiples widgets, lo que genera estados inconsistentes al cerrar sesión (pantallas protegidas que permanecen en la pila de navegación, uso accidental del botón atrás para retornar a vistas restringidas o bucles de redirección).

Asimismo, la población objetivo del proyecto —personas adultas mayores— exige un estricto cumplimiento de estándares de accesibilidad visual y motora: contraste elevado (mínimo 4.5:1 y 7:1 en alto contraste), soporte nativo para modo claro y oscuro, escalamiento tipográfico hasta 200 % sin desbordamientos de pantalla (overflow), y áreas de toque mínimas de 48 × 48 dp.

## Decisión

1. **Adopción de GoRouter (`go_router: ^18.1.4`)**: Implementar enrutamiento declarativo separando la configuración del router en `lib/app_router.dart` fuera del widget raíz.
2. **Regla de acceso centralizada (`redirect`)**: Concentrar toda la validación de acceso en un único método `evaluarRedireccion(estado, ubicacion)`:
   - Estado `SesionVerificando`: Permanece en `/` (pantalla splash) o redirige a `/` si se intenta acceder a otra ruta.
   - Estado sin autenticación (`SesionSinUsuario` / error): Redirige cualquier ruta protegida (`/citas`, `/medicamentos`, `/perfil`) a `/acceso`.
   - Estado con usuario autenticado (`SesionConUsuario`): Redirige `/` y `/acceso` a `/citas`.
   - Retorna `null` en cualquier otro caso para permitir la navegación solicitada.
3. **Sincronización reactiva mediante `refreshListenable`**: Conectar `RouterRefreshNotifier` (un `ChangeNotifier` en `lib/router_refresh.dart`) al stream de estados de `SesionBloc`. Esto garantiza que eventos como `CerrarSesion` provoquen la reevaluación inmediata de las reglas de redirección sin recurrir a llamadas manuales de `context.go` en los widgets.
4. **ShellRoute para navegación autenticada**: Agrupar las páginas protegidas (`/citas`, `/medicamentos`, `/perfil`) dentro de un `ShellRoute` gestionado por `HomeShell`, sincronizando el `selectedIndex` de la barra inferior `NavigationBar` con `GoRouterState.of(context).matchedLocation`.
5. **Manejo de rutas desconocidas (`errorBuilder`)**: Implementar `PaginaRutaNoEncontrada` para proporcionar una interfaz accesible con opción de retorno al inicio ante URLs o rutas no válidas.
6. **Cuatro variantes de tema Material 3 con `ColorScheme.fromSeed`**:
   - `AppTheme.claro`: Semilla institucional azul `#194D84`, brillo claro.
   - `AppTheme.oscuro`: Brillo oscuro con fondo adaptado `#121418`.
   - `AppTheme.altoContrasteClaro`: Brillo claro con `contrastLevel: 1.0`.
   - `AppTheme.altoContrasteOscuro`: Brillo oscuro con `contrastLevel: 1.0`.
   - Conectados directamente en `MaterialApp.router` (`theme`, `darkTheme`, `highContrastTheme`, `highContrastDarkTheme`, `themeMode: ThemeMode.system`).
7. **Splash nativo Android 12+**: Configuración en `res/values-v31/styles.xml` y `res/values-night-v31/styles.xml` utilizando `windowSplashScreenBackground` y `windowSplashScreenAnimatedIcon`, conservando compatibilidad hacia atrás en `values/styles.xml` mediante `windowBackground`.

## Alternativas consideradas

| Alternativa | Motivo de descarte |
|---|---|
| Navegación imperativa con `Navigator 1.0` | Descentraliza la protección de rutas; requiere comprobaciones en cada `initState` o `build`; propensa a fugas de rutas en la pila al hacer logout. |
| Redirección manual con `context.go` tras logout | Genera condiciones de carrera donde la navegación se ejecuta antes de que el BLoC emita `SesionSinUsuario`, violando la coherencia arquitectónica. |
| Definición manual de colores RGB por pantalla | Inaccesible y no escalable; impide la conmutación dinámica entre modo claro, oscuro y alto contraste del sistema. |
| Splash screen emulado con `Timer` | Penaliza el tiempo de arranque (cold start), genera demoras artificiales no deseadas y no cumple las especificaciones de plataforma de Android 12+. |

## Consecuencias

**Positivas**
- Enrutamiento predecible y 100 % verificable mediante pruebas unitarias puras de la regla de redirección (`test/app_router_test.dart`).
- Logout limpio y seguro: al emitir `CerrarSesion()`, el stream notifica a GoRouter y la vista vuelve a `/acceso` sin que el botón físico "Atrás" de Android pueda reabrir datos de salud privados.
- Cumplimiento estricto de WCAG 2.1 AA / AAA para adultos mayores tanto en contraste de color como en legibilidad con texto escalado al 200 %.

**Riesgos y mitigaciones**
- **Riesgo:** Bucles infinitos en `redirect` si las ramas se contradicen.  
  *Mitigación:* Se estructuraron comprobaciones deterministas y se validaron con pruebas automatizadas que cubren exhaustivamente las combinaciones de estado y ubicación.
- **Riesgo:** Pérdida de contexto de BLoCs en rutas modales o desacopladas.  
  *Mitigación:* Se envolvieron las rutas en un `MultiBlocProvider.value` en la raíz de `AppSalud`, asegurando disponibilidad en cualquier subárbol.

## Evidencia

- `flutter analyze`: 0 observaciones / warnings.
- `flutter test`: 30 pruebas automatizadas pasando con éxito.
- Pruebas unitarias de redirección para todos los estados de sesión.
- Pruebas de widget que validan texto al 200 % y flujo de confirmación de cierre de sesión.
