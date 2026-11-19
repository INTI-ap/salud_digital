# Salud Digital del Adulto Mayor · código base

Aplicación Android en Flutter para la Unidad III de **Desarrollo de Software II
(SIS048)**. Este repositorio es la **base técnica** del proyecto integrador RSU
«Salud Digital del Adulto Mayor»: agenda de citas, recordatorios de medicamentos y
perfil, organizada con BLoC, repositorios, Firebase Authentication, navegación declarativa con GoRouter y un tema Material 3 accesible.

> **Estado:** Sesión S3 completada (Guía 09). Incluye autenticación con Firebase Auth, rutas protegidas y navegación declarativa con GoRouter, cuatro variantes de tema Material 3 accesible (claro, oscuro, alto contraste), splash screen nativo de Android 12+, análisis estático limpio y suite de 30 pruebas automatizadas en verde.

---

## 1. Qué incluye

- Proyecto Flutter para Android con paquete `pe.edu.uandina.salud_digital`.
- Arquitectura en tres capas y organización **feature-first**.
- Módulos `citas` y `medicamentos` sobre repositorios en memoria (preparados para Firestore en S4–S6).
- Módulo `auth` con autenticación real de Firebase Authentication (`AuthRepositorioFirebase`) y alternativa en memoria (`AuthRepositorioMemoria`).
- Navegación declarativa con **GoRouter** (`lib/app_router.dart`) y sincronización reactiva de estado (`lib/router_refresh.dart`).
- Rutas públicas (`/`, `/acceso`) y rutas protegidas (`/citas`, `/medicamentos`, `/perfil`) bajo `ShellRoute` con `NavigationBar`.
- Tema Material 3 accesible en cuatro variantes: claro, oscuro, alto contraste claro y alto contraste oscuro (`lib/core/theme/app_theme.dart`).
- Splash screen nativo compatible con Android 12+ (`values-v31/styles.xml`) y versiones previas (`values/styles.xml`).
- 30 pruebas automatizadas unitarias, de bloques, de widgets, de accesibilidad (texto al 200%) y de redirección de rutas.
- Documentación completa: ADR 0001, ADR 0003, checklist de accesibilidad y guía de verificación.

## 2. Requisitos

| Herramienta | Versión o condición |
|---|---|
| Flutter | Canal estable (Flutter 3.44.9+ / Dart 3.11+) |
| Android SDK / Platform Tools | API 24+ (minSdk 24, probado en dispositivo físico Android 9 y emulador) |
| Java JDK | OpenJDK 17 LTS |
| Firebase CLI y FlutterFire CLI | `firebase-tools` y `flutterfire_cli` |

Verificación rápida:

```bash
flutter --version
flutter doctor
flutter devices
```

## 3. Puesta en marcha

```bash
# 1. Obtener dependencias
flutter pub get

# 2. Análisis estático (debe ser 0 observaciones)
flutter analyze

# 3. Ejecutar pruebas automatizadas
flutter test

# 4. Ejecutar en dispositivo físico o emulador
flutter run
```

Al inicializar correctamente, la consola imprime:

```
Firebase conectado: salud-digital-b4c2a
```

Si Firebase no está configurado o no hay conexión de red, la app opera de manera tolerante con repositorios en memoria sin detenerse abruptamente.

### Rutas y Regla de Acceso

| Ruta | Pantalla | Nivel de Protección | Comportamiento |
|---|---|---|---|
| `/` | `PantallaCargaSplash` | Pública | Verifica la sesión. Si termina y no hay sesión → `/acceso`; si hay sesión → `/citas`. |
| `/acceso` | `LoginPage` | Pública | Login y Registro. Si el usuario ya está autenticado, redirige a `/citas`. |
| `/citas` | `CitasPage` | Protegida | ShellRoute pestaña 1. Redirige a `/acceso` si no hay sesión. |
| `/medicamentos` | `MedicamentosPage` | Protegida | ShellRoute pestaña 2. Redirige a `/acceso` si no hay sesión. |
| `/perfil` | `PerfilPage` | Protegida | ShellRoute pestaña 3 y cierre de sesión. Redirige a `/acceso` si no hay sesión. |
| Error | `PaginaRutaNoEncontrada` | Pública | Muestra error amigable ante rutas inexistentes con botón para volver. |

## 4. Estructura del Proyecto

```text
lib/
├── main.dart                     # Arranque: Firebase y runApp
├── app.dart                      # MultiBlocProvider, MaterialApp.router y temas
├── app_router.dart               # Configuración declarativa de GoRouter y redirect
├── router_refresh.dart           # Sincronización Stream BLoC → Listenable GoRouter
├── firebase_bootstrap.dart       # Inicialización tolerante de Firebase
├── firebase_options.dart         # Credenciales de plataforma Firebase
├── home_shell.dart               # ShellRoute con NavigationBar adaptada a GoRouter
├── core/
│   ├── theme/app_theme.dart      # Material 3: claro, oscuro y alto contraste
│   ├── utils/fechas.dart         # Formato de fechas en español
│   └── widgets/                  # Estados vacío, error y avisos
└── features/
    ├── auth/
    │   ├── domain/usuario.dart
    │   ├── data/                 # Repositorio Firebase y Memoria
    │   └── presentation/         # SesionBloc y LoginPage accesible
    ├── citas/
    │   ├── domain/cita.dart
    │   ├── data/                 # CitasRepository + Memoria
    │   └── presentation/         # CitasBloc y CitasPage
    ├── medicamentos/
    │   ├── domain/medicamento.dart
    │   ├── data/                 # MedicamentosRepository + Memoria
    │   └── presentation/         # MedicamentosBloc y MedicamentosPage
    └── perfil/presentation/      # PerfilPage y diálogo accesible de logout
```

## 5. Decisiones de Arquitectura

- **GoRouter Declarativo**: Centraliza la protección de rutas en `app_router.dart` mediante `redirect`, evitando navegaciones imperativas desordenadas.
- **Logout Reactivo sin `context.go`**: El cierre de sesión emite `CerrarSesion()` al BLoC. `RouterRefreshNotifier` detecta el cambio de estado y GoRouter redirige de inmediato a `/acceso`, impidiendo volver a rutas privadas con el botón Atrás.
- **Accesibilidad desde el diseño**: Contraste ≥ 4.5:1 (y 7:1 en alto contraste), soporte nativo de modo oscuro, objetivos táctiles mínimos de 48 × 48 dp y texto base de 18 sp escalable al 200 % sin overflow.

Más detalles en:
- [`docs/adr/0001-arquitectura-bloc-firebase.md`](docs/adr/0001-arquitectura-bloc-firebase.md)
- [`docs/adr/0003-navegacion-y-tema.md`](docs/adr/0003-navegacion-y-tema.md)
- [`docs/checklist-accesibilidad.md`](docs/checklist-accesibilidad.md)

## 6. Calidad y Verificación

```bash
# Análisis estático
flutter analyze

# Suite de pruebas unitarias, de bloques y widgets
flutter test

# Verificación de arranque en frío (Android)
adb shell am force-stop pe.edu.uandina.salud_digital
adb shell am start -n pe.edu.uandina.salud_digital/.MainActivity
```

**Resultado de la verificación (S3 / Guía 09):**
- `flutter analyze`: `No issues found!`
- `flutter test`: 30 pruebas pasando con éxito (100 %).

## 7. Ruta de la Unidad III

| Sesión | Contenido | Estado |
|---|---|:---:|
| S1 | Arquitectura base, BLoC, repositorios y Firebase conectado | Completada |
| S2 | Firebase Authentication con email/contraseña y formularios accesibles | Completada |
| S3 | GoRouter, rutas protegidas, logout reactivo y tema Material 3 accesible | **Completada (Guía 09)** |
| S4–S6 | Firestore, reglas de seguridad, CRUD en tiempo real | Próxima |
| S7 | Notificaciones locales y recordatorios para adultos mayores | Pendiente |
| S8 | Asistente de salud y guardarraíles | Pendiente |
| S9 | Pruebas de integración | Pendiente |
| S10–S11 | CI/CD y generación de bundle AAB | Pendiente |

## 8. Créditos

Universidad Andina del Cusco · Facultad de Ingeniería y Arquitectura · Escuela Profesional de Ingeniería de Sistemas · SIS048 · Semestre 2026-II.  
Docente: Mtro. Ing. Yover Collantes Valer.
