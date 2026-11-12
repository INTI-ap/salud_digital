# ADR 0001 — BLoC, repositorios y Firebase para la agenda de salud

- **Fecha:** 10/11/2026
- **Estado:** aceptada
- **Decisores:** equipo de proyecto, con revisión del docente de SIS048
- **Contexto:** Unidad III, sesión S1

## Contexto

La Unidad II trabajó el estado con Riverpod y la persistencia local. La Unidad III
necesita servicios en la nube, notificaciones, pruebas automatizadas y un paquete
AAB en cinco semanas, con equipos que rotan roles y un dominio sensible: la salud
de personas adultas mayores.

El proyecto debe poder ejecutarse y demostrarse aunque Firebase todavía no esté
configurado, porque el laboratorio no siempre tiene acceso a la consola.

## Decisión

1. **Estado con BLoC.** Un bloque por funcionalidad, con eventos y estados
   explícitos; `Cubit` solo para transiciones simples.
2. **Organización feature-first.** Cada funcionalidad agrupa `domain`, `data` y
   `presentation`.
3. **Repositorios como contrato.** La capa de datos expone una interfaz
   (`CitasRepository`, `MedicamentosRepository`, `AuthRepository`) y una
   implementación intercambiable.
4. **Implementaciones en memoria en S1.** Permiten trabajar sin red y sin cuentas;
   en S2 (auth) y S4–S6 (datos) se reemplazan por Firebase.
5. **Firebase con inicialización tolerante.** `Firebase.initializeApp()` sin
   opciones usa la configuración nativa de Android (`google-services.json`). Si no
   existe, la app informa y continúa con los repositorios en memoria.
6. **Material 3 y accesibilidad desde la base.** Texto base de 18 sp, botones de al
   menos 48 × 48, etiquetas semánticas y errores con texto.

## Alternativas consideradas

| Alternativa | Motivo para no elegirla en esta unidad |
|---|---|
| Continuar con Riverpod | La unidad evalúa trazabilidad evento → estado y pruebas con `bloc_test`; el cambio se decide en el programa. |
| Provider + ChangeNotifier | Menos explícito para auditar transiciones y para el tercer aporte. |
| Estado global con `setState` | No escala a tres funcionalidades ni a pruebas aisladas. |
| Firebase obligatorio desde el inicio | Bloquea el laboratorio sin red o sin cuenta y mezcla configuración con aprendizaje. |

## Consecuencias

**Positivas**

- La interfaz no contiene reglas de negocio y se puede probar por separado.
- Cambiar de memoria a Firestore no obliga a reescribir bloques ni pantallas.
- El equipo puede trabajar sin Firebase y validar el avance con `flutter test`.
- La estructura por funcionalidad reduce conflictos entre integrantes.

**Negativas y riesgos**

- Más archivos por funcionalidad: se compensa con una plantilla común y nombres
  consistentes.
- Dependencia de Firebase y de la cuenta institucional: se mitiga con el modo de
  demostración y un proyecto de respaldo.
- Riesgo de sobreingeniería: si una pantalla solo cambia un valor, se usa un
  `Cubit` y no se inventan eventos.

## Evidencia

- `flutter analyze` sin errores y `flutter test` en verde.
- Captura de la app con Firebase inicializado y el identificador del proyecto.
- Enlace al tablero del equipo.

## Revisión

Se revisa al cierre de la S3, antes de incorporar Firestore, para confirmar que la
separación de capas se mantuvo y que no hay lógica de negocio en los widgets.
