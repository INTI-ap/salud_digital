# Checklist de Accesibilidad — Salud Digital del Adulto Mayor
**Curso:** Desarrollo de Software II (SIS048) · Ciclo VII · Semestre 2026-II  
**Docente:** Mtro. Ing. Yover Collantes Valer  
**Guía:** Guía 09 · Sesión S3  
**Fecha:** 14 de noviembre de 2026  

---

## 1. Criterios de Evaluación y Verificación

| N.° | Criterio de Accesibilidad | Estado | Evidencia y Justificación Técnica |
|:---:|:---|:---:|:---|
| **1** | **Contraste de Color (WCAG 2.1 AA / AAA)**<br>Relación de contraste ≥ 4.5:1 para texto normal y ≥ 7:1 en temas de alto contraste. | **CUMPLIDO** | `AppTheme.claro` y `AppTheme.oscuro` generados con `ColorScheme.fromSeed(seedColor: Color(0xFF194D84))`. Variantes `altoContrasteClaro` y `altoContrasteOscuro` configuran `contrastLevel: 1.0` garantizando contraste máximo entre texto y fondo. Verificado en `test/tema_accesibilidad_test.dart`. |
| **2** | **Escalamiento de Texto al 200 %**<br>La interfaz se adapta sin truncamiento, superposiciones ni errores de desbordamiento visual (`RenderFlex overflowed`). | **CUMPLIDO** | Todas las pantallas de entrada y navegación utilizan `ListView` o `SingleChildScrollView` con tipografía relativa (base `bodyLarge: 18sp`). Verificado con prueba de widget automatizada en `test/tema_accesibilidad_test.dart` (`TextScaler.linear(2.0)` a 540x960 dp sin excepciones). |
| **3** | **Áreas de Toque Mínimas (Touch Targets)**<br>Todos los elementos interactivos tienen un tamaño físico efectivo ≥ 48 × 48 dp. | **CUMPLIDO** | Configurado en `AppTheme` mediante `FilledButtonThemeData` y `OutlinedButtonThemeData` con `minimumSize: const Size(64, 48)`. Campos de texto con `contentPadding` de 16 dp vertical. Iconos y destinos de navegación de `NavigationBar` cumplen holgadamente los 48x48 dp. |
| **4** | **Navegación y Lectura con TalkBack**<br>El lector de pantalla anuncia campos de texto, botones, estado de contraseñas y mensajes de error sin ambigüedad. | **CUMPLIDO** | Formularios con `labelText` explícito, `hintText`, y validadores accesibles. Botones con etiquetas textuales directas (`'Ingresar'`, `'Cerrar sesión'`). Iconos decorativos o funcionales cuentan con etiquetas semánticas. |
| **5** | **Retroalimentación de Errores Clara y No Solo por Color**<br>Los estados de error se comunican con texto explícito y no exclusivamente con color rojo. | **CUMPLIDO** | Validadores de campos en login y registro devuelven mensajes descriptivos textuales (*"Ingresa un correo electrónico válido"*, *"La contraseña debe tener al menos 6 caracteres"*). La pantalla de error `PaginaRutaNoEncontrada` incluye icono, título y descripción textual. |
| **6** | **Navegación Predecible y Sin Pérdida de Foco**<br>El flujo entre pantallas es intuitivo y la redirección no desorienta al usuario. | **CUMPLIDO** | Arquitectura declarativa con GoRouter: rutas principales estructuradas en `ShellRoute` con `NavigationBar`. El cierre de sesión solicita confirmación mediante diálogo accesible antes de conmutar de estado. |
| **7** | **Splash Screen de Plataforma Android 12+**<br>Arranque en frío fluido sin bloqueos artificiales con `Timer`. | **CUMPLIDO** | Configurado en `res/values-v31/styles.xml` y `res/values-night-v31/styles.xml` con `windowSplashScreenBackground` y `windowSplashScreenAnimatedIcon`. Compatibilidad retroactiva garantizada con `values/styles.xml`. |

---

## 2. Resultados de Validación Automatizada

```
$ flutter analyze
Analyzing salud_digital...
No issues found! (ran in 0.8s)

$ flutter test
00:09 +30: All tests passed!
```
- **Total de pruebas ejecutadas:** 30
- **Pruebas de BLoC y repositorio:** 19
- **Pruebas de widgets e interacción:** 4
- **Pruebas de temas y escala tipográfica 200 %:** 2
- **Pruebas de AppRouter y redirección de rutas:** 5

---

## 3. Firmas de Conformidad del Equipo de Desarrollo

| Rol / Responsabilidad | Nombre del Integrante | Código UAC | Estado de Conformidad |
|:---|:---|:---:|:---:|
| **Líder de Desarrollo / Arquitectura** | Isaac Quispe | SIS048-UAC | Conforme |
| **Especialista en QA y Accesibilidad** | Equipo Salud Digital | SIS048-UAC | Conforme |
| **Desarrollador Frontend / UI** | Equipo Salud Digital | SIS048-UAC | Conforme |
