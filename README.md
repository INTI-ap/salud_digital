# Salud Digital del Adulto Mayor · código base

Aplicación Android en Flutter para la Unidad III de **Desarrollo de Software II
(SIS048)**. Este repositorio es la **base técnica** del proyecto integrador RSU
«Salud Digital del Adulto Mayor»: agenda de citas, recordatorios de medicamentos y
perfil, organizada con BLoC, repositorios y una estructura por funcionalidad.

> **Estado:** base de la sesión S1. La autenticación real con Firebase, las rutas
> protegidas, Firestore, las notificaciones y la IA se incorporan en las sesiones
> S2 a S11. El código está preparado para crecer sin rehacer la arquitectura.

---

## 1. Qué incluye

- Proyecto Flutter para Android con paquete `pe.edu.uandina.salud_digital`.
- Arquitectura en tres capas y organización **feature-first**.
- Módulos `citas` y `medicamentos` completos sobre repositorios en memoria.
- Módulo `auth` con contrato de repositorio, implementación de demostración y
  `SesionBloc`; en S2 se reemplaza por Firebase Authentication.
- Tema Material 3 con criterios de accesibilidad (texto base 18, objetivos de
  48 × 48, etiquetas semánticas y mensajes de error claros).
- Inicialización tolerante de Firebase: si el proyecto no está configurado, la app
  arranca con datos de demostración y muestra un aviso; no se cae.
- Pruebas de bloques, repositorios y una prueba de widget.
- Documentación: este README, un ADR y la lista del Checkpoint 1.

## 2. Requisitos

| Herramienta | Versión o condición |
|---|---|
| Flutter | Canal estable (probado con 3.41.1 / Dart 3.11) |
| Android Studio | Versión estable con SDK de Android |
| Emulador | Imagen con servicios de Google Play |
| Node.js | 18.0.0 o superior (solo si se configura Firebase) |
| Firebase CLI y FlutterFire CLI | `firebase-tools` y `flutterfire_cli` |

Verificación rápida:

```bash
flutter --version
flutter doctor
flutter doctor --android-licenses
flutter emulators && flutter devices
```

## 3. Puesta en marcha

```bash
# 1. Dependencias
flutter pub get

# 2. Ejecutar sin Firebase (datos de demostración)
flutter run

# 3. Configurar Firebase (recomendado para el Checkpoint 1)
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure --project=<tu-proyecto> --platforms=android

# 4. Volver a ejecutar y comprobar la consola
flutter run
```

Al inicializar correctamente, la consola imprime:

```
Firebase conectado: <identificador-del-proyecto>
```

Si no está configurado, imprime un mensaje de advertencia y la app sigue
funcionando con los repositorios en memoria. El aviso también aparece en la parte
superior de la pantalla principal.

El código inicializa Firebase con `Firebase.initializeApp()` sin opciones: en
Android eso usa la configuración nativa que genera `flutterfire configure`
(`android/app/google-services.json`). Si el equipo prefiere el patrón con
`DefaultFirebaseOptions.currentPlatform`, ejecute la CLI y cambie esa llamada en
`lib/firebase_bootstrap.dart`; el archivo `lib/firebase_options.dart` no contiene
secretos y puede versionarse.

El proyecto usa `minSdk` 24 (`flutter.minSdkVersion`), por encima del mínimo 23 que
exige Firebase para Android, y declara el permiso `INTERNET` en el manifiesto.

### Credenciales de demostración

La implementación en memoria inicia con una sesión de demostración. Si se cierra
sesión, se puede volver a entrar con:

- Correo: `demo@uandina.edu.pe`
- Contraseña: `123456`

Estas credenciales **no** existen en Firebase: son un andamiaje para la S1 y se
eliminan en la S2.

## 4. Estructura

```text
lib/
├── main.dart                     # Arranque: Firebase y runApp
├── app.dart                      # Providers, tema y flujo de sesión
├── firebase_bootstrap.dart       # Inicialización tolerante de Firebase
├── home_shell.dart               # Navegación principal (Citas, Medicamentos, Perfil)
├── core/
│   ├── theme/app_theme.dart      # Material 3 y tipografía accesible
│   ├── utils/fechas.dart         # Formato de fechas en español
│   └── widgets/                  # Estados vacío/error y aviso de configuración
└── features/
    ├── auth/
    │   ├── domain/usuario.dart
    │   ├── data/                 # Contrato + implementación en memoria
    │   └── presentation/         # SesionBloc y pantalla de acceso
    ├── citas/
    │   ├── domain/cita.dart
    │   ├── data/                 # CitasRepository + memoria
    │   └── presentation/         # Bloc, página, tarjeta y formulario
    ├── medicamentos/
    │   ├── domain/medicamento.dart
    │   ├── data/                 # MedicamentosRepository + memoria
    │   └── presentation/         # Bloc, página y formulario
    └── perfil/presentation/      # Estado de la sesión y de Firebase
```

### Regla de dependencia

```text
presentation  →  business logic  →  data  →  fuente de datos
   (UI)            (Bloc/Cubit)     (Repository)   (memoria / Firestore)
```

La presentación no conoce Firestore; la capa de datos no conoce widgets. El bloque
recibe el repositorio por constructor y nunca lo instancia.

## 5. Decisiones de arquitectura

- **BLoC** para el estado: eventos y estados explícitos, pruebas con `bloc_test`.
- **Repositorios** como contrato: en S1 la implementación es en memoria; en S4 se
  sustituye por Firestore sin tocar los bloques ni las pantallas.
- **Feature-first**: cada funcionalidad agrupa `domain`, `data` y `presentation`.
- **Material 3** y accesibilidad desde el primer commit.
- **Firebase opcional en desarrollo**: la app no depende de la nube para arrancar.

El detalle está en [`docs/adr/0001-arquitectura-bloc-firebase.md`](docs/adr/0001-arquitectura-bloc-firebase.md).

## 6. Calidad

```bash
flutter analyze     # sin errores
flutter test        # pruebas de bloques, repositorios y widget
```

O en una sola línea:

```bash
./tool/verificar.sh
```

**Resultado de la verificación (10/11/2026, Flutter 3.41.1 / Dart 3.11.0):**

- `flutter analyze`: `No issues found!`
- `flutter test`: 22 pruebas en verde.
- No se compiló el APK en el entorno de generación porque no incluye Android
  SDK; esa comprobación se hace en el laboratorio con el emulador.

Cobertura actual de la base:

| Prueba | Qué verifica |
|---|---|
| `citas_bloc_test.dart` | Carga, creación, eliminación y estado de error |
| `citas_repositorio_memoria_test.dart` | Contrato del repositorio y lista inmutable |
| `medicamentos_bloc_test.dart` | Carga y creación de medicamentos |
| `sesion_bloc_test.dart` | Sesión de demostración, cierre y error de credenciales |
| `widget_test.dart` | La app abre en la agenda de citas |

## 7. Ruta de la unidad

| Sesión | Qué se agrega a esta base |
|---|---|
| S1 | Estructura, BLoC, repositorios, tema y Firebase inicializado |
| S2 | Firebase Authentication real y formularios accesibles |
| S3 | GoRouter, rutas protegidas y tema Material 3 completo |
| S4–S6 | Firestore, reglas, CRUD en tiempo real y tablero de adherencia |
| S7 | Notificaciones locales y permisos de Android |
| S8 | Modo claro con IA y guardarraíles |
| S9 | Pruebas unitarias, de widgets y de integración |
| S10–S11 | CI con GitHub Actions, AAB firmado y distribución |

## 8. Datos, privacidad y ética

- Solo se usan datos ficticios. No se incorporan nombres, documentos ni historias
  clínicas reales.
- La aplicación no diagnostica, no prescribe y no modifica dosis.
- No se versionan keystore, `key.properties`, claves privadas ni archivos `.env`.
- Los archivos de configuración de Firebase contienen identificadores, no secretos;
  se versionan según la política del equipo.

## 9. Uso de asistentes de IA

- Herramienta: la indicada por el equipo.
- Uso: explicación de conceptos, revisión de borradores y generación de pruebas.
- Verificación: cada fragmento se ejecutó con `flutter analyze` y `flutter test`, y
  el equipo puede explicarlo.
- Datos compartidos: ninguno. No se enviaron datos personales ni de salud.

## 10. Créditos

Universidad Andina del Cusco · Facultad de Ingeniería y Arquitectura · Escuela
Profesional de Ingeniería de Sistemas · SIS048 · Semestre 2026-II.
Docente: Mtro. Ing. Yover Collantes Valer.
