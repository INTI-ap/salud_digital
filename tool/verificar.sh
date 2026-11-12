#!/usr/bin/env bash
# Verificación local del proyecto: dependencias, análisis y pruebas.
set -e
cd "$(dirname "$0")/.."
flutter pub get
flutter analyze
flutter test
echo "Verificación completada: análisis sin errores y pruebas en verde."
